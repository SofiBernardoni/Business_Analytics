% SIMULATION EXAMPLE: Benzinaio

clear all

rng(123)

% Number of repetitions of the simulation
n_sim = 100;

% System configuration
StopNumber = 500;
numQueue= 2;
arrivalRate1 = 6;
serviceRate1 = 4;
serviceRate2 = 10;
maxLength = 5;

minPref=1;
maxPref=2;

numServers= [4,1];
fprintf('Server in cassa: 1');

% Vectors of statistics
AverageWaitingTime_all1 = zeros(numQueue, n_sim);
AverageTotalTime_all1 = zeros(numQueue, n_sim);
AverageLength_all1 = zeros(numQueue, n_sim);
LostClients_all1 = zeros(numQueue, n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration= configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{}},{{'iid', 'exponential', serviceRate1},{'iid', 'exponential',serviceRate2}});
configuration= configuration.assignDependencies([2], [1], [2]);
configuration= configuration.assignPreferences([1], minPref, maxPref );
configuration = assignBalking(configuration, [1], maxLength, maxLength);

EventMgr= EventManagerBenzinaio(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager
    
for k = 1:n_sim
    
    SimMgr.print_stat=false;
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all1(:, k) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all1(:, k) = StatMgr.AverageTotalTime;
    AverageLength_all1(:, k) = StatMgr.AverageLength;
    LostClients_all1(:, k) = StatMgr.LostClients;   

    StatMgr.clean(configuration.numQueue);

end

alpha = 0.05;
z = norminv(1 - alpha/2); 

% -- Average Waiting Time --
mean_AverageWaitingTime = mean(AverageWaitingTime_all1, 2);  
std_AverageWaitingTime = std(AverageWaitingTime_all1, 0, 2);
ci_AverageWaitingTime = z * std_AverageWaitingTime / sqrt(n_sim);

% -- Average Total Time --
mean_AverageTotalTime = mean(AverageTotalTime_all1, 2);
std_AverageTotalTime = std(AverageTotalTime_all1, 0, 2);
ci_AverageTotalTime = z * std_AverageTotalTime / sqrt(n_sim);

% -- Average Length --
mean_AverageLength = mean(AverageLength_all1, 2);
std_AverageLength = std(AverageLength_all1, 0, 2);
ci_AverageLength = z * std_AverageLength / sqrt(n_sim);

% -- Lost Clients --
mean_LostClients = mean(LostClients_all1, 2);
std_LostClients = std(LostClients_all1, 0, 2);
ci_LostClients = z * std_LostClients / sqrt(n_sim);

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients(q), ci_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
end



numServers= [4,2];
fprintf('Server in cassa: 2');

% Vectors of statistics
AverageWaitingTime_all2 = zeros(numQueue, n_sim);
AverageTotalTime_all2 = zeros(numQueue, n_sim);
AverageLength_all2 = zeros(numQueue, n_sim);
LostClients_all2 = zeros(numQueue, n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration= configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{}},{{'iid', 'exponential', serviceRate1},{'iid', 'exponential',serviceRate2}});
configuration= configuration.assignDependencies([2], [1], [2]);
configuration= configuration.assignPreferences([1], minPref, maxPref );
configuration = assignBalking(configuration, [1], maxLength, maxLength);

EventMgr= EventManagerBenzinaio(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager
    
for k = 1:n_sim
    
    SimMgr.print_stat=false;
    SimMgr.SimulateEvents(configuration);

    % Store statistics
    AverageWaitingTime_all2(:, k) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all2(:, k) = StatMgr.AverageTotalTime;
    AverageLength_all2(:, k) = StatMgr.AverageLength;
    LostClients_all2(:, k) = StatMgr.LostClients;   

    StatMgr.clean(configuration.numQueue);

end

alpha = 0.05;
z = norminv(1 - alpha/2); 

% -- Average Waiting Time --
mean_AverageWaitingTime2 = mean(AverageWaitingTime_all2, 2);  
std_AverageWaitingTime2 = std(AverageWaitingTime_all2, 0, 2);
ci_AverageWaitingTime2 = z * std_AverageWaitingTime2 / sqrt(n_sim);

% -- Average Total Time --
mean_AverageTotalTime2 = mean(AverageTotalTime_all2, 2);
std_AverageTotalTime2 = std(AverageTotalTime_all2, 0, 2);
ci_AverageTotalTime2 = z * std_AverageTotalTime2 / sqrt(n_sim);

% -- Average Length --
mean_AverageLength2 = mean(AverageLength_all2, 2);
std_AverageLength2 = std(AverageLength_all2, 0, 2);
ci_AverageLength2 = z * std_AverageLength2 / sqrt(n_sim);

% -- Lost Clients --
mean_LostClients2 = mean(LostClients_all2, 2);
std_LostClients2 = std(LostClients_all2, 0, 2);
ci_LostClients2 = z * std_LostClients2 / sqrt(n_sim);

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f ± %.2f\n', mean_LostClients2(q), ci_LostClients2(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength2(q), ci_AverageLength2(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime2(q), ci_AverageWaitingTime2(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime2(q), ci_AverageTotalTime2(q));
end

