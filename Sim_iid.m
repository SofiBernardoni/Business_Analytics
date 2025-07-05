% SIMULATION EXAMPLE: IID queues

% Simulation of 3 queues with maximum length (but no balking).
% Exponential service distribution.
% Arrival distribution: exponential, gamma and uniform. 

clear all

% Number of repetitions of the simulation
n_sim=100;

% System configuration
StopNumber = 500;
numQueue= 3;
max_length=[5, 5, 5];
arrivalRateExp=[3];
arrivalGamma=[1,2];
arrivalUnif=[3, 10];

%% 1 server for each queue with service rate=1, maxLength=5

rng(123)

% System configuration as above
numServers= [1,1,1];
serviceRate=[1 1 1];

% Vectors of statistics
AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'iid', 'exponential',arrivalRateExp(1)}, {'iid', 'gamma',arrivalGamma}, {'iid', 'uniform', arrivalUnif}},{{'iid', 'exponential',serviceRate(1)}, {'iid', 'exponential',serviceRate(2)}, {'iid', 'exponential',serviceRate(3)}});
%configuration.assignBalking([1 2 3], max_length, max_length);
configuration = assignBalking(configuration, [1 2 3], max_length, max_length);

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

for i=1:n_sim
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all(:, i) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, i) = StatMgr.AverageTotalTime;
    AverageLength_all(:, i) = StatMgr.AverageLength;
    LostClients_all(:, i) = StatMgr.LostClients;

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

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients(q), ci_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
end

%% 3 servers for each queue with service rate=1, maxLength=5

rng(123)

% System configuration as above
numServers= [3,3,3];
serviceRate=[1 1 1];

% Vectors of statistics
AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'iid', 'exponential',arrivalRateExp(1)}, {'iid', 'gamma',arrivalGamma}, {'iid', 'uniform', arrivalUnif}},{{'iid', 'exponential',serviceRate(1)}, {'iid', 'exponential',serviceRate(2)}, {'iid', 'exponential',serviceRate(3)}});
configuration = assignBalking(configuration, [1 2 3], max_length, max_length);

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

for i=1:n_sim
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all(:, i) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, i) = StatMgr.AverageTotalTime;
    AverageLength_all(:, i) = StatMgr.AverageLength;
    LostClients_all(:, i) = StatMgr.LostClients;

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

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients(q), ci_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
end

%% 1 server for each queue with different service rate=1,2,3, maxLength=5

rng(123)

% System configuration as above
numServers= [1,1,1];
serviceRate=[1 6 9];

% Vectors of statistics
AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'iid', 'exponential',arrivalRateExp(1)}, {'iid', 'gamma',arrivalGamma}, {'iid', 'uniform', arrivalUnif}},{{'iid', 'exponential',serviceRate(1)}, {'iid', 'exponential',serviceRate(2)}, {'iid', 'exponential',serviceRate(3)}});
configuration.assignBalking([1 2 3], max_length, max_length);

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

for i=1:n_sim
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all(:, i) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, i) = StatMgr.AverageTotalTime;
    AverageLength_all(:, i) = StatMgr.AverageLength;
    LostClients_all(:, i) = StatMgr.LostClients;

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

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients(q), ci_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
end
