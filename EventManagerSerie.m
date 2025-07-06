classdef EventManagerSerie < EventManager
    % Subclass to manage events of one queue following the previous one (without server preference)
   
    methods

        function [state, newEvents] = exitService(~,state,event)
            newEvents={};
            nextQueue=event.queue+1;
            client=event.client;
            time_arrival= state.clock;            
            newEvent = EventUtils.scheduleEvent(time_arrival, 'arrivo', nextQueue, client);
            newEvent.client.timeQueueArrival(nextQueue) = time_arrival;
            newEvents{end+1}=newEvent;


        end
    end
end