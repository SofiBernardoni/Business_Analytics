classdef EventManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    properties
        %currentEvent @function_handle
    end
    
    methods
        %function obj = EventManager()
            % Class constructor
            % Initializing to a null default
            %obj.currentEventHandler = @(,) disp('Nessun handler evento impostato');
        %end

        function [state,fail] = checkAdmission(~,entity,state, config)
            fail=true;
            if config.preference
                comp_servers= compatible_servers(entity.preference);
            else
                comp_servers= [1:numServers];
            end
        
            for ser = comp_servers
                if state.servers(ser) == 0
                    fail= false; % the entity can access servers
                    break;
                end
            end
        end

        function [state, newEvent] = enterService(~,entity,state)
        
            if config.preference
                comp_servers= compatible_servers(entity.preference);
            else
                comp_servers= [1:numServers];
            end
           
            for s=comp_servers
                if state.servers(s)==0
                    break;
                end
            end
            
            state.queue(1)=[]; % exiting the queue
        
            state.servers(s)=1; % server not avavilable anymore
            serviceTime = exprnd(config.serviceMean); % see extension
            newEvent = scheduleEvent(state.time + serviceTime, 'fine_servizio', struct('server', s));
        
        end

        function [state] = exitService(~,entity,state) % mettere come metodo astratto??
        end
        
        
        function [state, newEvent]= handleArrival(~,state, event, config)
            
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
                
                % Creating new entity
                newEntity=struct('timeArrival',state.clock);
                if config.preference
                    pref=randi([config.MinPref config.MaxPref]); % randomly samples the integer preference between config.MinPref and config.MaxPref included
                    newEntity.preference= pref;
                end
                
                enterQueue= true;
                if state.lengthQueue==0
                    % Check servers
                    [state,fail] = obj.checkAdmission(newEntity,state, config); % fail=true if not admitted %%%%%%%% DEFINE con evento service time simulato
                    enterQueue=fail;
                    if ~fail
                        state = obj.enterService(entity,state);
                    end
                end
               
                if enterQueue
                    state.lengthQueue = state.lengthQueue +1;
                    state.queue{end+1}= newEntity ;
                end

            end
            
            % Simulate new arrival
            interArrivalTime= exprnd(config.arrivalRate); %  vedi se mettere distribuzione generica
            newEvent = scheduleEvent(state.clock + interArrivalTime, 'arrivo');

        end

        function [state, newEvent]= handleEndService(~,state, event, config)
            state.servers(event.server)= 0; %server again available
            if state.lengthQueue>0
                newEntity= state.queue{1} ; % first entity in the queue
                [state,fail] = obj.checkAdmission(newEntity,state, config); % fail=true if not admitted 
                if ~fail
                    [state, newEvent] = obj.enterService(entity,state);
                end
            else % empty queue
                newEvent=[];
            end

            state= obj.exitService(entity,state); % da definire meglio..

        end

        function [state, newEvent]= handleInternalQueue(~, state, event, config)
            % boh

        end

        function currentEvent= handleEvent(obj, eventType)
            % handleEvent takes the event type as an input argument
            switch eventType
                case 'arrivo'
                    currentEvent= @obj.handleArrival; 
                case 'fine_servizio'
                    currentEvent= @obj.handleEndService; 
                case 'internal_queue'
                    currentEvent= @obj.handleInternalQueue; 
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', eventType);
            end
        end
end


end