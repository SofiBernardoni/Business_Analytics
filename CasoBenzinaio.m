% SIMULATION EXAMPLE: benzinaio
clear all
rng(1234)

StopNumber = 200;
numQueue= 2;
numServers= [4,1];
arrivalRate1 = 10;
serviceRate1 = 2;
serviceRate2 = 1;
maxLength = 3;

minPref=1;
maxPref=2;


% Creating Config object with the configuration of the problem
configuration = Config(StopNumber,numQueue, numServers);
configuration= configuration.assignTimes({{'iid', 'exponential',arrivalRate1},{}},{{'iid', 'exponential', serviceRate1},{'iid', 'exponential',serviceRate2}});
configuration=configuration.assignDependencies([2], [1], [2]);
configuration=configuration.assignPreferences([1], minPref, maxPref );
configuration=configuration.assignBalking([1], [maxLength], [maxLength] );

EventMgr= EventManagerBenzinaio(configuration); % Creating Event Manager
StatMgr= StatisticsManager(configuration.numQueue); % Creating Statistics Manager
SimMgr=SimulationManager(StatMgr, EventMgr); % Creating Simulation Manager

SimMgr.SimulateEvents(configuration);


