function [state] = initializeState(config, TimeArrivalMgr)
    % what's in state
    % clock
    % servers --> array di array, esterno: code; interno : server
    % queue --> cell array di cell array ( quello interno --> entity/client)
    % lengthQueue --> vec lungo quanto il num di code 
    % lostClient --> bool (default = false)
    % processedClients --> vec lungo quanto num code (count)
    % list_events --> lista degli eventi futuri
    % lastLengthUpdate --> vec lungo quanto num code 
    
    % waitingPump --> cell array lungo 2 a = pos 1 ; c = pos 2

    state.clock = 0;
    
    state.lengthQueue = zeros(1,config.numQueue);
    
    % Generate first events : first arrivals in queues with independent arrivals
    state.list_events = {};
    %newEvents=[];
    %state.list_events= struct('clock',{}, 'type',{}, 'queue', {}, 'client', {}, 'server',{});
    newEvents={};
    for q=1:config.numQueue
        if config.independentArrivalQueue(q)
            first_client=struct('timeQueueArrival',zeros(1,config.numQueue), 'WaitingQueueTime',zeros(1,config.numQueue));
            if config.preference(q)
                pref=randi([config.minPref(q) config.maxPref(q)]); % randomly samples the integer preference between config.minPref and config.maxPref included
                first_client.preference= pref;
            end
            first_client.timeQueueArrival(q) = TimeArrivalMgr{q}.sample(state.clock, state.lengthQueue(q), []);
            newEvents{end+1}=EventUtils.scheduleEvent(first_client.timeQueueArrival(q), 'arrivo', q,first_client);
        end        
    end
    for e=1:length(newEvents)
        state.list_events = EventUtils.insertEvents(state.list_events, newEvents{e}); 
    end
    
    state.lostClient = false;
    
    state.queue = repmat({cell(0,0)},1,config.numQueue); 

    state.processedClients = zeros(1,config.numQueue);

    state.lastLengthUpdate = zeros(1,config.numQueue);    

    state.servers = cell(1, config.numQueue);
    for q=1:config.numQueue
        state.servers{q} = zeros(1, config.numServers(q)); % all servers are available
    end

    state.processedClients= zeros(1,config.numQueue);    
    
    % specific for CASO BENZINAIO 
    state.waitingPump = cell(1,2) ; 
end