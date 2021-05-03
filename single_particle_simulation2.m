disp('')
disp('=============== New script ===============')
close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% Load mie results
fn_mieplot = 'paras/mieplot/CtCs_0.100-1.000_0.500_1.5_0.1.txt';
MieData = load_mieplot(fn_mieplot);

%% User defined parameters

%%% input %%%
wavelength = 0.50; %(um)
particles = [0,0,0,0.0,1.5,0.1]; % (x,y,z,radius,ior_real,ior_image)
radius_list = 0.1:0.1:0.6; % MieData(:,1);
%%% output %%%
out_dir = '../results/out/single2/';
fn_mat = 'data3.mat';
fn_plot = 'CsCt3.jpg';


%% Main
unit = 1e-6; % Convert um to m
MieData(:,1) = MieData(:,1) * unit;

radius_list = radius_list * unit;
wavelength = wavelength * unit;
polar_angles = 0:pi/180:pi;
azimuthal_angles = 0:pi/180:2*pi;

if ~exist(out_dir, 'dir')
   mkdir(out_dir)
end

Cs_list = zeros('like', radius_list);
Ct_list = zeros('like', radius_list);
fp_list = zeros(length(radius_list), 181);

for i = 1:length(radius_list)
    radius = radius_list(i);

    %% Pre defined parameters
    particles(4) = radius;
    lmax = ceil(6*radius/wavelength+1.5);

    %% Simulation
    [p_NM, fpA,fpB,fp,Cs,Ct, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);

    Cs_list(i) = Cs;
    Ct_list(i) = Ct;
    fp_list(i,:) = fp;

end

%% Save to disk
save([out_dir, fn_mat], 'radius_list', 'wavelength', 'fp_list', 'Cs_list', 'Ct_list');
save_plot([out_dir fn_plot], wavelength, radius_list, Cs_list, Ct_list, fp_list, MieData);


function save_plot(fn, wavelength, radius_list, Cs_list, Ct_list, fp_list, MieData)
    figure('Position', [10 10 500 500]);

    subplot(1,1,1)
    hold on;
    plot(MieData(:,1), MieData(:,2),'g','LineWidth',1, 'DisplayName','MiePlot-Ct'); 
    plot(MieData(:,1), MieData(:,3),'b','LineWidth',1, 'DisplayName','MiePlot-Cs'); 
    scatter(radius_list, Ct_list, 'go','LineWidth',2, 'DisplayName','CELES-Ct'); 
    scatter(radius_list, Cs_list, 'bo','LineWidth',2, 'DisplayName','CELES-Cs'); 
    hold off;
    title(['wavelength: ' num2str(wavelength)])
    xlabel('radius')
    ylabel('cross section')
    legend('Location','northwest')

    saveas(gcf, fn);
    close(gcf); 
end

function data = load_mieplot(fn)
    data = readmatrix(fn);
    data = data(1:end-1,1:3);
end
