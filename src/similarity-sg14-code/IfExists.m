% This function implements Theorem 1 in SIGGRAPH 2014 paper titled
% 'High-Order Similarity Relations in Radiative Transfer'.
%
% Written by Shuang Zhao (shuang@shuangz.com)
%
% It takes one parameter f (as a vector) and determines if there exists a
% nonnegative function f^*() with its Legendre moments matching the values
% specified in f where f(i) stores the Legendre moment of order (i - 1).
%
function ret = IfExists(f)
    f = f(:);
    N = length(f) - 1;
    k = floor(N/2);

    % Computing the monomial moments (gamma) from the Legendre moments (f).
    Ph = zeros(N + 1, N + 1);
    for i = 0 : N
        Ph(i + 1, N + 1 - i : end) = LegendrePoly(i);
    end
    Ph = (2*pi)*Ph(:, end : -1 : 1);
    gamma = Ph\f;
    
    % Checking the conditions described in Theorem 1.
    H = hankel(gamma);
    if mod(N, 2) == 0
        % Even case
        U0 = matU(k + 1, H); U = matU(k, H); W = matW(k, H);
        ev1 = min(eig(U0));
        ev2 = min(eig(U - W));
    else
        % Odd case
        U = matU(k + 1, H); V = matV(k + 1, H);
        ev1 = min(eig(U - V));
        ev2 = min(eig(U + V));
    end
    
    ret = ( min(ev1, ev2) > 0 );
end

% Building the Hankel matrices according to (22) in the paper.
%
function U = matU(n, H)
    U = H(1 : n, 1 : n);
end
function V = matV(n, H)
    V = H(1 : n, 2 : n + 1);
end
function W = matW(n, H)
    W = H(1 : n, 3 : n + 2);
end
