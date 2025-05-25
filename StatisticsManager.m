classdef StatisticsManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    
    properties
        LostClients
        SumLength
        SumWaitingTime
        SumTotalTime
        final_clock
        total_entities
    end
    
    methods
        % Constructor
        function obj = StatisticsManager()
            obj.LostClients= 0;
            obj.SumLength = 0;
            obj.SumWaitingTime= 0;
            obj.SumTotalTime = 0;
            
        end 

        function state = update(state,event)
            % FAI SWITCH
            switch event.type
                case 'arrivo'
                    % Update LostClients
                    if state.lost_client
                        LostClients=LostClients+1;
                        state.lost_client=false;
                    end
                    % Update SumLength
                    SumLength = SumLength + state.LengthQueue*(state.clock-state.lastLengthUpdate);
                    state.lastLengthUpdate=state.clock;
                case 'fine_servizio'
                    
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', event.type);
            end

        end
        
      
        
    end
    
     
end