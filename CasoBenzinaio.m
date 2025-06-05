% SIMULATION EXAMPLE: M/M/1 queue with balking

StopNumber = 200;
numQueue= 2;
numServers= [4,1];
arrivalRate1 = 3;
serviceRate1 = 4;
serviceRate2 = 1;
maxLength = 5;
preference = true;
minPref=1;
maxPref=2;


% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{}},{{'iid', 'exponential', serviceRate1},{'iid', 'exponential',serviceRate2}})
configuration.assignDependencies([2], [1], [2]);
configuration.assignPreferences([1], minPref, maxPref )

EventMgr= EventManagerBenzinaio(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

SimMgr.SimulateEvents(configuration);


