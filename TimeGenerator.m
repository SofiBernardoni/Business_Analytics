classdef TimeGenerator < handle
    % Type:           'iid',                    'deterministic',        'state_dependent',        'scheduled',                     'custom',                     'nonhomogeneous_poisson.
    % varargin: {distribution, [parameters]}, {FunctionHandle()}, {FunctionHandle(currentState)}, {[t1 t2 t3 ...]}, {FunctionHandle(currentState, history, currentTime)}, {LambdaFunc}
    properties
        Type           % Tipo: 'iid', 'deterministic', etc.
        Distribution   % Per 'iid': tipo distribuzione ('exponential', ...)
        Parameters     % Parametri per la distribuzione
        FunctionHandle % Per 'state_dependent' e 'custom'
        Schedule       % Per 'scheduled'
        Index          % Posizione corrente nello schedule
        LambdaFunc     % Per 'nonhomogeneous_poisson'
    end

    methods
        function obj = TimeGenerator(type, varargin)
            if nargin == 0
                % Default value when nothing is passed
                type = 'deterministic';
                varargin = {Inf};  % non genera un evento
            end
            obj.Type = type;
            obj.Index = 1;

            switch type
                case 'iid'
                    % E.g. TimeGenerator('iid', 'exponential', 2)
                    obj.Distribution = varargin{1};
                    obj.Parameters = varargin(2:end);

                case 'deterministic'
                    % E.g. TimeGenerator('deterministic', 5)
                    obj.FunctionHandle = @(~) varargin{1};

                case 'state_dependent'
                    % E.g. TimeGenerator('state_dependent', @(state) exprnd(1 + state))
                    obj.FunctionHandle = varargin{1};

                case 'scheduled'
                    % E.g. TimeGenerator('scheduled', [1, 3, 5])
                    obj.Schedule = varargin{1};

                case 'nonhomogeneous_poisson'
                    % E.g. TimeGenerator('nonhomogeneous_poisson', @(t) 1 + sin(t))
                    obj.LambdaFunc = varargin{1};

                case 'custom'
                    % E.g. TimeGenerator('custom', @(state, history, t) t + ...)
                    obj.FunctionHandle = varargin{1};

                otherwise
                    error("Tipo '%s' non supportato.", type);
            end
        end

        function [dt, obj] = sample(obj, currentTime, currentState, history)
            switch obj.Type
                case 'iid'
                    switch obj.Distribution
                        case 'exponential'
                            dt = exprnd(obj.Parameters{1});
                        case 'uniform'
                            a = obj.Parameters{1}; b = obj.Parameters{2};
                            dt = a + (b - a) * rand();
                        case 'normal'
                            mu = obj.Parameters{1}; sigma = obj.Parameters{2};
                            dt = max(0, normrnd(mu, sigma));
                        case 'gamma'
                            a = obj.Parameters{1}; b = obj.Parameters{2};
                            dt = gamrnd(a,b);
                        otherwise
                            error("Distribuzione '%s' non supportata.", obj.Distribution);
                    end
                    

                case 'deterministic'
                    dt = obj.FunctionHandle();
                    

                case 'state_dependent'
                    dt = obj.FunctionHandle(currentState);
                    

                case 'scheduled'
                    if obj.Index <= length(obj.Schedule)
                        dt = obj.Schedule(obj.Index)-currentTime;
                        obj.Index = obj.Index + 1;
                    else
                        dt = inf;
                    end

                case 'nonhomogeneous_poisson'
                    maxLambda = 1.5 * max(arrayfun(obj.LambdaFunc, linspace(currentTime, currentTime + 10, 100)));
                    t = currentTime;
                    while true
                        w = exprnd(1 / maxLambda);
                        t = t + w;
                        if rand() < obj.LambdaFunc(t) / maxLambda
                            dt = w;
                            break;
                        end
                    end

                case 'custom'
                    dt = obj.FunctionHandle(currentState, history, currentTime);

                otherwise
                    error("Tipo '%s' non riconosciuto.", obj.Type);
            end
        end
    end
end