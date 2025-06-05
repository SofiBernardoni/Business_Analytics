classdef SimulationManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    
    properties
        StatMgr
        EventMgr
        print_stat % bool. True if printing statistics at the end of the simulation is required
    end
    
    methods
        % Constructor
        function obj = SimulationManager(StatManager, EventManager)
            obj.StatMgr = StatManager;
            obj.EventMgr = EventManager;
            obj.print_stat= true;  
        end 

        
        % Function performing the simulation and evaluating the statistics
        function obj=SimulateEvents(obj, config) 
            % Args:
            % config = Config struct with simulation configuration parameters (StopNumber: stopping criterion, more specific stuff... )

            % Initialization
            state = initializeState(config, obj.EventMgr.TimeArrivalMgr); % da definire (struct/classe) % STRUTTURA DIVERSA IN BASE AL CONTESTO (DA PERSONALIZZARE IN SOTTOCLASSE CON INITALIZE STATE)
            % metteri time e lista degli eventi futuri

            count=0; 
            while count <= config.StopNumber
                
                % Read the first event in the ordered list of the events
                %%%%%%state.list_events % ATTENZIONE DEVEESSERE UNA LISTA E NON UNO STRUCT
                [state.list_events, event] = EventUtils.popNextEvent(state.list_events);
                %%%event % PROBLEMA è VUOTO
                state.clock=event.clock;
                
                % Manage the event
                handle_fun= obj.EventMgr.handleEvent(event.type);
                [state, newEvents]=handle_fun(state, event, config);
                for e=1:length(newEvents)
                    state.list_events = EventUtils.insertEvents(state.list_events, newEvents{e}); 
                end
                %state.list_events = EventUtils.insertEvents(state.list_events, newEvents);
                state = obj.StatMgr.update(state,event);
                count= obj.StatMgr.stopCount(state);

            end

            % Evaluate the simulation and print statistics if required
            obj.StatMgr.finalEvaluation(obj.print_stat, state.clock, state.processedClients);
        end
        
    end
    
     
end