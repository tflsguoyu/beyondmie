% von Mises-Fisher Phase Function
%
function ret = vMF(kappa, cosTheta)
    if kappa == 0
        ret = 0.25/pi*ones(size(cosTheta));
    else
        ret = kappa/(2*pi*(1 - exp(-2*kappa)))*exp(kappa*(cosTheta - 1));
    end
end
