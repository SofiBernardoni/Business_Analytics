classdef SimulationManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    
    properties
        StatMgr
        EventMgr
        TimeSimulatorMgr % vedi se tenere????????????????????????
        print_stat % bool. True se si vogliono stampare le statistiche a fine simulazione
    end
    
    methods
        % Constructor
        function obj = SimulationManager(StatManager, EventManager)
            obj.StatMgr = StatManager;
            obj.EventMgr = EventManager;
            %obj.TimeSimulatorMgr = TimeSimManager;
            obj.print_stat= true; 
            
        end 
        
        % Function performing the simulation and evaluating the statistics
        function obj=SimulateEvents(obj, config) 
            % Args:
            % config = Config struct with simulation configuration parameters (StopNumber: stopping criterion, more specific stuff... )
            % print_results= bool. True if printing final statistics is required

            % Initialization
            state = initializeState(config); % da definire (struct/classe) % STRUTTURA DIVERSA IN BASE AL CONTESTO (DA PERSONALIZZARE IN SOTTOCLASSE CON INITALIZE STATE)
            % metteri time e lista degli eventi futuri

            % nel nostro caso potremmo simulare fuori il primo arrivo


            count=0; 
            while count <= config.StopNumber
                
                % Read the first event in the ordered list of the events
                event= EventUtils.popNextEvent(state.list_events);
                state.clock=event.clock;
                
                % Manage the event
                handle_fun= obj.EventMgr.handleEvent(event.type);
                [state, newEvents]=handle_fun(state, event, config);
                for e=newEvents
                    state.list_events = EventUtils.insertEvents(state.list_events, e); 
                end
                state = obj.StatMgr.update(state,event);
                count= obj.StatMgr.stopCount(state);

            end
            % Finalize the simulation and print statistics if required
            obj.StatMgr.finalEvaluation(obj, obj.print_stat, state.clock, state.processedClients);
        end
        
    end
    
     
end