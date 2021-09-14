% Input:
%           p: Nx181 matrix
%                N phase functions and each has length of 181 (hardcoded here), start from farward direction
%           c: Nx3 matrix
%                Line color corresponding to each phase function
% Output:
%            void, and will plot figure on default canvas.
function polar_plot_all(p, c)
    [N,M] = size(p);
    assert(M==181);
    assert(size(c,1)==N);
    assert(size(c,2)==3);

   %% base circle radius
    
   %% plot base
    unit_all = linspace(0,1,5);
    
    theta_rad = [0:360]/180*pi;
    base = [cos(theta_rad'), sin(theta_rad')];
    
    % plot circles
    for unit = unit_all
        h = plot(base(:,1)*unit, base(:,2)*unit, ':', 'LineWidth', 1, 'Color', [0.7 0.7 0.7]);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
%     % plot lines
    for theta = 0:45:360
        h = plot([0, max(unit_all)*cos(theta/180*pi)], [0, max(unit_all)*sin(theta/180*pi)], ':', 'LineWidth', 1,'Color', [0.7 0.7 0.7]);
        h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    
    % plot light
    h = plot(0,0,'k.');
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    x = [0.55 0.7];   % adjust length and location of arrow 
    y = [0.15 0.15];
    annotation('textarrow',x,y,'FontSize',13,'Linewidth',2)
    annotation('textbox',[.58 0.11 .1 .1],'EdgeColor','none','String','Forward','FontSize',15,'Linewidth',2)
    
    
	%% Plot phase functions
       
    % Generate upper half phase function in polar->(x,y) coordinate
    theta_rad = linspace(0,180,M)/180*pi;
    polar = cat(3, ...
        p .* repmat(cos(theta_rad), [N, 1]), ...
        p .* repmat(sin(theta_rad), [N, 1]));
    
    % copy upper half to lower half
    polar = cat(2, polar, polar(:, M-1:-1:1, :));
    polar(:, M+1:end, 2) = -polar(:, M+1:end, 2);
    
    % plot phase function
    for i  = 1:N
        fill(polar(i,:,1), polar(i,:,2), c(i,:), 'FaceAlpha', 0.2, 'LineWidth', 1, 'EdgeColor', c(i,:), 'EdgeAlpha', 0.5)
    end
    
    axis equal
    axis off
end