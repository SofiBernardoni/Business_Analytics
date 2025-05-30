classdef EventManagerBenzinaio < EventManager
    % Class to manage simulation process (simulazione ad eventi)
    properties
        %currentEvent @function_handle
    end
    
    methods
        function comp_servers= compatible_servers(~,pref)
        % Returns the compatible server that we have to check (CASO BENZINAIO)
            comp_servers=[2*pref-1];
        end

        function [state, newEvent] = enterService(~,entity,state)
        
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
            newEvent = scheduleEvent(state.time + serviceTime, 'fine_servizio', struct('server', s));
        
        end

        function [state] = exitService(~,entity,state) % mettere come metodo astratto?? % ridef
        end
        
 

        function currentEvent= handleEvent(obj, eventType) % togli
            % handleEvent takes the event type as an input argument
            switch eventType
                case 'arrivo'
                    currentEvent= @obj.handleArrival; 
                case 'fine_servizio'
                    currentEvent= @obj.handleEndService; 
                case 'internal_queue'
                    currentEvent= @obj.handleInternalQueue; 
                otherwise
                    error('EventManager:UnknownEventType', 'Unknown event type: %s', eventType);
            end
        end
end


end
    
