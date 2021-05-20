% This demo illustrates the process of computing the altered phase
% functions used in Figure 1 (example 1) and Figure 8 (example 2) of
% SIGGRAPH 2014 paper titled 'High-Order Similarity Relations in Radiative
% Transfer'.
%
% Written by Shuang Zhao (shuang@shuangz.com)
%
clear; close all;
addpath(genpath('D:/gyDocuments/4_waveoptics/codes/src'));

dir = 'D:/gyDocuments/4_waveoptics/results/out/color/bin/';
load([dir 'ct_list.mat']);
N = 5;  R = 8.61*1e-6; V = 4/3*pi*R^3; pho = N/V; scale_list = pho * ct_list / 10000;

wl_list = round(linspace(0.4,0.7,50)*1000);

id = 0;
for wl = wl_list
    id = id + 1;
    sigS = scale_list(id);
    p = load_tab_bin([dir 'tab_' num2str(wl) '.bin']);
    fun1 = @(x) HG(0.95, x)
%     fun2 = @(x) (floor(acos(-x)/pi*180)+1-acos(-x)/pi*180)*p(floor(acos(-x)/pi*180)+1) + (acos(-x)/pi*180-floor(acos(-x)/pi*180))*p(min(floor(acos(-x)/pi*180)+1,180)+1);
    fun2 = @(x) tab(x, p)
    [sigS2a, fun2a, N2] = demo(fun2, sigS);
%     save_tab_bin(p, [dir num2str(wl) '.bin']);
    pause = 1;
end

function y = tab(x, p)
    t = acos(-x)/pi*180;
    lo = floor(t); up =  lo+1;
    w1 = up-t; w2 = t-lo;
    y = w1*p(lo+1) + w2*p(min(up,180)+1);
end

function [sigS2a, fun2a, N2] = demo(fun2, sigS)
    alpha = 0.2;
    
  
   
    % Example 2
    %
    fprintf('==== Example 2 ====\n')
    fprintf('sigmaS = 1.0\nf() = 0.9*HG(0.95, x) + 0.1*vMF(-75, x)\n')
    
    % Solve for a soltuion adhering to the order-1 similarity relation
%     fprintf('\n# Solving for an order-1 solution\n')
%     [sigS2a, fun2a0] = ComputeAlteredParameters(sigS, fun2, alpha, 1);
    
    % Solve for a soltuion adhering to higher-order similarity relation
    fprintf('\n# Solving for a higher-order solution\n')
    [sigS2a, fun2a, N2] = ComputeAlteredParameters(sigS, fun2, alpha,6,180);
    
    fprintf('\nAltered sigmaS = %.4f\n', sigS2a)
    fprintf('===================\n\n')
    
    % Plot both examples
    %
    h = @(x) sign(x).*(1 - (1 - abs(x).^1.5).^(1/1.5));
    hFig = figure(1);
    set(hFig, 'Position', [300 300 700 300])
    clf
        
    % Plot example 2
    %    
    % Plot the original phase function
    plot(h(-1:0.001:1), log2p(fun2(-1:0.001:1)), '--', 'LineWidth', 2)
    hold all
    
    % Plot both solutions
    k2 = length(fun2a);
%     stairs(h(linspace(-1, 1, k2 + 1)'), log2p([fun2a0; fun2a0(end)]), ...
%         'LineWidth', 2)
    stairs(h(linspace(-1, 1, k2 + 1)'), log2p([fun2a; fun2a(end)]), ...
        'LineWidth', 1)
    
    % Setup the sub-figure
    title('Phase Function Plots (Example 2)')
    legend('original', sprintf('order-%d', N2), ...
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
