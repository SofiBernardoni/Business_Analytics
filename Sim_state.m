% simulation - state.dipendent, nonhomogeneous
%simulazione di una coda con balking, arrivi con processo non omogeneo di
%poisson e tempi di servizi state-dipendent

% CAPIRE SE METTERE NORMFIT

n_sim=1000;
StopNumber = 900;
numQueue= 1;
numServers= [3];
min_balking=[10];
max_length=[15];
arrivalRate=[4];
serviceRate=[1];

AverageWaitingTime_all = zeros(numQueue, n_sim);
AverageTotalTime_all = zeros(numQueue, n_sim);
AverageLength_all = zeros(numQueue, n_sim);
LostClients_all = zeros(numQueue, n_sim);
AverageUtilization_all = zeros(numQueue, n_sim)

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'nonhomogeneous_poisson',  @(t) 6 + sin(t)}},{{'state.dipendent', @(state) 1 + 0.1*state}});
configuration = assignBalking(configuration, [1], min_balking, max_length);

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

for i=1:n_sim
    SimMgr.print_stat=false;
    SimMgr.SimulateEvents(configuration);

    AverageWaitingTime_all(:, i) = StatMgr.AverageWaitingTime;
    AverageTotalTime_all(:, i) = StatMgr.AverageTotalTime;
    AverageLength_all(:, i) = StatMgr.AverageLength;
    LostClients_all(:, i) = StatMgr.LostClients;
    AverageUtilization_all(:, i) = StatMgr.AverageUtilization;

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

% -- Average Utilization -- 
mean_AverageUtilization = mean(AverageUtilization_all, 2);
std_AverageUtilization = std(AverageUtilization_all, 0, 2);
ci_AverageUtilization = z * std_AverageUtilization / sqrt(n_sim);

for q = 1:numQueue
    fprintf('\nCoda %d:\n', q);
    fprintf('  Lost Clients       = %.2f \n', mean_LostClients(q));
    fprintf('  Average Length     = %.2f ± %.2f\n', mean_AverageLength(q), ci_AverageLength(q));
    fprintf('  Average Wait Time  = %.2f ± %.2f\n', mean_AverageWaitingTime(q), ci_AverageWaitingTime(q));
    fprintf('  Average Total Time = %.2f ± %.2f\n', mean_AverageTotalTime(q), ci_AverageTotalTime(q));
    fprintf('  Average Utilization = %.2f%% ± %.2f%%\n', 100 * mean_AverageUtilization(q), 100 * ci_AverageUtilization(q));
end
