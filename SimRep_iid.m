% SimulationIID

n_sim=5;
StopNumber = 50;
numQueue= 3;
numServers= [1,2,3];
min_balking=[10];
max_length=[20];
arrivalRate=[3 3 4];
serviceRate=[1 2 1];

AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'iid', 'exponential',arrivalRate(1)}, {'iid', 'gamma',1,2}, {'iid', 'uniform',3, 10}},{{'iid', 'exponential',serviceRate(1)}, {'iid', 'exponential',serviceRate(2)}, {'iid', 'exponential',serviceRate(3)}});
configuration.assignBalking([1],min_balking(1), max_length(1));

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

for i=1:n_sim
    SimMgr.SimulateEvents(configuration);

    AverageWaitingTime_all(:, i) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, i) = StatMgr.AverageTotalTime;
    AverageLength_all(:, i) = StatMgr.AverageLength;
    LostClients_all(:, i) = StatMgr.LostClients;

    StatMgr.clean(configuration.numQueue);

    
end

alpha = 0.05;
z = norminv(1 - alpha/2); 

% -- Average Waiting Time --
mean_AverageWaitingTime = mean(AverageWaitingTime_all, 2);       % [numQueue x 1]
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
