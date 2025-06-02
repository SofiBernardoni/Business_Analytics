classdef TimeGenerator < handle
    % SISTEMA 
    properties
        Mode          % 'iid', 'state_dependent', 'custom'
        Distribution  % funzione handle or distribution name 
        Parameters    % distribution/function parameters
        CustomFunc    % function handle for personalized sampling 
        Schedule      % list of defined clocks (fixed)
    end
    
    methods
        function obj = TimeGenerator(mode, varargin)
            
            obj.Mode = mode;

            switch mode
                case 'iid'
                    obj.Distribution = varargin{1};
                    obj.Parameters = varargin(2:end);
                    
                case 'state_dependent'
                    obj.CustomFunc = varargin{1};
                    
                case 'custom'
                    obj.CustomFunc = varargin{1};
                
                case 'scheduled'
                    obj.Schedule = varargin{1};  
                
                case 'deterministic'
                    obj.TimeGen = TimeGenerator('state_dependent', @(~) varargin{1});
                    
                otherwise
                    error('Unknown mode')
            end
        end

        function t = sample(obj, varargin)
            switch obj.Mode
                case 'iid'
                    t = obj.sampleIID();
                    
                case 'state_dependent'
                    state = varargin{1}; % current state
                    t = obj.CustomFunc(state);
                    
                case 'custom'
                    history = varargin{1}; % what happened before
                    state = varargin{2}; % current state
                    t = obj.CustomFunc(history, state);
                    
                otherwise
                    error('Unknown mode')
            end
        end
    end

    methods (Access = private)
        function t = sampleIID(obj)
            switch obj.Distribution
                case 'exponential'
                    lambda = obj.Parameters{1};
                    t = exprnd(1/lambda);
                case 'uniform'
                    a = obj.Parameters{1};
                    b = obj.Parameters{2};
                    t = rand() * (b - a) + a;
                case 'beta'
                    a = obj.Parameters{1};
                    b = obj.Parameters{2};
                    t = betarnd(a, b);
                otherwise
                    error('Unavailable distribution');
            end
        end
    end
end