function plot_spheres(positionArray, radiusArray, refractiveIndexArray, sphereResolution)

    if ~exist('sphereResolution','var')
        sphres = 16; % looks sufficiently like a sphere
    else
        sphres = sphereResolution;
    end
    [vx, vy, vz] = sphere(sphres); % sphere base model

    % normalize to 1
    realRInorm = real(refractiveIndexArray)/max(abs((refractiveIndexArray)));
    imagRInorm = imag(refractiveIndexArray)/max(abs(imag(refractiveIndexArray)));
    if isnan(imagRInorm)
        imagRInorm = imag(refractiveIndexArray);
    end

    realRInorm_repelem = repelem(realRInorm, sphres+2);
    realRInorm = repmat(realRInorm_repelem(:),[1,sphres+1]);
    imagRInorm_repelem = repelem(imagRInorm, sphres+2);
    imagRInorm = repmat(imagRInorm_repelem(:),[1,sphres+1]);

    hold on;

    % plotting just one merged surface is incredibly faster
    xmerged = zeros(size(positionArray,1)*(sphres+2), sphres+1);
    ymerged = zeros(size(positionArray,1)*(sphres+2), sphres+1);
    zmerged = zeros(size(positionArray,1)*(sphres+2), sphres+1);

    for jS = 1:size(positionArray,1)
        idx = (1:sphres+2)+(jS-1)*(sphres+2);
        xmerged(idx,:) = [vx*radiusArray(jS) + positionArray(jS,1); NaN*ones(1,sphres+1)];
        ymerged(idx,:) = [vy*radiusArray(jS) + positionArray(jS,2); NaN*ones(1,sphres+1)];
        zmerged(idx,:) = [vz*radiusArray(jS) + positionArray(jS,3); NaN*ones(1,sphres+1)];
    end

    % color each sphere with a unique shade
    CO(:,:,1) = imagRInorm; % red
    CO(:,:,2) = zeros(size(zmerged)); % green
    CO(:,:,3) = realRInorm; % blue

    surf(xmerged, ymerged, zmerged, CO, 'LineStyle', 'none');
    view([180 0]);
    light; lighting gouraud
    set(gca,'DataAspectRatio',[1,1,1]);
    xlabel('x'); ylabel('y'); zlabel('z');

    hold off;
end
