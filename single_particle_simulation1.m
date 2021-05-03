disp('')
disp('=============== New script ===============')
close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% User defined parameters

%%% input %%%
wavelength = 0.6; %(um)
particles = [0,0,0,0.3,1.331721,0]; % (x,y,z,radius,ior_real,ior_image)
fn_mieplot = 'paras/mieplot/0.300_0.600_1.331721_0.txt';
%%% output %%%
out_dir = '../results/out/single/';
fn_mat = 'data1.mat';
fn_plot = 'farfield1.jpg';

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
[p_NM, fpA,fpB,fp,Cs,Ct, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);

%% Save to disk
save([out_dir, fn_mat], 'particles', 'wavelength', 'lmax', 'p_NM', 'fpA', 'fpB', 'fp', 'Cs', 'Ct');
save_plot([out_dir fn_plot], p_NM, fpA, fpB, fp, MieData);


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
