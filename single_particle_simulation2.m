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
radius_list = 0.1:0.1:1; % MieData(:,1);
%%% output %%%
out_dir = '../results/out/single2/';
fn_mat = 'data3.mat';
fn_plot = 'CsCt3.jpg';


%% Main
unit = 1e-6; % Convert um to m
% MieData(:,1) = MieData(:,1) * unit;

id = zeros(1,10);
j = 0;
for radius = radius_list
    j = j + 1;
    dist = 999;
    for i = 1: size(MieData,1)
        dist_this = abs(MieData(i,1)-radius);
        if  dist_this < dist
            id(j) = i;
            dist = dist_this;
        end
    end
end
C_list = MieData(id,1:3);


fig2 = figure('Position', [100 400 800 400]);
hold on
% polar_plot([fpA(:)';fpB(:)';fp(:)'], [[0.4940 0.1840 0.5560]; [0.4660 0.6740 0.1880]; [0.8500 0.3250 0.0980]]);
    plot(MieData(:,1), MieData(:,2), 'Color', [0.4940 0.1840 0.5560], 'LineWidth',3); 
    plot(MieData(:,1), MieData(:,3), 'Color', [0.4660 0.6740 0.1880], 'LineWidth',3); 
    plot(C_list(:,1), C_list(:,2), '^', 'Color', [0.4940 0.1840 0.5560],'LineWidth',6); 
    plot(C_list(:,1), C_list(:,3), '^', 'Color', [0.4660 0.6740 0.1880],'LineWidth',6); 
legend({'Lorenz-Mie: Extinction cross-section', 'Lorenz-Mie: Scattering cross-section', ...
    'Ours: Extinction cross-section', 'Ours: Scattering cross-section'}, ...
    'Location','northwest', 'FontSize',14,'TextColor','black');%legend('boxoff')
hold off
box on; 
set(gca,'TickLength',[0 0])
axis([0.1 1 -inf inf])
xticks([0.1 0.55 1]); xticklabels({'100','550','1000'})
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'fontsize',14)
xlabel('Particle radius (nm)', 'FontSize',18)
ylabel('Cross-section', 'FontSize',18)
saveas(gca, 'pf_test.png');
im = imread('pf_test.png');
[h,w,~] = size(im);
% a_crop = round(h * 0.08);
a_crop = round(h * 0); shift = 0;
im = im(a_crop+1+shift: end-a_crop+shift,a_crop+1: end-a_crop,:);
imwrite(im, 'pf_test.png');

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
