classdef EventUtils
    % Class that manages the list of future events

    methods (Static)
        
        function Events = insertEvents(Events, newEvent)
            % Inserts new Event in the list of the future ones, reordering the list
            Events{end+1} = newEvent;
            clockVals = cellfun(@(e) e.clock, Events);
            [~, idx] = sort(clockVals);
            %[~, idx] = sort([Events.clock]);
            Events = Events(idx);
        end

        function [Events, nextEvent] = popNextEvent(Events)
            % Picks up next Event and deletes it from the list of the future ones
            nextEvent = Events{1};
            Events(1) = [];
        end
        
        % vedi se inserire data in struct
        function event = scheduleEvent(clock, type, queue, client, server)
            % Creates new event (struct: clock, type, queue_id, server_id )
            if nargin < 5
                server = '';  % default value for arrival events (in order to have every event with the same structure and put them in a list)
            end
            event = struct('clock',clock, 'type',type, 'queue', queue, 'client', client, 'server',server);  
        end

    end

end
