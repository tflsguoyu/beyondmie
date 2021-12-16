disp('')
disp('=============== New script ===============')
% close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% User defined parameters
switch flag   
    case 'red'
        %%% input %%%
        wavelength = 0.70; %(um)
        %%% output %%%
        fn_mat = 'data_R.mat';
        fn_plot = 'farfield_R.jpg';
        fn_plot_particles = 'particles.jpg';    
    
    case 'green'
        %%% input %%%
        wavelength = 0.53; %(um)
        %%% output %%%
        fn_mat = 'data_G.mat';
        fn_plot = 'farfield_G.jpg';
        fn_plot_particles = 'particles.jpg';
        
    case 'blue'
        %%% input %%%
        wavelength = 0.46; %(um)
        %%% output %%%
        fn_mat = 'data_B.mat';
        fn_plot = 'farfield_B.jpg';
        fn_plot_particles = 'particles.jpg';
       
end

%% Pre defined parameters
unit = 1e-6; % Convert um to m
wavelength = wavelength * unit;

particles = readmatrix(fn_particles); % (x,y,z,radius,ior_real,ior_image)
particles(:,1:4) = particles(:,1:4) * unit;
particles(:,1:3) = particles(:,1:3) * distance_scale;
particles(:,4) = particles(:,4) * size_scale;

radius_max = max(particles(:,4));
lmax = ceil(6*radius_max/wavelength+1.5);

k = 2*pi/wavelength;
polar_angles = 0:pi/180:pi;
azimuthal_angles = 0:pi/180:2*pi;

if ~exist(out_dir, 'dir')
   mkdir(out_dir)
end


%% Simulation
Cs = 0;
Ct = 0;
fp = 0;
p_NM = 0;
for i = 1:num_simul
    disp(['----------- similation ' num2str(i) ' of ' num2str(num_simul) ' ...']);
    particles(:,1:3) = rotate_particles(particles(:,1:3));
    tic
    [p_NM_, ~,~,fp_,Cs_,Ct_, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);
    toc
    %%% ------ averaging ------ %%%
    Cs = (i-1)/i*Cs + 1/i*Cs_;
    Ct = (i-1)/i*Ct + 1/i*Ct_;
    fp = (i-1)/i*fp + 1/i*fp_;
    p_NM = (i-1)/i*p_NM + 1/i*p_NM_;
    %%% ----------------------- %%%

    Cs
    Ct
    %% Save to disk
    save([out_dir fn_mat], 'particles', 'wavelength', 'lmax', 'p_NM', 'fp', 'Cs', 'Ct');
    fig2 = figure('Position', [100 400 500 500]);
    hold on
    polar_plot14(fp(:)', [0.4940 0.1840 0.5560], 1);
%     legend({'N=20'}, 'Location','northwest', 'FontSize',12,'TextColor','black');legend('boxoff')
    hold off
    saveas(gca, [out_dir 'phase' num2str(i) '.png']);
%     im = imread([out_dir 'tmp.png']);
%     [h,w,~] = size(im);
%     a_crop = round(h * 0.13); shift1 = -60; shift2 = 0;
%     im = im(a_crop+1+shift1: end-a_crop+shift1,   a_crop+1+shift2: end-a_crop+shift2,:);
%     imwrite(im, [out_dir 'phase' num2str(i) '.png']);
    close all;
    if mod(i,1)==0
        save_plot([out_dir fn_plot(1:end-4) '_' num2str(i) '.jpg'], particles, p_NM, fp);
    end

end


function particles = rotate_particles(particles)
    rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)] ;
    roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)] ;
    rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1] ;
    particles = (rotx(rand*2*pi) * particles')';
    particles = (roty(rand*2*pi) * particles')';
    particles = (rotz(rand*2*pi) * particles')';
end

