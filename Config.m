classdef Config
    properties 
        StopNumber = 200;
        numQueue= 1;
        
        % vedi se metterei valori di def , nel costruttore check che i
        % vettori siano lunghi come le code. TUTTe le cose sottostanti sono
        % vettori di lunghezza numQueue
        numServers= [1];
        independentArrivalQueue= [true];
        independentServiceQueue= [true];
        independentExitQueue= [true];
        arrivalRate = [0.5]; % METTI A POSTO
        serviceRate = [0.6]; % METTI A POSTO
        balking= [true];
        maxLength= [5];
        minBalking= [5];
        preference= [true];
        minPref= [1];
        maxPref= [2];


    end

    methods
        function obj=Config(StopNumber,numQueue, numServers)
            % Input args:
            % StopNumber= integer. Number of entities used as stopping condition for the simulation
            % numQueue= integer. Number of queues in the system
            % numServers= list of integers. Number of servers for each queue

            obj.StopNumber = StopNumber;
            obj.numQueue= numQueue;
            
            if length(numServers)~= numQueue
                error('numServers length not corresponding to the number of queues')
            else
                obj.numServers = numServers;
            end

            % Initializing queues as indpendent
            obj.independentArrivalQueue= true(1,numQueue);
            obj.independentServiceQueue= true(1,numQueue);
            obj.independentExitQueue= true(1,numQueue);

            % Initializing queues with no balking
            obj.balking= false(1,numQueue);

            % nitializing queues with no preference
            obj.preference = false(1,numQueue);

        end

        function obj=assignDependencies(DependentArrivalQueues, DependentServiceQueues, DependentExitQueues )
            % Input args:
            % DependentArrivalQueues= list of queue ids. Queues with dependent arrivals 
            % DependentServiceQueues= list of queue ids. Queues with dependent services (i.e. service completion time does not just correspond to serive time)
            % DependentExitQueues= list of queue ids. Queues with dependent exit (i.e. entity exiting the queue don't just leave the system)
        end

        function obj=assignTimeRates()
            % mettere a posto in base a cosa si deve passare a time manager
            %obj.arrivalRate = arrivalRates;
            %obj.serviceRate = serviceRates;
        end

        function obj=assignPreferences()

        end

        function obj=assignBalking()
        end


    end
end