classdef StatisticsManager < handle
    % Class to manage statistics
    
    properties
        LostClients
        SumLength
        SumWaitingTime
        SumTotalTime
        AverageLength
        AverageWaitingTime
        AverageTotalTime
    end
    
    methods
        % Constructor
        function obj = StatisticsManager(numQueue)
            obj.LostClients= zeros(1,numQueue);
            obj.SumLength = zeros(1,numQueue);
            obj.SumWaitingTime= zeros(1,numQueue);
            obj.SumTotalTime = zeros(1,numQueue);
            
        end 

        function state = update(obj,state,event)
            % Update SumLength
            obj.SumLength(event.queue) = obj.SumLength(event.queue) + state.lengthQueue(event.queue)*(state.clock-state.lastLengthUpdate(event.queue));
            state.lastLengthUpdate(event.queue)=state.clock;

            switch event.type
                case 'arrivo'
                    % Update LostClients
                    if state.lost_client
                        obj.LostClients(event.queue)=obj.LostClients(event.queue)+1;
                        state.lost_client=false;
                    end
                                        
                case 'fine_servizio'

                    % Update SumWaitingTime
                    obj.SumWaitingTime(event.queue) = obj.SumWaitingTime(event.queue) + event.client.WaitingQueueTime(event.queue);
                    
                    % Update SumTotalTime (just at the end...)
                    obj.SumTotalTime(event.queue) = obj.SumTotalTime(event.queue) + (state.clock - event.client.timeQueueArrival(event.queue));
 
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', event.type);
            end

        end

        function clean(obj)
            obj.LostClients= zeros(1,numQueue);
            obj.SumLength = zeros(1,numQueue);
            obj.SumWaitingTime= zeros(1,numQueue);
            obj.SumTotalTime = zeros(1,numQueue);
            obj.AverageLength = zeros(1, numQueue);
            obj.AverageWaitingTime = zeros(1, numQueue);
            obj.AverageTotalTime = zeros(1, numQueue);

        end

        function obj=finalEvaluation(obj,print_stat, final_clock, processedClients)
            obj.AverageLength = obj.SumLength / final_clock;
            obj.AverageWaitingTime = obj.SumWaitingTime ./ processedClients;
            obj.AverageTotalTime = obj.SumTotalTime ./ processedClients;
            if print_stat
                for q=1:length(obj.LostClients)
                    fprintf('Queue %d: Lost Clients = %d\n', q, obj.LostClients(q));
                    fprintf('Queue %d: Average Length = %.2f\n', q, obj.AverageLength(q));
                    fprintf('Queue %d: Average Waiting Time = %.2f\n', q, obj.AverageWaitingTime(q));
                    fprintf('Queue %d: Average Total Time = %.2f\n', q, obj.AverageTotalTime(q));
                end
            end

        end

        function c=stopCount(obj,state)
            c=max(state.processedClients+obj.LostClients);
        end
        
      
        
    end
    
     
end