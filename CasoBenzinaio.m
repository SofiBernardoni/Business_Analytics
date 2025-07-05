% SIMULATION EXAMPLE: benzinaio
% vedere se cambiare i parametri 


clear all
rng(1234)

StopNumber = 800;
numQueue= 2;
numServers= [4,1];
arrivalRate1 = 1;
serviceRate1 = 0.5;
serviceRate2 = 1;
maxLength = 5;

minPref=1;
maxPref=2;

numRepetitions = 100;

meanWaitingTimes = zeros(1, numRepetitions);
meanQueueLengths = zeros(1, numRepetitions);
lostClients = zeros(1, numRepetitions);

for k = 1:numRepetitions
    % Creating Config object with the configuration of the problem
    configuration = Config(StopNumber,numQueue, numServers);
    configuration= configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{}},{{'iid', 'exponential', serviceRate1},{'iid', 'exponential',serviceRate2}});
    configuration=configuration.assignDependencies([2], [1], [2]);
    configuration=configuration.assignPreferences([1], minPref, maxPref );
    configuration = assignBalking(configuration, [1], maxLength, maxLength);
    
    EventMgr= EventManagerBenzinaio(configuration); % Creating Event Manager
    StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
    SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager
    
    SimMgr.SimulateEvents(configuration);

    meanWaitingTimes(k) = StatMgr.AverageWaitingTime(1);  
    meanQueueLengths(k) = StatMgr.AverageLength(1);      
    lostClients(k) = StatMgr.LostClients(1);     

end

% Media e deviazione standard
mediaWT = mean(meanWaitingTimes);
stdWT = std(meanWaitingTimes);

mediaQL = mean(meanQueueLengths);
stdQL = std(meanQueueLengths);

mediaLost = mean(lostClients);
stdLost = std(lostClients);

% Intervallo di confidenza 95%
confLevel = 0.95;
alpha = 1 - confLevel;
z = norminv(1 - alpha/2);  % valore z per 95%

ciWT = z * stdWT / sqrt(numRepetitions);
ciQL = z * stdQL / sqrt(numRepetitions);
ciLost = z * stdLost / sqrt(numRepetitions);

fprintf('Tempo medio attesa: %.4f ± %.4f\n', mediaWT, ciWT);
fprintf('Lunghezza media coda: %.4f ± %.4f\n', mediaQL, ciQL);
fprintf('Clienti persi (balked): %.2f ± %.2f\n', mediaLost, ciLost);

