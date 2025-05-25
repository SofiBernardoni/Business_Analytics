classdef EventManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    properties
        currentEvent @function_handle
    end
    
    methods
        function obj = EventManager()
            % Class constructor
            % Initializing to a null default
            obj.currentEventHandler = @(,) disp('Nessun handler evento impostato');
        end

        function [state, newEvent,newEventGenerated]= handleArrival(state, event, config)
            
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
                    [state,fail] = checkAdmission(newEntity,state); % fail=true if not admitted %%%%%%%% DEFINE con evento service time simulato 
                    enterQueue=fail;
                end
               
                if enterQueue
                    state.lengthQueue = state.lengthQueue +1;
                    state.queue{end+1}= newEntity ;
                end

            end
            
            % Simulate new arrival
            interArrivalTime= exprnd(config.arrivalRate);
            newEvent = scheduleEvent(state.clock + interArrivalTime, 'arrivo');
            newEventGenerated= true;

        end

        function [state, newEvent,newEventGenerated]= handleEndService(state, event, config)
            state.servers(event.server)=0; %server again available
            if state.lengthQueue>0
                newEntity= state.queue{1} ; % first entity in the queue
                [state,fail] = checkAdmission(newEntity,state); % fail=true if not admitted 
                if ~fail
                    state.queue(1)=[];
                    %serviceTime = exprnd(config.serviceMean);
                    %newEvent = scheduleEvent(state.time + serviceTime, 'fine_servizio', struct('server', server));
                end
            else % empty queue
                newEvent=[];
            end

        end

        function handleEvent(obj, eventType)
            % handleEvent takes the event type as an input argument
            switch eventType
                case 'arrivo'
                    obj.currentEvent= @obj.handleArrival; 
                case 'fine_servizio'
                    obj.currentEvent= @obj.handleEndService; 
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', eventType);
            end
        end
end


end