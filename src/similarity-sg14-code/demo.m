% This demo illustrates the process of computing the altered phase
% functions used in Figure 1 (example 1) and Figure 8 (example 2) of
% SIGGRAPH 2014 paper titled 'High-Order Similarity Relations in Radiative
% Transfer'.
%
% Written by Shuang Zhao (shuang@shuangz.com)
%
function demo
    sigS = 1;
    alpha = 0.2;
    
    % Example 1
    %
    fun1 = @(x) 0.9*vMF(75, x) + 0.1*vMF(-75, x);
    
    fprintf('==== Example 1 ====\n')
    fprintf('sigmaS = 1.0\nf() = 0.9*vMF(75, x) + 0.1*vMF(-75, x)\n')
    
    % Solve for a soltuion adhering to the order-1 similarity relation
    fprintf('\n# Solving for an order-1 solution\n')
    [sigS1a, fun1a0] = ComputeAlteredParameters(sigS, fun1, alpha, 1);
    
    % Solve for a soltuion adhering to higher-order similarity relation
    fprintf('\n# Solving for a higher-order solution\n')
    [~, fun1a, N1] = ComputeAlteredParameters(sigS, fun1, alpha);
    
    fprintf('\nAltered sigmaS = %.4f\n', sigS1a)
    fprintf('===================\n\n')
    
    % Example 2
    %
    fun2 = @(x) 0.9*HG(0.95, x) + 0.1*vMF(-75, x);
    fprintf('==== Example 2 ====\n')
    fprintf('sigmaS = 1.0\nf() = 0.9*HG(0.95, x) + 0.1*vMF(-75, x)\n')
    
    % Solve for a soltuion adhering to the order-1 similarity relation
    fprintf('\n# Solving for an order-1 solution\n')
    [sigS2a, fun2a0] = ComputeAlteredParameters(sigS, fun2, alpha, 1);
    
    % Solve for a soltuion adhering to higher-order similarity relation
    fprintf('\n# Solving for a higher-order solution\n')
    [~, fun2a, N2] = ComputeAlteredParameters(sigS, fun2, alpha);
    
    fprintf('\nAltered sigmaS = %.4f\n', sigS2a)
    fprintf('===================\n\n')
    
    % Plot both examples
    %
    h = @(x) sign(x).*(1 - (1 - abs(x).^1.5).^(1/1.5));
    hFig = figure(1);
    set(hFig, 'Position', [300 300 700 300])
    clf
    
    % Plot example 1
    %
    subplot(1, 2, 1)
    
    % Plot the original phase function
    plot(h(-1:0.001:1), log2p(fun1(-1:0.001:1)), '--', 'LineWidth', 2)
    hold all
    
    % Plot the altered solutions
    k1 = length(fun1a0);
    stairs(h(linspace(-1, 1, k1 + 1)'), log2p([fun1a0; fun1a0(end)]), ...
        'LineWidth', 2)
    stairs(h(linspace(-1, 1, k1 + 1)'), log2p([fun1a; fun1a(end)]), ...
        'LineWidth', 2)
    
    % Setup the figure
    title('Phase Function Plots (Example 1)')
    legend('original', 'order-1', sprintf('order-%d', N1), ...
        'Location', 'north')
    setupAxes    
    hold off
    
    % Plot example 2
    %    
    subplot(1, 2, 2)
    
    % Plot the original phase function
    plot(h(-1:0.001:1), log2p(fun2(-1:0.001:1)), '--', 'LineWidth', 2)
    hold all
    
    % Plot both solutions
    k2 = length(fun2a0);
    stairs(h(linspace(-1, 1, k2 + 1)'), log2p([fun2a0; fun2a0(end)]), ...
        'LineWidth', 2)
    stairs(h(linspace(-1, 1, k2 + 1)'), log2p([fun2a; fun2a(end)]), ...
        'LineWidth', 2)
    
    % Setup the sub-figure
    title('Phase Function Plots (Example 2)')
    legend('original', 'order-1', sprintf('order-%d', N2), ...
        'Location', 'north')
    setupAxes    
    hold off
    
    function setupAxes
        % Re-scale the X-axis
        set(gca, 'XTick', h([-1 -0.8 -0.4 0 0.4 0.8 1]))
        set(gca, 'XTickLabel', ...
            {'-1', '-0.8', '-0.4', '0', '0.4', '0.8', '1'})
        xlim([-1 1])
        xlabel('cos\theta')
        
        % Re-scale the Y-axis
        YTicks = get(gca, 'YTick');
        YTicks = linspace(YTicks(1), YTicks(end), 5);
        set(gca, 'YTick', YTicks)
        YTickLabels = cell(1, length(YTicks));
        for i = 1 : length(YTicks)
            YTickLabels{i} = sprintf('%.1f', invLog2p(YTicks(i)));
        end
        set(gca, 'YTickLabel', YTickLabels)
        ylabel('f(cos\theta)')
    end
end

% Functions used to re-scale the Y-axis.
function y = log2p(x)
    y = log1p(log1p(x));
end
function x = invLog2p(y)
    x = exp(exp(y) - 1) - 1;
end
