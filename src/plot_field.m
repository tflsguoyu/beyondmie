function plot_field(ax,simulation,fieldType)

    hold(ax,'on')

    pArr = simulation.input.particles.positionArray;
    rArr = simulation.input.particles.radiusArray;
    dims = simulation.output.fieldPointsArrayDims;

    switch lower(fieldType)
        case 'total field'
            E = simulation.output.totalField;
        case 'scattered field'
            E = simulation.output.scatteredField + simulation.output.internalField;
        case 'initial field'
            E = simulation.output.initialField;
    end

    fld = reshape(gather(sqrt(sum(abs(E).^2,2))), dims);
    cmap = parula(256); % use default (sequential) colormap for abs(E)

    % define axis limits: lower limit should be 0 for abs(E) and -max(abs(E)) for real(Ei)
    caxislim = [-max(abs(fld(:)))*min(0, min(real(fld(:))))/min(real(fld(:))) , max(abs(fld(:)))];

    fldPnts = reshape([simulation.output.fieldPoints(:,1), ...
                       simulation.output.fieldPoints(:,2), ...
                       simulation.output.fieldPoints(:,3)], [dims,3]);

    if all(fldPnts(:,:,1) == fldPnts(1,1,1))    % fldPoints are on the yz plane
        perpdim = 1;                                % 1->x is the perp. direction
    elseif all(fldPnts(:,:,2) == fldPnts(1,1,2))% fldPoints are on the xz plane
        perpdim = 2;                                % 2->y is the perp. direction
    elseif all(fldPnts(:,:,3) == fldPnts(1,1,3))% fldPoints are on the xy plane
        perpdim = 3;                                % 3->z is the perp. direction
    else
        error('fieldPoint must define an xy, xz or yz-like plane')
    end

    xy = setdiff([1,2,3], perpdim);                 % here xy are the in-plane dimensions
    x = fldPnts(:,:,xy(1));
    y = fldPnts(:,:,xy(2));

    dist = abs(pArr(:,perpdim) - fldPnts(1,1,perpdim));% particle distances from xy plane
    idx = find(dist<rArr);                          % find particles intersecting the plane
    rArr(idx) = sqrt(rArr(idx).^2 - dist(idx).^2);  % overwrite radius of the intersection circle

    t = 0;

    for ti=1:numel(t)
        imagesc(x(1,:), y(:,1), fld)% plot field on a xy plane
        colormap(cmap)

        for i=1:length(idx)
            rectangle(ax, ...
                     'Position', [pArr(idx(i),xy)-rArr(idx(i)), [2,2]*rArr(idx(i))], ...
                     'Curvature', [1 1], ...
                     'FaceColor', 'none', ...
                     'EdgeColor', [0,0,0], ...
                     'LineWidth', 0.75)
        end
        axis([min(x(:)),max(x(:)),min(y(:)),max(y(:))]) % set axis tight to fldPoints

        labels = ['x'; 'y'; 'z'];
        xlabel(labels(xy(1)))
        ylabel(labels(xy(2)))

        ax.DataAspectRatio = [1,1,1];
        title([fieldType])
        colorbar
        caxis([0 5])
        drawnow

    end

    hold(ax,'off')

end
