classdef EventManager < handle
    % Class to manage events
    
    properties
        %currentEvent @function_handle
        TimeArrivalMgr = [];
        TimeServiceMgr=[];
    end

    methods
        % Methods not implemented in the general version (abstract ones)

        % Function that associates compatible servers (allowing the access to the client) to the preference (has to be defined when config.preference=true)
        function comp_servers= access_compatible_servers(~,pref)
        end

        % Function that associates compatible servers to the preference (has to be defined when config.preference=true)
        function comp_servers= compatible_servers(~,pref)
        end
        
        % Function that stores an event different from 'fine_servizio' on the queue(has to be defined when config.independentServiceQueue=false) 
        function newEvent= dependentService(~,clock, serviceTime,server,entity,id_queue)
        end

        % Function called after 'fine_servizio' on the queue when sth else follows  (has to be defined when config.independentExitQueue=false) 
        function state = exitService(~,state,event)
        end

        % Methods implemented

        function obj = EventManager(config)
            % Class constructor
            % Initializing to a null default
            for i=1:config.numQueue
                obj.TimeArrivalMgr{i} = TimeGenerator(config.arrivalMode{i}{:});
                obj.TimeServiceMgr{i} = TimeGenerator(config.serviceMode{i}{:});
            end
            
        end

        function [state,fail] = checkAdmission(obj,id_queue, entity,state, config)
            % Function that checks if entity can access server
            fail=true;
            if config.preference(id_queue)
                comp_servers= obj.access_compatible_servers(entity.preference);
            else
                comp_servers= 1:config.numServers(id_queue);
            end
        
            for ser = comp_servers
                if state.servers{id_queue}(ser) == 0
                    fail= false; % the entity can access servers
                    break;
                end
            end
        end

        function [state, newEvent] = enterService(obj,entity,state, id_queue, config)
            % Function that manages the entity accessing the service

            if config.preference(id_queue)
                comp_servers= obj.compatible_servers(entity.preference);
            else
                comp_servers= 1:config.numServers(id_queue);
            end
           
            for s=comp_servers
                if state.servers{id_queue}(s)==0
                    break;
                end
            end
            
            if state.lengthQueue(id_queue)> 0 % the entity was waiting in the queue
                entity.WaitingQueueTime(id_queue) = state.clock - entity.timeQueueArrival(id_queue); % waiting time in queue id_queue
                state.queue{id_queue}(1)=[];  % exiting the queue
                state.lengthQueue(id_queue) = state.lengthQueue(id_queue)-1;
            end
        
            state.servers{id_queue}(s)=1; % server not avavilable anymore

            serviceTime = obj.TimeServiceMgr{id_queue}.sample(state.clock, state.lengthQueue(id_queue), []);

            % Simulate new end_service on the queue if it's independent
            if config.independentServiceQueue(id_queue)
               newEvent = EventUtils.scheduleEvent(state.clock + serviceTime, 'fine_servizio', id_queue,entity,s);
               newEvent.serviceTime = serviceTime;
            else
               newEvent= obj.dependentService(state.clock,serviceTime,s,entity,id_queue); % metti in metodi astratti
            end

            
      
        end

        
        function [state, newEvents]= handleArrival(obj,state, event, config)
            % Function that handles 'arrivo' events

            newEvents={};
            
            enterSystem= true;
            if config.balking(event.queue)
                if state.lengthQueue(event.queue)+1>config.maxLength(event.queue)
                    state.lostClient = true;
                    enterSystem= false;
                elseif state.lengthQueue(event.queue)+1<=config.maxLength(event.queue) && state.lengthQueue(event.queue)+1>=config.minBalking(event.queue)
                    if rand < 0.5 % see if you want to change percentage in config
                        state.lostClient = true;
                        enterSystem= false;
                    end
                end
            end
            
            if enterSystem
                newEntity = event.client;
                                
                enterQueue= true;
                if state.lengthQueue(event.queue)==0
                    % Check servers 
                    [state,fail] = obj.checkAdmission(event.queue,newEntity,state, config); % fail=true if not admitted %%%%%%%% DEFINE con evento service time simulato
                    enterQueue=fail;
                    if ~fail
                        [state,newEvent] = obj.enterService(newEntity,state,event.queue, config);
                        newEvents{end+1}=newEvent;
                    end
                end
               
                if enterQueue
                    state.lengthQueue(event.queue) = state.lengthQueue(event.queue) +1;
                    state.queue{event.queue}{end+1}= newEntity ;
                end

            end
            
            % Simulate new arrival if the queue has independent arrivals
            if config.independentArrivalQueue(event.queue)
                interArrivalTime = obj.TimeArrivalMgr{event.queue}.sample(state.clock, state.lengthQueue(event.queue), []);
                time_arrival= state.clock + interArrivalTime;
                % Creating new entity (client)
                newEntity=struct('timeQueueArrival',zeros(1,config.numQueue), 'WaitingQueueTime',zeros(1,config.numQueue));
                if config.preference(event.queue)
                    pref=randi([config.minPref(event.queue) config.maxPref(event.queue)]); % randomly samples the integer preference between config.MinPref and config.MaxPref included
                    newEntity.preference= pref;
                end
                newEvent = EventUtils.scheduleEvent(time_arrival, 'arrivo', event.queue, newEntity);
                newEvent.client.timeQueueArrival(event.queue) = time_arrival;
                newEvents{end+1}=newEvent;
            end

        end

        function [state, newEvents]= handleEndService(obj,state, event, config)
            % Function that handles 'fine_servizio' events
            state.processedClients(event.queue)= state.processedClients(event.queue)+1;
            newEvents={};
            state.servers{event.queue}(event.server)= 0; %server again available
            fail= false;
            while state.lengthQueue(event.queue)>0 && ~fail
                newEntity= state.queue{event.queue}{1} ; % first entity in the queue
                [state,fail] = obj.checkAdmission(event.queue, newEntity,state, config); % fail=true if not admitted 
                if ~fail
                    [state, newEvent] = obj.enterService(newEntity,state,event.queue, config);
                    newEvents{end+1}=newEvent;
                end
            end

            if ~config.independentExitQueue(event.queue)
                [state, new_events]= obj.exitService(state,event);
                newEvents= [newEvents new_events]; % adding new events to the list
            end
            
        end


        function currentEvent= handleEvent(obj, eventType)
            % handleEvent takes the event type as an input argument and gives back the correct handling function
            switch eventType
                case 'arrivo'
                    currentEvent= @obj.handleArrival; 
                case 'fine_servizio'
                    currentEvent= @obj.handleEndService; 
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', eventType);
            end
        end
end


end