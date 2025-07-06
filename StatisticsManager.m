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
        ServerBusyTime      
        AverageUtilization 
    end
    
    methods
        % Constructor
        function obj = StatisticsManager(numQueue)
            obj.LostClients= zeros(1,numQueue);
            obj.SumLength = zeros(1,numQueue);
            obj.SumWaitingTime= zeros(1,numQueue);
            obj.SumTotalTime = zeros(1,numQueue);
            obj.ServerBusyTime = zeros(1, numQueue); 
            obj.AverageUtilization = zeros(1, numQueue);
        end 

        % Function that updates the variables used to compute the statistics at the end
        function state = update(obj,state,event)
            % Update SumLength
            obj.SumLength(event.queue) = obj.SumLength(event.queue) + state.lengthQueue(event.queue)*(state.clock-state.lastLengthUpdate(event.queue));
            state.lastLengthUpdate(event.queue)=state.clock;

            switch event.type
                case 'arrivo'
                    % Update LostClients
                    if state.lostClient
                        obj.LostClients(event.queue)=obj.LostClients(event.queue)+1;
                        state.lostClient=false;
                    end
                                       
                case 'fine_servizio'

                    % Update SumWaitingTime
                    obj.SumWaitingTime(event.queue) = obj.SumWaitingTime(event.queue) + event.client.WaitingQueueTime(event.queue);
                    
                    % Update SumTotalTime (just at the end...)
                    obj.SumTotalTime(event.queue) = obj.SumTotalTime(event.queue) + (state.clock - event.client.timeQueueArrival(event.queue));
 
                    % Server Busy Time
                    obj.ServerBusyTime(event.queue) = obj.ServerBusyTime(event.queue) + event.serviceTime;
                                 
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', event.type);
            end

        end

        %Function that clears all statistics
        function clean(obj,numQueue)
            obj.LostClients= zeros(1,numQueue);
            obj.SumLength = zeros(1,numQueue);
            obj.SumWaitingTime= zeros(1,numQueue);
            obj.SumTotalTime = zeros(1,numQueue);
            obj.AverageLength = zeros(1, numQueue);
            obj.AverageWaitingTime = zeros(1, numQueue);
            obj.AverageTotalTime = zeros(1, numQueue);
            obj.ServerBusyTime = zeros(1, numQueue);
            obj.AverageUtilization = zeros(1, numQueue);

        end
        
        %Function that computes final statistics and (if requested) prints them
        function obj=finalEvaluation(obj,print_stat, final_clock, processedClients, numServers)
            obj.AverageLength = obj.SumLength / final_clock;
            obj.AverageWaitingTime = obj.SumWaitingTime ./ processedClients;
            obj.AverageTotalTime = obj.SumTotalTime ./ processedClients;
            obj.AverageUtilization = obj.ServerBusyTime ./ (final_clock*numServers);
            if print_stat
                for q=1:length(obj.LostClients)
                    fprintf('Queue %d: Lost Clients = %d\n', q, obj.LostClients(q));
                    fprintf('Queue %d: Average Length = %.2f\n', q, obj.AverageLength(q));
                    fprintf('Queue %d: Average Waiting Time = %.2f\n', q, obj.AverageWaitingTime(q));
                    fprintf('Queue %d: Average Total Time = %.2f\n', q, obj.AverageTotalTime(q));
                    fprintf('Queue %d: Average Utilization = %.2f%%\n', q, obj.AverageUtilization(q) * 100);
                end
            end

        end

        function c=stopCount(obj,state)
            c=max(state.processedClients+obj.LostClients);
        end
        
      
        
    end
    
     
end