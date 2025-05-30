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
    
    state.queue = {}; 

    state.lengthQueue = 0;

    state.lastLengthUpdate = 0;

    state.lost_client = false;
    
    state.list_events = [EventUtils.scheduleEvent(0, 'arrivo', 1)];

    state.servers = zeros(1, config.numServers); 
    
    state.waitingPump = [false, false];
end