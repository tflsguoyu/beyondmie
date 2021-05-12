function cdf = compute_cdf(p)
    cdf = zeros(size(p));
    polar_angles = 0:pi/180:pi; polar_angles = polar_angles(:);
    azimuthal_angles = 0:pi/180:2*pi;
    
    bintgrnd = trapz(polar_angles, p.*repmat(sin(polar_angles), [1,361]));
    
    cdf_azimuthal = zeros(361,1);
    for phi = 1:360
        cdf_azimuthal(phi+1) = trapz(azimuthal_angles(0+1:phi+1), bintgrnd(0+1:phi+1));
    end
    
    for phi = 0:359
        cdf_pre = cdf_azimuthal(phi+1);
        for theta = 0:180
            if theta == 0
                cdf(theta+1, phi+1) = cdf_pre;    
            else
                cdf_current = trapz(polar_angles(0+1:theta+1), p(0+1:theta+1, phi+1).* sin(polar_angles(0+1:theta+1)));
                cdf_cumulate = cdf_pre + (cdf_azimuthal(phi+2)-cdf_azimuthal(phi+1))*cdf_current/bintgrnd(phi+1);
                cdf(theta+1, phi+1) = cdf_cumulate;
            end
        end           
    end
    cdf(:, 360+1) = 1;
end