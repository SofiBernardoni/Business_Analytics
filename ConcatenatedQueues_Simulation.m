% SIMULATION EXAMPLE: Series of concatenated queues

clear all

rng(123)

% Number of repetitions of the simulation
n_sim = 100;

% System configuration
StopNumber = 500;
numQueue= 2;
arrivalRate1 = 6;
serviceRate = [4,7];
maxLength = [5,8];
numServers= [1,1];

fprintf('%d code consecutive:',numQueue);

% Vectors of statistics
AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);
AverageServerTime_all = zeros(numQueue,n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration= configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{}},{{'iid', 'exponential', serviceRate(1)},{'iid', 'exponential',serviceRate(2)}});
configuration= configuration.assignDependencies([2], [], [1]);
configuration = assignBalking(configuration, [1 2], [maxLength(1),maxLength(2)],[maxLength(1),maxLength(2)]);

EventMgr= EventManagerSerie(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager
    
for k = 1:n_sim
    
    SimMgr.print_stat=false;
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all(:, k) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, k) = StatMgr.AverageTotalTime;
    AverageLength_all(:, k) = StatMgr.AverageLength;
    AverageServerTime_all(:, k) = StatMgr.AverageUtilization;
    LostClients_all(:, k) = StatMgr.LostClients;   

    StatMgr.clean(configuration.numQueue);

end

alpha = 0.05;
z = norminv(1 - alpha/2); 

% -- Average Waiting Time --
mean_AverageWaitingTime = mean(AverageWaitingTime_all, 2);  
std_AverageWaitingTime = std(AverageWaitingTime_all, 0, 2);
ci_AverageWaitingTime = z * std_AverageWaitingTime / sqrt(n_sim);

% -- Average Total Time --
mean_AverageTotalTime = mean(AverageTotalTime_all, 2);
std_AverageTotalTime = std(AverageTotalTime_all, 0, 2);
ci_AverageTotalTime = z * std_AverageTotalTime / sqrt(n_sim);

% -- Average Length --
mean_AverageLength = mean(AverageLength_all, 2);
std_AverageLength = std(AverageLength_all, 0, 2);
ci_AverageLength = z * std_AverageLength / sqrt(n_sim);

% -- Lost Clients --
mean_LostClients = mean(LostClients_all, 2);
std_LostClients = std(LostClients_all, 0, 2);
ci_LostClients = z * std_LostClients / sqrt(n_sim);

% -- Average Service Time --
mean_AverageServerTime = mean(AverageServerTime_all);
std_AverageServerTime = std(AverageServerTime_all ,0);
ci_AverageServerTime = z * std_AverageServerTime  / sqrt(n_sim);

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients(q), ci_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
    fprintf('  Average Server Utilization  = %.2f ± %.2f\n', mean_AverageServerTime(q), ci_AverageServerTime(q));
end


%% With more queues
rng(123)

numQueue= 4;
arrivalRate1 = 6;
serviceRate = [4,7,3,9];
maxLength = [5,8,5,8];
numServers= [1,1,1,1];

fprintf('%d code consecutive:',numQueue);

% Vectors of statistics
AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);
AverageServerTime_all = zeros(numQueue,n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration= configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{},{},{}},{{'iid', 'exponential', serviceRate(1)},{'iid', 'exponential',serviceRate(2)},{'iid', 'exponential',serviceRate(3)},{'iid', 'exponential',serviceRate(4)}});
configuration= configuration.assignDependencies([2 3 4], [], [1 2 3]);
configuration = assignBalking(configuration, [1 2 3 4], maxLength,maxLength);

EventMgr= EventManagerSerie(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager
    
for k = 1:n_sim
    
    SimMgr.print_stat=false;
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all(:, k) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, k) = StatMgr.AverageTotalTime;
    AverageLength_all(:, k) = StatMgr.AverageLength;
    AverageServerTime_all(:, k) = StatMgr.AverageUtilization;
    LostClients_all(:, k) = StatMgr.LostClients;   

    StatMgr.clean(configuration.numQueue);

end

alpha = 0.05;
z = norminv(1 - alpha/2); 

% -- Average Waiting Time --
mean_AverageWaitingTime = mean(AverageWaitingTime_all, 2);  
std_AverageWaitingTime = std(AverageWaitingTime_all, 0, 2);
ci_AverageWaitingTime = z * std_AverageWaitingTime / sqrt(n_sim);

% -- Average Total Time --
mean_AverageTotalTime = mean(AverageTotalTime_all, 2);
std_AverageTotalTime = std(AverageTotalTime_all, 0, 2);
ci_AverageTotalTime = z * std_AverageTotalTime / sqrt(n_sim);

% -- Average Length --
mean_AverageLength = mean(AverageLength_all, 2);
std_AverageLength = std(AverageLength_all, 0, 2);
ci_AverageLength = z * std_AverageLength / sqrt(n_sim);

% -- Lost Clients --
mean_LostClients = mean(LostClients_all, 2);
std_LostClients = std(LostClients_all, 0, 2);
ci_LostClients = z * std_LostClients / sqrt(n_sim);

% -- Average Service Time --
mean_AverageServerTime = mean(AverageServerTime_all);
std_AverageServerTime = std(AverageServerTime_all ,0);
ci_AverageServerTime = z * std_AverageServerTime  / sqrt(n_sim);

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients(q), ci_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
    fprintf('  Average Server Utilization  = %.2f ± %.2f\n', mean_AverageServerTime(q), ci_AverageServerTime(q));
end

