classdef Config
    properties 
        StopNumber = 200;
        numQueue= 1;
        % vedi se metterei valori di def , nel costruttore check che i
        % vettori siano lunghi come le code. TUTTe le cose sottostanti sono
        % vettori di lunghezza numQueue
        independentArrivalQueue= [true];
        independentServiceQueue= [true];
        independentExitQueue= [true];
        arrivalRate = [0.5];
        serviceRate = 0.6;
        numServers= 1;
        balking= true;
        maxLength= 5;
        minBalking= 5;
        preference= true;
        minPref= 1;
        maxPref= 2;


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