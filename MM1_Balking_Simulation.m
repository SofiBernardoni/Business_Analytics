% SIMULATION EXAMPLE: M/M/1 queue with balking
clear all

rng(123)

% Number of repetitions of the simulation
n_sim = 100;

% System configuration
StopNumber = 500;
numQueue = 1;
numServers = [1];
min_balking = 10;
max_length = 15;
arrivalRate = 3;
serviceRate = 4;

% Vectors of statistics
AverageWaitingTime = zeros(1, n_sim);
AverageTotalTime = zeros(1, n_sim);
AverageLength= zeros(1, n_sim);
LostClients = zeros(1, n_sim);
AverageServerTime = zeros(1,n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber, numQueue, numServers);
configuration = configuration.assignTimes({{'iid', 'exponential', arrivalRate}},{{'iid', 'exponential', serviceRate}});
configuration = assignBalking(configuration, [1], min_balking, max_length);

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

for k = 1:n_sim
    
    SimMgr.print_stat=false;
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime(k) = StatMgr.AverageWaitingTime(1);
    AverageTotalTime(k) = StatMgr.AverageTotalTime(1);
    AverageLength(k) = StatMgr.AverageLength(1);
    LostClients(k) = StatMgr.LostClients(1); 
    AverageServerTime(k) = StatMgr.AverageUtilization(1);

    StatMgr.clean(configuration.numQueue);

end

alpha = 0.05;
z = norminv(1 - alpha/2); 

% -- Average Waiting Time --
mean_AverageWaitingTime = mean(AverageWaitingTime);  
std_AverageWaitingTime = std(AverageWaitingTime,0);
ci_AverageWaitingTime = z * std_AverageWaitingTime / sqrt(n_sim);

% -- Average Total Time --
mean_AverageTotalTime = mean(AverageTotalTime);
std_AverageTotalTime = std(AverageTotalTime,0);
ci_AverageTotalTime = z * std_AverageTotalTime / sqrt(n_sim);

% -- Average Length --
mean_AverageLength = mean(AverageLength);
std_AverageLength = std(AverageLength,0);
ci_AverageLength = z * std_AverageLength / sqrt(n_sim);

% -- Lost Clients --
mean_LostClients = mean(LostClients);
std_LostClients = std(LostClients); 
ci_LostClients = z * std_LostClients / sqrt(n_sim);

% -- Average Service Time --
mean_AverageServerTime = mean(AverageServerTime);
std_AverageServerTime = std(AverageServerTime ,0);
ci_AverageServerTime = z * std_AverageServerTime  / sqrt(n_sim);

fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients, ci_LostClients);
fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength, ci_AverageLength);
fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime, ci_AverageWaitingTime);
fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime, ci_AverageTotalTime);
fprintf('  Average Server Utilization  = %.2f ± %.2f\n', mean_AverageServerTime, ci_AverageServerTime);