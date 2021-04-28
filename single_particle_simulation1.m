disp('')
disp('=============== New script ===============')
close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% User defined parameters
flag = 1; % 1 or 2 or 3

switch flag
    case 1
        % -------- example 1 ---------- %
        %%% input %%%
        wavelength = 0.60; %(um)
        particles = [0,0,0,0.6,1.331721,0]; % (x,y,z,radius,ior_real,ior_image)
        fn_mieplot = 'paras/mieplot/0.600_0.600_1.331721_0.txt';
        %%% output %%%
        out_dir = '../out/single/';
        fn_mat = 'data1.mat';
        fn_plot = 'farfield1.jpg';
    
    case 2
        
end

%% Pre defined parameters
unit = 1e-6; % Convert um to m
wavelength = wavelength * unit;
particles(1:4) = particles(1:4) * unit;
radius = particles(4);
lmax = ceil(6*radius/wavelength+1.5);
disp(['lmax:' num2str(lmax)]);

k = 2*pi/wavelength;
polar_angles = 0:pi/180:pi;
azimuthal_angles = 0:pi/180:2*pi;

if ~exist(out_dir, 'dir')
   mkdir(out_dir)
end

%% Simulation
[p1A,p1B,p2A,p2B, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);

T_per2_NM = abs(p1A).^2 + abs(p2A).^2;
T_par2_NM = abs(p1B).^2 + abs(p2B).^2;
T_NM = (T_per2_NM + T_par2_NM)./2;

T_per2_N1 = mean(T_per2_NM, 2);
T_par2_N1 = mean(T_par2_NM, 2);
T_N1 = mean(T_NM, 2);

% T_per_N1 = sqrt(T_per2_N1(1));
T_per_N1_tmp = mean(p1A, 2);
T_per_N1 = mean((p1A + p2A)./2, 2);
T_par_N1 = mean((p1B + p2B)./2, 2);
RT = abs(real(T_per_N1(1)));

fp_per_N1 = T_per2_N1./max(T_N1);
fp_par_N1 = T_par2_N1./max(T_N1);
fp = T_N1./max(T_N1);

bintgrnd = trapz(azimuthal_angles,T_NM');
intgrl = trapz(polar_angles, bintgrnd.*sin(polar_angles));
Cs = intgrl/(k^2);
Ct = 4*pi/(k^2)*RT;

Cs = Cs * 39.482; % magic number
Ct = Ct * 4536.5;

%% Load mie results
MieData = load_mieplot(fn_mieplot);
MieData = MieData./max(MieData(:));

%% Save to disk
save([out_dir, fn_mat], 'particles', 'wavelength', 'lmax', 'p1A','p1B','p2A','p2B', 'fp', 'Cs', 'Ct');
save_plot([out_dir fn_plot], T_NM, fp_per_N1, fp_par_N1, fp, MieData);


function save_plot(fn, T_NM, fp_per_N1, fp_par_N1, fp_N1, MieData)
    figure('Position', [10 10 1500 500]);

    subplot(1,3,1)
    polarplot3d(log(T_NM(1:91, :)));
    view([0,90]);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis([-1.1,1.1,-1.5,1.5]); axis('off');
    caxis([-inf,max(log(T_NM(:)))]);
    title('forward intensity (log)')

    subplot(1,3,2)
    polarplot3d(log(T_NM(end:-1:91, :)));
    view([0,90]);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis([-1.1,1.1,-1.5,1.5]); axis('off');
    caxis([-inf,max(log(T_NM(:)))]);
    title('backward intensity (log)')

    subplot(1,3,3)
    hold on;
    plot(log(MieData(:,1)),'g','LineWidth',2, 'DisplayName','MiePlot-Perpendicular'); 
    plot(log(MieData(:,2)),'b','LineWidth',2, 'DisplayName','MiePlot-Parallel'); 
    plot(log(MieData(:,3)),'r','LineWidth',2, 'DisplayName','MiePlot-Unpolarised'); 
    plot(log(fp_per_N1),'g:','LineWidth',4, 'DisplayName','CELES-Perpendicular'); 
    plot(log(fp_par_N1),'b:','LineWidth',4, 'DisplayName','CELES-Parallel'); 
    plot(log(fp_N1),'r:','LineWidth',4, 'DisplayName','CELES-Unpolarised'); 
    hold off;
    axis([0 180 -inf 0])
    title('intensity')
    xlabel('polar angle')
    ylabel('log of normalized')
    legend

    saveas(gcf, fn);
end

function data = load_mieplot(fn)
    data = importdata(fn);
    data = data.data;
    data = data(:,2:end);
end
