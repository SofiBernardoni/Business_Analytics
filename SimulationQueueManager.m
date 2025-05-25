classdef SimulationQueueManager < SimulationManager
    % Class to manage simulation process (simulazione ad eventi di code)

    properties
        QueueStructure % max length, balking, politica di gestione... tasso di arrivo (se indipendente), tasso di servizio..
    end
    
    methods
        function obj= SimulationQueueManager(StatManager, EventManager, QueueStructure)
            obj@SimulationManager(StatManager, EventManager);
            if nargin>2
                obj.QueueStructure = QueueStructure;
            end
        end

        
        function obj=SimulateEvents(obj, config)
            % Function performing the simulation and evaluating the statistics
            % Args:
            % config = simulation configuration parameters (stopping criterion (StopNumber), rates...) : struct

            % creare condizione iniziale coda

            for n = 1:config.StopNumber

            end
            % clock= final_clock (STORE IT)

            % Evaluate statistics
            StatMgr.AverageLength=StatMgr.AverageLength/final_clock;
            StatMgr.AverageWaitingTime=StatMgr.AverageWaitingTime/StopNumber;
            StatMgr.AverageTotalTime = StatMgr.AverageTotalTime/StopNumber;

            if print_stat
                % Print statistiche
            end
        end


    end


end