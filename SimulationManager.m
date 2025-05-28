classdef SimulationManager < handle
    % Class to manage simulation process (simulazione ad eventi)
    
    properties
        StatMgr
        EventMgr
        % Events=[] % list of future events (event struct)
        TimeSimulatorMgr % vedi se tenere????????????????????????
        print_stat % bool. True se si vogliono stampare le statistiche a fine simulazione
    end
    
    methods
        % Constructor
        function obj = SimulationManager(StatManager, EventManager)
            obj.StatMgr = StatManager;
            obj.EventMgr = EventManager;
            %obj.TimeSimulatorMgr = TimeSimManager;
            obj.print_stat= True; 
            
        end 
        
        % Function performing the simulation and evaluating the statistics
        function obj=SimulateEvents(obj, config) 
            % Args:
            % config = Config struct with simulation configuration parameters (StopNumber: stopping criterion, more specific stuff... )

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
                [state, newEvent]=handle_fun(state, event, config);
                for e=newEvent
                    state.list_events = EventUtils.insertEvents(state.list_events, e); 
                end
                state = obj.StatMgr.update(state,event); % vedi bene

                

            
                % da inserire in uscita client: count = count+ 1;
            end

        end
        
    end
    
     
end