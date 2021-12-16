function save_plot(fn, particles, p_NM, fp)
    figure('Position', [10 10 250 250]);
    
%     subplot(2,2,1)
%     polarplot3d(log(p_NM(1:91, :)), 'PolarGrid', {0,0});
%     view([0,90]);
%     set(gca,'DataAspectRatio',[1,1,1]);
%     axis([-1.1,1.1,-1.5,1.5]); axis('off');
%     caxis([-10,2]);
%     title('forward intensity (log)')
% 
%     subplot(2,2,2)
%     polarplot3d(log(p_NM(end:-1:91, :)), 'PolarGrid', {0,0});
%     view([0,90]);
%     set(gca,'DataAspectRatio',[1,1,1]);
%     axis([-1.1,1.1,-1.5,1.5]); axis('off');
%     caxis([-10,2]);
%     title('backward intensity (log)')
% 
%     subplot(2,2,3)
%     title('intensity')
%     xlabel('polar angle')
%     yyaxis left
%     plot(fp,'LineWidth',2, 'DisplayName','CELES-Unpolarised'); 
%     ylim([0 1])
%     ylabel('phase function')
%     legend
%     yyaxis right
%     plot(log(fp),'LineWidth',2, 'DisplayName','CELES-Unpolarised'); 
%     ylim([-14 0])
%     ylabel('phase function (log)')
%     legend

%     subplot(2,2,4)
    plot_spheres(gca, particles(:,1:3), particles(:,4), particles(:,5)+1i*particles(:,6));
    axis equal;
    pt = particles(:,1:3);
    max_r = max(abs(pt(:)));
    if max_r == 0
        max_r = 1e-6;
    end
    xlim([-max_r max_r])
    ylim([-max_r max_r])
    zlim([-max_r max_r])
    axis off
    view(3)
    saveas(gcf, fn);
    close(gcf); 
end
