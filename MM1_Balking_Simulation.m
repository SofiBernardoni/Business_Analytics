% SIMULATION EXAMPLE: M/M/1 queue with balking

StopNumber = 200;
numQueue= 1;
numServers= [1];
min_balking=10;
max_length=15;
arrivalRate=3;
serviceRate=4;

% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'iid', 'exponential',arrivalRate}},{{'iid', 'exponential',serviceRate}})
configuration.assignBalking([1],min_balking, max_length);

EventMgr= EventManager(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

SimMgr.SimulateEvents(configuration);


