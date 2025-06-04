function [state] = initializeState(config)
%     cosa abbiamo messo in state:
% - clock
% - list_events (future)
% - queue (={}) lista di entity
% - lengthQueue
% - lost_client (booleano, da rimettere a false)
% - lastLenghtUpdate (clock all'ultimo update ) (sumlenght)
% - servers : [A, B, C, D] mettiamo 0 e 1 se il server è libero o occutpato
% - waitingPump: vettore lungo 2 per A e C

    state.clock = 0;
    % Generate first events : first arrivals in queues with independent arrivals
    state.list_events = [];
    for q=1:config.numQueue
        if independentArrivalQueue(q)
            first_client=struct('timeQueueArrival',zeros(1,config.numQueue), 'WaitingQueueTime',zeros(1,config.numQueue));
            if config.preference(q)
                pref=randi([config.MinPref(q) config.MaxPref(q)]); % randomly samples the integer preference between config.MinPref and config.MaxPref included
                first_client.preference= pref;
            end
            first_client.timeQueueArrival(q) = 0;
        end
    end
    state.list_events = [EventUtils.scheduleEvent(0, 'arrivo', 1,first_client)];

    %%%%%%%%%55
   
    % Generate first client (specific for CASO BENZINAIO) for first event
    first_client=struct('timeQueueArrival',zeros(1,config.numQueue), 'WaitingQueueTime',zeros(1,config.numQueue));
    if config.preference
        pref=randi([config.MinPref config.MaxPref]); % randomly samples the integer preference between config.MinPref and config.MaxPref included
        first_client.preference= pref;
    end
    first_client.timeQueueArrival(1) = 0;
    state.list_events = [EventUtils.scheduleEvent(0, 'arrivo', 1,first_client)];
    %%%%%%%%
    
    state.lost_client = false;
    
    state.queue = repmat({cell(0,0)},1,config.numQueue); 

    state.lengthQueue = zeros(1,config.numQueue);

    state.processedClients = zeros(1,config.numQueue);

    state.lastLengthUpdate = zeros(1,config.numQueue);    

    state.servers = zeros(config.numQueue, config.numServers); 
    
    % specific for CASO BENZINAIO 
    state.waitingPump = cell(1,2) ; 
end