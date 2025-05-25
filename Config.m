classdef Config
    properties 
        StopNumber = 200;
        arrivalRate = 0.5;
        serviceRate = 0.6;
        numServers= 1;
    end

    methods
        function obj=Config(StopNumber,arrivalRate,serviceRate,numServers)
            obj.StopNumber = StopNumber;
            obj.arrivalRate = arrivalRate;
            obj.serviceRate = serviceRate;
            obj.numServers= numServers;
        end
    end
end