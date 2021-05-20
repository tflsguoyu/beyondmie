% Henyey-Greenstein Phase Function
%
function ret = HG(g, cosTheta)
    if g == 0
        ret = 0.25/pi*ones(size(cosTheta));
    else
        ret = (1 - g^2)./(4*pi*(1 + g^2 - 2*g*cosTheta).^1.5);
    end
end
