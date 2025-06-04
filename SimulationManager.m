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
            state = initializeState(config); % da definire (struct/classe) % STRUTTURA DIVERSA IN BASE AL CONTESTO (DA PERSONALIZZARE IN SOTTOCLASSE CON INITALIZE STATE)
            % metteri time e lista degli eventi futuri

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

            % Evaluate the simulation and print statistics if required
            obj.StatMgr.finalEvaluation(obj, obj.print_stat, state.clock, state.processedClients);
        end
        
    end
    
     
end