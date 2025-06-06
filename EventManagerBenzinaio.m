classdef EventManagerBenzinaio < EventManager
    % Subclass to manage events in the special case (caso benzinaio) 
    
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
                entity.timeQueueArrival(2) = time;
                entity.pump=server; % associate the pump to the client
                newEvent = EventUtils.scheduleEvent(time, 'arrivo', 2,entity);
            else
                error('EventManager:UnmatchedDependentServiceQueue', 'Queue: %s', id_queue);
            end
        end


        function [state, newEvents] = exitService(obj,state,event)
            newEvents={};
            
            entity_exits= true;
            client=event.client;
            client_pump=event.client.pump;
            if client_pump==1 || client_pump==3 % driver in A or C cannot exit if B or D is not available
                if state.servers{1}(client_pump+1)==1
                    entity_exits= false;
                    idx=(client_pump-1)/2+1;
                    state.waitingPump{idx}=client;
                end
            end
            if entity_exits
                % Scheduling end of service
                newEvent = EventUtils.scheduleEvent(state.clock, 'fine_servizio', 1, client,client_pump);
                newEvents{end+1}=newEvent;

                if client_pump==2 || client_pump==4 % if driver in B or D, check if the driver behind is waiting
                    if ~isempty(state.waitingPump{client_pump/2})
                        newEvent = EventUtils.scheduleEvent(state.clock + obj.EPS, 'fine_servizio', 1, state.waitingPump{client_pump/2},client_pump-1); 
                        newEvents{end+1}=newEvent;
                        
                        state.waitingPump{client_pump/2}= []; % corresponding waiting pump empty again
                    end
                end

            end
        end
       
    end


end
    
