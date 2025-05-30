function [state,fail] = checkAdmission(entity,state)
    fail=true;
    if config.preference
        comp_servers= compatible_servers(entity.preference);
    else
        comp_servers= [1:numServers];
    end

    for ser = comp_servers
        if state.servers(ser) == 0
            fail= false; % the entity can access servers
            break;
        end
    end

end
