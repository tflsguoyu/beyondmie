function polar_plot(p)
    unit = 0.02;
    unit_all = [2,4,6,8,12,14,16,18,20,22]*0.002;
    axis_unit = 0.055;
    
    polar = zeros(361,2);
    for theta = 0:180
        theta_rad = theta/180*pi;
        x = (unit + p(theta+1)) * cos(theta_rad);
        y = (unit + p(theta+1)) * sin(theta_rad);
        polar(theta+1, :) = [x,y];
    end
    polar(182:end, :) = polar(180:-1:1, :);
    polar(182:end, 2) = -polar(182:end, 2);
    
    base = zeros(361,2);
    for theta = 0:360
        theta_rad = theta/180*pi;
        x = unit * cos(theta_rad);
        y = unit * sin(theta_rad);
        base(theta+1, :) = [x,y];
    end
    
    for unit_this = unit_all
        scale = unit_this/unit;
        plot(base(:,1)*scale, base(:,2)*scale, 'k:', 'LineWidth', 0.5);
    end
    plot(base(:,1), base(:,2), 'k:', 'LineWidth', 2);
    for theta = 0:30:360
        theta_rad = theta/180*pi;
        scale = max(unit_all);
        plot([0, scale*cos(theta_rad)], [0, scale*sin(theta_rad)], 'k:', 'LineWidth', 0.5)
    end
    plot(polar(:,1),polar(:,2),'-','LineWidth', 2)
    
    axis equal
    axis off
    axis([-axis_unit, axis_unit, -axis_unit, axis_unit])
    % legend()
%     pbaspect([1 1 1])

    pause = 1;
end