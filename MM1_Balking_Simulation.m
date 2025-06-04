% SIMULATION EXAMPLE: M/M/1 queue with balking

StopNumber = 200;
numQueue= 1;
numServers= [1];
min_balking=10;
max_length=15;
% Inserire indicazioni tempo

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignBalking([1],min_balking, max_length);

EventManager
SimMgr=SimulationManager(StatManager, EventManager); % Creating Simulation Manager


