classdef EventManagerBenzinaio < EventManager
    % Class to manage simulation process (simulazione ad eventi) (CASO BENZINAIO) 
    properties (Constant)
        EPS=1e-4; % used to manage exit "cascade" b--> a and d--> c
    end

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
                newEvent = scheduleEvent(time, 'arrivo', 2,entity);
                newEvent.client.timeQueueArrival(event.queue) = time;
                entity.pump=server; % associate the pump to the client
            else
                error('EventManager:UnmatchedDependentServiceQueue', 'Queue: %s', id_queue);
            end
        end

        function [state, newEvents] = exitService(obj,state,event)
            newEvents={};
            
            entity_exits= true;
            client=event.client;
            if client.pump==1 || event.client.pump==3 % driver in A or C cannot exit if B or D is not available
                if state.servers(1,client.pump+1)==1
                    entity_exits= false;
                    idx=(client.pump-1)/2+1;
                    state.waitingPump{idx}=client;
                end
            end
            if entity_exits
                % Scheduling end of service
                newEvent = scheduleEvent(state.clock, 'fine_servizio', 1, client);
                newEvent.server=client.pump;
                newEvents{end+1}=newEvent;

                if client.pump==2 || event.client.pump==4 % if driver in B or D, check if the driver behind is waiting
                    if ~isempty(state.waitingPump{client.pump/2})
                        newEvent = scheduleEvent(state.clock + obj.EPS, 'fine_servizio', 1, state.waitingPump{client.pump/2}); 
                        newEvent.server= client.pump/2;
                        newEvents{end+1}=newEvent;
                        
                        state.waitingPump{client.pump/2}= []; % corresponding waiting pump empty again
                    end
                end

            end
        end
       
    end


end
    
