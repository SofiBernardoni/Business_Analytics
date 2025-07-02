% SIMULATION EXAMPLE: M/M/1 queue with balking and multiple repetitions

StopNumber = 200;
numQueue = 1;
numServers = [1];
min_balking = 10;
max_length = 15;
arrivalRate = 3;
serviceRate = 4;

% Numero di ripetizioni della simulazione
numRepetitions = 100;

% Array per salvare risultati delle statistiche (es: tempo medio in coda)
meanWaitingTimes = zeros(1, numRepetitions);
meanQueueLengths = zeros(1, numRepetitions);
balkedCustomers = zeros(1, numRepetitions);

for k = 1:numRepetitions

    % Creating Config object with the configuration of the problem
    configuration = Config(StopNumber, numQueue, numServers);
    configuration.assignTimes({{'iid', 'exponential', arrivalRate}},{{'iid', 'exponential', serviceRate}});
    configuration.assignBalking([1], min_balking, max_length);

    EventMgr= EventManager(configuration); % Creating Event Manager
    StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
    SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

    SimMgr.SimulateEvents(configuration);

    % StatMgr.finalEvaluation(false, EventMgr.state.clock, EventMgr.state.processedClients);

    % Salva i risultati
    meanWaitingTimes(k) = StatMgr.AverageWaitingTime(1);
    meanQueueLengths(k) = StatMgr.AverageLength(1);
    balkedCustomers(k) = StatMgr.LostClients(1); 

end

% Calcolo medie e deviazioni standard sui risultati
fprintf('Tempo medio di attesa: %.4f ± %.4f\n', mean(meanWaitingTimes), std(meanWaitingTimes));
fprintf('Lunghezza media della coda: %.4f ± %.4f\n', mean(meanQueueLengths), std(meanQueueLengths));
fprintf('Clienti che hanno rinunciato (balked): %.2f ± %.2f\n', mean(balkedCustomers), std(balkedCustomers));
