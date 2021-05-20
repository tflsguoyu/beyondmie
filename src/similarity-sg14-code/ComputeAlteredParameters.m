% This function implements Algorithm 1 in SIGGRAPH 2014 paper titled
% 'High-Order Similarity Relations in Radiative Transfer'.
%
% Written by Shuang Zhao (shuang@shuangz.com)
%
% It takes the following inputs.
%   sigmaS0    : original scattering coefficient.
%   fun0       : original phase function (as an anonymous function).
%   alpha      : a real number in (0, 1) that controls the tradeoff between
%                performance and accuracy (see Section 7.2 of the paper).
%
% The following parameters are optional.
%   N0         : an integer denoting the highest order of similarity
%                relation that will be considered (default: 5).
%   k          : number of bins for representing the altered phase function
%                (default: 360).
%   beta       : used to predict and reject overfitting using the method
%                introduced in Section 7.3 (defualt: 0.65).
%
% The outputs are:
%   sigmaS1    : the altered scattering coefficient.
%   fun1       : the altered phase function (tabulated as a vector).
%   N          : the order of similarity relation satisfied by the output
%                scattering parameters.
%
function [sigmaS1, fun1, N] = ...
    ComputeAlteredParameters(sigmaS0, fun0, alpha, N0, k, beta)

    % Setting default values to the optional parameters.
    if ~exist('k', 'var')
        k = 360;
    end
    if ~exist('N0', 'var')
        N0 = 5;
    end
    if ~exist('beta', 'var')
        beta = 0.65;
    end

    cosTheta = linspace(-1, 1, k + 1);
    x0 = cosTheta(1 : k); x1 = cosTheta(2 : k + 1);
    
    % Computing the order-0 through order-N0 Legendre moments of the
    % original phase function.
    % Note that f(i) corresponds to the (i - 1)-th moment.
    f = zeros(1, N0 + 1);
    for i = 0 : N0
        f(i + 1) = 2*pi*quad(@(x) legendre0(i, x).*fun0(x), -1, 1);
    end
%     assert( abs(f(1) - 1) < 1e-4 && f(2) > 0 )    
    
    alpha = max(alpha, 1 - f(2));
    sigmaS1 = alpha*sigmaS0;
    
    % Compute the desired Legendre moments of the altered phase function
    % according to (21) in the paper.
    f1 = 1 - (1 - f)/alpha;

    % Compute the greatest N (up to N0) such that the order-N similarity
    % relation is satisfiable.
    N = 1;
    while N < N0
        if ~IfExists(f1(1 : N + 2))
            break
        end
        N = N + 1;
    end
    
    % Compute the matrix G containing the Legendre moments of the basis
    % functions.
    if exist('cachedG.mat', 'file') == 2
        G0 = load('cachedG.mat');
        G = G0.G;
    end
    if exist('G', 'var') ~= 1 || size(G, 1) < N0 + 1 || size(G, 2) ~= k
        fprintf('Computing matrix G ... ')
        tic
        G = zeros(N0 + 1, k);
        for i = 1 : k
            for j = 0 : N0
                G(j + 1, i) = 2*pi* ...
                    quad(@(x) legendre0(j, x), x0(i), x1(i));
            end
        end
        fprintf('done (%.2f secs)\n', toc)
        save('cachedG', 'G')
        fprintf('Matrix G cached.\n')
        
    else
        fprintf('Using cached matrix G.\n')
    end

    % (Approximately) estimate the support of the original phase function.
    supp0 = sum(fun0((x0 + x1)/2) > 0.015)/k;
    
    % Constructing the 1D Poisson matrix S.
    S = diag(2*ones(1, k)) - diag(ones(1, k - 1), 1) - ...
        diag(ones(1, k - 1), -1);
    S = S(2 : end - 1, :);

    % Setup the quadratic programming solver
    fastsolver = ( any(exist('gurobi', 'file') == [2 3]) );
    if fastsolver
        % We recommend using the Gurobi library which can be obtained from
        % http://www.gurobi.com/. It is over an order of magnitude
        % faster than Matlab's built-in solver.        
        clear model
        model.Q = 0.5*sparse(S'*S);
        model.obj = zeros(k, 1);
        
        clear params
        params.TimeLimit = 100;
        params.OutputFlag = 0;
    else
        % If the Gurobi is not available, fall back to the built-in solver.
        fprintf('[Warning] Using the built-in quadprog() solver (slow)\n')
        
        clear opt
        opt = optimset('LargeScale', 'off', ...
            'Algorithm', 'active-set', ...
            'Display', 'off', 'MaxIter', 10000);        
    end
    
    % Numerically solve for the altered phase function.
    fprintf('Solving for the altered phase function ...\n')
    tic
    while true
        done = false;
        
        % Solve the quadratic programming problem specified in (31) of
        % the paper.
        if fastsolver
            % Using the Gurobi solver
            model.A = sparse(G(1 : N + 1, :));
            model.rhs = f1(1 : N + 1)';
            model.sense = repmat('=', [1, N + 1]);

            result = gurobi(model, params);
            if strcmp(result.status, 'OPTIMAL') == 0
                % Failed to find a solution (although it should exist).
                % In this case, increase k (in line 31).
                fprintf('[Warning] No solution [N = %d]\n', N)
            else
                % Successfully found a solution
                fun1 = result.x;
                done = true;
            end
        else
            % Using the built-in solver
            [c, ~, exitflag] = quadprog(S'*S, zeros(k, 1), [], [], ...
                G(1 : N + 1, :), f1(1 : N + 1)', zeros(k, 1), [], ...
                [], opt);
            switch exitflag
                case 1
                    % Successfully found a solution
                    fun1 = c;
                    done = true;
                case -2
                    % Failed to find a solution (although it should exist).
                    % In this case, increase k (in line 31).
                    fprintf('[Warning] Problem Infeasible [N = %d]\n', N)
                case 0
                    fprintf('[Warning] Not converged [N = %d]\n', N)
                otherwise
                    fprintf('[Warning] Unknown flag %d [N = %d]\n', ...
                        exitflag, N)
            end
        end
        
        if done
            % Fix small negative values caused by numerical precision
            % issues and re-normalize the solutions.
            fun1(fun1 < 1e-5) = 0;
            fun1 = fun1/(G(1, :)*fun1);
            
            % Check overfitting
            supp = sum(fun1 > 0.02)/k;
            if supp > beta*supp0
                break
            end
            fprintf('[Info] Overfitting [N = %d]\n', N)
        end
        
        N = N - 1;
    end
    fprintf('done with N = %d (%.2f sec)\n', N, toc)
end

% Evaluate P_n(x) where P_n is the Legendre polynomial of degree n.
% NOTE: this method uses Matlab's built-in Legendre polynomial
% implementation, which is known to have numerical issues when n is large.
%
function y = legendre0(n, x)
    y = legendre(n, x);
    y = y(1, :);
end
