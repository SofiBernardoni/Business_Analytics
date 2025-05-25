classdef EventUtils
    % Class that manages the list of future events

    methods (Static)
        
        function Events = insertEvents(Events, newEvents)
            % Inserts new Event in the list of the future ones, reordering the list
            Events = [Events; newEvents];
            [~, idx] = sort([Events.clock]);
            Events = Events(idx);
        end

        function [Events, nextEvent] = popNextEvent(Events)
            % Picks up next Event and deletes it from the list of the future ones
            nextEvent = Events(1);
            Events(1) = [];
        end
        
        % vedi se inserire data in struct
        function event = scheduleEvent(clock, type)
            % Creates new event (struct: clock, type )
            event = struct('clock',clock, 'type',type);  
        end

    end

end
