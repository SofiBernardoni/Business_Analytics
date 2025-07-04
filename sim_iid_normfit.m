% simulazione iid con normifit : in caso servisse 

n_sim=20;
StopNumber = 20;
numQueue= 3;
numServers= [1,2,3];
max_length=[20, 19, 17];
arrivalRateExp=[3];
arrivalGamma=[1,2];
arrivalUnif=[3, 10];
serviceRate=[1 2 1];
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
    AverageWaitingTime_all(:, i) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, i) = StatMgr.AverageTotalTime;
    AverageLength_all(:, i) = StatMgr.AverageLength;
    LostClients_all(:, i) = StatMgr.LostClients;
    StatMgr.clean(configuration.numQueue);
end

alpha = 0.05;

% -- Average Waiting Time --
mean_AverageWaitingTime = zeros(numQueue, 1);
ci_AverageWaitingTime = zeros(numQueue, 2);
for q = 1:numQueue
    [mean_AverageWaitingTime(q), ~, ci_AverageWaitingTime(q,:)] = normfit(AverageWaitingTime_all(q,:), alpha);
end

% -- Average Total Time --
mean_AverageTotalTime = zeros(numQueue, 1);
ci_AverageTotalTime = zeros(numQueue, 2);
for q = 1:numQueue
    [mean_AverageTotalTime(q), ~, ci_AverageTotalTime(q,:)] = normfit(AverageTotalTime_all(q,:), alpha);
end

% -- Average Length --
mean_AverageLength = zeros(numQueue, 1);
ci_AverageLength = zeros(numQueue, 2);
for q = 1:numQueue
    [mean_AverageLength(q), ~, ci_AverageLength(q,:)] = normfit(AverageLength_all(q,:), alpha);
end

% -- Lost Clients --
mean_LostClients = mean(LostClients_all, 2);

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f \n', mean_LostClients(q));
    fprintf('  Average Length     = %.2f  ± %.2f (CI: %.2f - %.2f)\n', mean_AverageLength(q), (ci_AverageLength(q,2) - ci_AverageLength(q,1))/2, ci_AverageLength(q,1), ci_AverageLength(q,2));
    fprintf('  Average Wait Time  = %.2f  ± %.2f (CI: %.2f - %.2f)\n', mean_AverageWaitingTime(q), (ci_AverageWaitingTime(q,2) - ci_AverageWaitingTime(q,1))/2, ci_AverageWaitingTime(q,1), ci_AverageWaitingTime(q,2));
    fprintf('  Average Total Time = %.2f  ± %.2f (CI: %.2f - %.2f)\n', mean_AverageTotalTime(q), (ci_AverageTotalTime(q,2) - ci_AverageTotalTime(q,1))/2, ci_AverageTotalTime(q,1), ci_AverageTotalTime(q,2));
end
