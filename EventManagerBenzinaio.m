classdef EventManagerBenzinaio < EventManager
    % Class to manage simulation process (simulazione ad eventi) (CASO BENZINAIO) 
   
    methods

        function comp_servers= access_compatible_servers(~,pref)
            % Returns the compatible server that we have to check (CASO BENZINAIO)
            comp_servers=[2*pref-1];
        end

        function comp_servers= compatible_servers(~,pref)
        % Returns the compatible servers in the correct order (from the farest one) (CASO BENZINAIO)
            comp_servers=[2*pref,2*pref-1];
        end

        function newEvent= dependentService(~,time,server,entity,id_queue)
            if id_queue==1
                newEvent = scheduleEvent(time, 'arrivo', 2);
                entity.pump=server; % associate the pump to the client
                newEvent.client=entity;
            else
                error('EventManager:UnmatchedDependentServiceQueue', 'Queue: %s', id_queue);
            end
        end

        function [state, newEvents] = exitService(~,state,event)
            newEvents={};
            
            entity_exits= true;
            client=event.client;
            if client.pump==1 || event.client.pump==3 % driver in A or C cannot exit if B or D is not available
                if state.servers(client.pump+1)==1
                    entity_exits= false;
                    idx=(client.pump-1)/2+1;
                    state.waitingPump(idx)=true;
                end
            end
            if entity_exits
                % Scheduling end of service
                newEvent = scheduleEvent(state.clock, 'fine_servizio', 1);
                newEvent.server=client.pump;
                newEvent.client=client;
                newEvents{end+1}=newEvent;
                if client.pump==2 || event.client.pump==4 % if driver in B or D, check if the driver behind is waiting
                    if state.waitingPump(client.pump/2)
                        newEvent = scheduleEvent(state.clock + EPS, 'fine_servizio', 1); % DEFINE eps
                        newEvent.server=client.pump/2;
                        %newEvent.client=client; %AGGIUSTAAAAAAAAAAAAAAAAAAAAAAAAAAA
                        newEvents{end+1}=newEvent;
                    end
                end
                % uscita : fine servizio in coda 1
            end
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
    
