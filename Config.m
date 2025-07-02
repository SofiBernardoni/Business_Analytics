classdef Config
    properties 
        StopNumber = 200;
        numQueue= 1;
        
        numServers= [1];

        independentArrivalQueue
        independentServiceQueue
        independentExitQueue

        arrivalMode
        serviceMode
        
        balking
        maxLength
        minBalking
        preference
        minPref
        maxPref


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

            basicMode = {'iid', 'exponential', 1};
            obj.arrivalMode = repmat({basicMode}, 1, numQueue);
            obj.serviceMode = repmat({basicMode}, 1, numQueue);

            % Initializing queues with no balking
            obj.balking= false(1,numQueue);
            obj.maxLength=[];
            obj.minBalking=[];

            % nitializing queues with no preference
            obj.preference = false(1,numQueue);
            obj.minPref=[];
            obj.maxPref=[];

        end

        function obj=assignDependencies(obj,DependentArrivalQueues, DependentServiceQueues, DependentExitQueues)
            % Input args:
            % DependentArrivalQueues= list of queue ids. Queues with dependent arrivals 
            % DependentServiceQueues= list of queue ids. Queues with dependent services (i.e. service completion time does not just correspond to serive time)
            % DependentExitQueues= list of queue ids. Queues with dependent exit (i.e. entity exiting the queue don't just leave the system)
            
            obj.independentArrivalQueue(DependentArrivalQueues)= false;
            obj.independentServiceQueue(DependentServiceQueues)= false;
            obj.independentExitQueue(DependentExitQueues)= false;
        end

        function obj=assignTimes(obj, arrivalModes, serviceModes)
            % arrivalModes, serviceModes = cell arrays of TimeGenerator inputs  
            if length(arrivalModes)~=obj.numQueue || length(serviceModes)~=obj.numQueue
                error("Input length not corresponding to the number of queues")
            else
                obj.arrivalMode=arrivalModes;
                obj.serviceMode=serviceModes;
            end
        end

        function obj= assignPreferences(obj,preferenceQueues, minPrefs, maxPrefs )
            % Input args:
            % preferenceQueues= list of queue ids. Queues with preference
            % minPrefs, maxPrefs= list of integers. minimum e maximum values of preference (in the queues with preference with order given by preferenceQueues)

            if length(preferenceQueues)~=length(minPrefs) || length(preferenceQueues)~=length(maxPrefs)
                error('minPrefs or maxPrefs length not maching the number of queues with preference ')
            else
                j=1;
                for p=preferenceQueues
                    obj.preference(p)= true;
                    obj.minPref(p) = minPrefs(j);
                    obj.maxPref(p) = maxPrefs(j);
                    j=j+1;
                end
            end

        end

        function obj=assignBalking(obj,balkingPreferences, minBalkings, maxLengths  )
            % Input args:
            % balkingPreferences= list of queue ids. Queues with balking
            % minBalkings= list of integers. Minimum length of the queue leading to balking (entities entering with probability <1)
            % maxLengths = list of integers. Maximum length of the queue (entities arriving leave immediately)
            if length(balkingPreferences)~=length(minBalkings) || length(balkingPreferences)~=length(maxLengths)
                error('minBalkings or maxLengths length not maching the number of queues with balking ')
            else
                j=1;
                for p=balkingPreferences
                    obj.balking(p)= true;
                    obj.minBalking(p) = minBalkings(j);
                    obj.maxLength(p) = maxLengths(j);
                    j=j+1;
                end
            end
        end
            
            
       
    end
        
        
end