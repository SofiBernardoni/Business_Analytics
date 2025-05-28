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

        
        function [state, newEvent]= handleArrival(state, event, config)
            
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
                    [state,fail] = checkAdmission(newEntity,state, config); % fail=true if not admitted %%%%%%%% DEFINE con evento service time simulato
                    enterQueue=fail;
                    if ~fail
                        state = enterService(entity,state);
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

        function [state, newEvent]= handleEndService(state, event, config)
            state.servers(event.server)= 0; %server again available
            if state.lengthQueue>0
                newEntity= state.queue{1} ; % first entity in the queue
                [state,fail] = checkAdmission(newEntity,state, config); % fail=true if not admitted 
                if ~fail
                    [state, newEvent] = enterService(entity,state);
                end
            else % empty queue
                newEvent=[];
            end

        end

        function [state, newEvent]= handleInternalQueue(state, event, config)
            state.servers(event.server)= 0; %server again available
            if state.lengthQueue>0
                newEntity= state.queue{1} ; % first entity in the queue
                [state,fail] = checkAdmission(newEntity,state, config); % fail=true if not admitted 
                if ~fail
                    [state, newEvent] = enterService(entity,state);
                end
            else % empty queue
                newEvent=[];
            end

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