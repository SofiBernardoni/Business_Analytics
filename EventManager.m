classdef EventManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    properties
        %currentEvent @function_handle
    end

   methods (Abstract)
       
        comp_servers= access_compatible_servers(~,pref);  % Function that associates compatible servers (allowing the access to the client) to the preference (has to be defined when config.preference=true)
        comp_servers= compatible_servers(~,pref);  % Function that associates compatible servers to the preference (has to be defined when config.preference=true)
        newEvent= dependentService(~,time,server,entity,id_queue); % Function that stores an event different from 'fine_servizio' on the queue(has to be defined when config.independentServiceQueue=false) 
        state = exitService(~,state,event); % Function called after 'fine_servizio' on the queue when sth else follows  (has to be defined when config.independentExitQueue=false) 
    end
    
    methods
        %function obj = EventManager()
            % Class constructor
            % Initializing to a null default
            %obj.currentEventHandler = @(,) disp('Nessun handler evento impostato');
        %end

        function [state,fail] = checkAdmission(obj,entity,state, config)
            fail=true;
            if config.preference
                comp_servers= obj.access_compatible_servers(entity.preference);
            else
                comp_servers= [1:config.numServers];
            end
        
            for ser = comp_servers
                if state.servers(ser) == 0
                    fail= false; % the entity can access servers
                    break;
                end
            end
        end

        function [state, newEvent] = enterService(obj,entity,state, id_queue, config)
        
            if config.preference
                comp_servers= obj.compatible_servers(entity.preference);
            else
                comp_servers= [1:numServers];
            end
           
            for s=comp_servers
                if state.servers(s)==0
                    break;
                end
            end
            
            ent=state.queue{1}; %  METTERE IN  STATE.SERVERENTITY PER STATISTICHEEEEE
            state.queue(1)=[];  % exiting the queue
        
            state.servers(s)=1; % server not avavilable anymore
            serviceTime = exprnd(config.serviceMean); % see extension
            % Simulate new end_service on the queue if it's independent
            if config.independentServiceQueue(id_queue)
               newEvent = scheduleEvent(state.time + serviceTime, 'fine_servizio', id_queue);
               newEvent.server=s;
               newEvent.client=ent;
            else
               newEvent= obj.dependentService(state.time + serviceTime,s,ent,id_queue); % metti in metodi astratti
            end


        
        end

        
        function [state, newEvents]= handleArrival(~,state, event, config)

            newEvents={};
            
            enterSystem= true;
            if config.balking
                if state.lengthQueue+1>config.maxLength
                    state.lostClient = true;
                    enterSystem= false;
                elseif state.lengthQueue+1<=config.maxLength && state.lengthQueue+1>=config.minBalking
                    if rand < 0.5 % see if you want to change percentage in config
                        state.lostClient = true;
                        enterSystem= false;
                    end
                end
            end
            
            if enterSystem
                
                if config.independentArrivalQueue(event.queue) % Creating new entity if the queue has independent arrivals
                    newEntity=struct('timeArrival',state.clock);
                    if config.preference
                        pref=randi([config.MinPref config.MaxPref]); % randomly samples the integer preference between config.MinPref and config.MaxPref included
                        newEntity.preference= pref;
                    end
                else % Reading the client if the arrival is NOT independent
                    newEntity = event.client;
                end
                                
                enterQueue= true;
                if state.lengthQueue==0
                    % Check servers 
                    [state,fail] = obj.checkAdmission(newEntity,state, config); % fail=true if not admitted %%%%%%%% DEFINE con evento service time simulato
                    enterQueue=fail;
                    if ~fail
                        [state,newEvent] = obj.enterService(entity,state,event.queue, config);
                        newEvents{end+1}=newEvent;
                    end
                end
               
                if enterQueue
                    state.lengthQueue = state.lengthQueue +1;
                    state.queue{end+1}= newEntity ;
                end

            end
            
            % Simulate new arrival if the queue has independent arrivals
            if config.independentArrivalQueue(event.queue)
                interArrivalTime= exprnd(config.arrivalRate); %  vedi se mettere distribuzione generica
                newEvent = scheduleEvent(state.clock + interArrivalTime, 'arrivo', event.queue);
                newEvents{end+1}=newEvent;
            end

        end

        function [state, newEvents]= handleEndService(~,state, event, config)
            newEvents={};
            state.servers(event.server)= 0; %server again available
            fail= false;
            while state.lengthQueue>0 && ~fail
                newEntity= state.queue{1} ; % first entity in the queue
                [state,fail] = obj.checkAdmission(newEntity,state, config); % fail=true if not admitted 
                if ~fail
                    [state, newEvents] = obj.enterService(newEntity,state,event.queue, config);
                    newEvents{end+1}=newEvents;
                end
            end

            if ~config.independentExitQueue(event.queue)
                [state, new_events]= obj.exitService(state,event);
                newEvents= [newEvents new_events]; % adding new events to the list
            end
            
        end


        function currentEvent= handleEvent(obj, eventType)
            % handleEvent takes the event type as an input argument
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