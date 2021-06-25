disp('')
disp('=============== New script ===============')
close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% User defined parameters

%%% input %%%
wavelength = 0.6; %(um)
particles = [0,0,0,0.9,1.331721,0]; % (x,y,z,radius,ior_real,ior_image)
fn_mieplot = 'paras/mieplot/0.900_0.600_1.331721_0.txt';
%%% output %%%
out_dir = '../results/out/single/';
fn_mat = 'data2.mat';
fn_plot = 'farfield2.jpg';

%% Load mie results
MieData = load_mieplot(fn_mieplot);

%% Pre defined parameters
unit = 1e-6; % Convert um to m
wavelength = wavelength * unit;
particles(1:4) = particles(1:4) * unit;
radius = particles(4);
lmax = ceil(6*radius/wavelength+1.5);

k = 2*pi/wavelength;
polar_angles = 0:pi/180:pi;
azimuthal_angles = 0:pi/180:2*pi;

if ~exist(out_dir, 'dir')
   mkdir(out_dir)
end

%% Simulation
% [p_NM, fpA,fpB,fp,Cs,Ct, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);

%% Save to disk
% save([out_dir, fn_mat], 'particles', 'wavelength', 'lmax', 'p_NM', 'fpA', 'fpB', 'fp', 'Cs', 'Ct');
% save_plot([out_dir fn_plot], p_NM, fpA, fpB, fp, MieData);

load([out_dir, fn_mat]);

%%
% fig2 = figure('Position', [100 400 512 512]);
% hold on
% % polar_plot([fpA(:)';fpB(:)';fp(:)'], [[0.4940 0.1840 0.5560]; [0.4660 0.6740 0.1880]; [0.8500 0.3250 0.0980]]);
%     plot(log(MieData(:,1)/sum(MieData(:,1))),'Color', [0.4940 0.1840 0.5560], 'LineWidth',3); 
%     plot(log(MieData(:,2)/sum(MieData(:,2))),'Color', [0.4660 0.6740 0.1880], 'LineWidth',3); 
%     plot(log(MieData(:,3)/sum(MieData(:,3))),'Color', [0.8500 0.3250 0.0980], 'LineWidth',3); 
%     plot(log(fpA),':', 'Color', [0.4940 0.1840 0.5560],'LineWidth',6); 
%     plot(log(fpB),':','Color', [0.4660 0.6740 0.1880],'LineWidth',6); 
%     plot(log(fp),':','Color', [0.8500 0.3250 0.0980],'LineWidth',6); 
% legend({'Lorenz-Mie: Perpendicular', 'Lorenz-Mie: Parallel', 'Lorenz-Mie: Unpolarised', ...
%     'Ours: Perpendicular', 'Ours: Parallel', 'Ours: Unpolarised'}, ...
%     'Location','northeast', 'FontSize',14,'TextColor','black');%legend('boxoff')
% hold off
% box on; 
% set(gca,'TickLength',[0 0])
% axis([0 180 -14 0])
% xticks([0 90 180]); xticklabels({'0','90','180'})
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'fontsize',14)
% xlabel('Polar angle', 'FontSize',18)
% ylabel('Intensity (log scale)', 'FontSize',18)
% saveas(gca, 'pf_test.png');
% im = imread('pf_test.png');
% [h,w,~] = size(im);
% % a_crop = round(h * 0.08);
% a_crop = round(h * 0); shift = 0;
% im = im(a_crop+1+shift: end-a_crop+shift,a_crop+1: end-a_crop,:);
% imwrite(im, 'pf_test.png');

%%
mie = MieData(:,3)/sum(MieData(:,3));

fig2 = figure('Position', [100 400 500 500]);
hold on
polar_plot1([mie(:)';fp(:)'], [[0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880]], 1);
legend({'Lorenz-Mie', 'Ours'}, 'Location','northwest', 'FontSize',15,'TextColor','black');legend('boxoff')
hold off
saveas(gca, ['tmp.png']);
im = imread(['tmp.png']);
[h,w,~] = size(im);
a_crop = round(h * 0.08);
shift = -10;
im = im(a_crop+1+shift: end-a_crop+shift,   a_crop+1: end-a_crop/2,:);
imwrite(im, ['tmp.png']);
close all;

%%
function save_plot(fn, p_NM, fpA, fpB, fp, MieData)
    figure('Position', [10 10 1500 500]);

    subplot(1,3,1)
    polarplot3d(log(p_NM(1:91, :)));
    view([0,90]);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis([-1.1,1.1,-1.5,1.5]); axis('off');
    caxis([-inf,max(log(p_NM(:)))]);
    title('forward intensity (log)')

    subplot(1,3,2)
    polarplot3d(log(p_NM(end:-1:91, :)));
    view([0,90]);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis([-1.1,1.1,-1.5,1.5]); axis('off');
    caxis([-inf,max(log(p_NM(:)))]);
    title('backward intensity (log)')

    subplot(1,3,3)
    hold on;
    plot(log(MieData(:,1)/sum(MieData(:,1))),'g','LineWidth',2, 'DisplayName','MiePlot-Perpendicular'); 
    plot(log(MieData(:,2)/sum(MieData(:,2))),'b','LineWidth',2, 'DisplayName','MiePlot-Parallel'); 
    plot(log(MieData(:,3)/sum(MieData(:,3))),'r','LineWidth',2, 'DisplayName','MiePlot-Unpolarised'); 
    plot(log(fpA),'g:','LineWidth',4, 'DisplayName','CELES-Perpendicular'); 
    plot(log(fpB),'b:','LineWidth',4, 'DisplayName','CELES-Parallel'); 
    plot(log(fp),'r:','LineWidth',4, 'DisplayName','CELES-Unpolarised'); 
    hold off;
    axis([0 180 -inf 0])
    title('intensity')
    xlabel('polar angle')
    ylabel('log of normalized')
    legend

    saveas(gcf, fn);
    close(gcf); 
end

function data = load_mieplot(fn)
    data = readmatrix(fn);
    data = data(1:181,2:4);
end
