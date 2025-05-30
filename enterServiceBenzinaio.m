function [state, newEvent] = enterServiceBenzinaio(entity,state,config)

%%% da mettere a posto

    if config.preference
        comp_servers= compatible_servers(entity.preference);
    else
        comp_servers= [1:numServers];
    end
   
    for s=comp_servers
        if state.servers(s)==0
            break;
        end
    end
    
    state.queue(1)=[]; % exiting the queue

    state.servers(s)=1; % server not avavilable anymore
    serviceTime = exprnd(config.serviceMean); % see extension
    newEvent = scheduleEvent(state.time + serviceTime, 'arrivo', struct('server', s)); % DA METTERE IN CODA INTERNA (CASSA)

end