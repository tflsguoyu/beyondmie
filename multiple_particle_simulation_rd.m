disp('')
disp('=============== New script ===============')
close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

N_particle = 1000;
particle_size = 0.3;
out_dir = ['../results/out/disk_N' num2str(N_particle) '_' num2str(particle_size) 'um_test/'];
num_simul = 20;
flag = 'red';

%% User defined parameters
switch flag   
    case 'red'
        %%% input %%%
        wavelength = 0.70; %(um)
        %%% output %%%
        fn_mat = 'data_R.mat';
        fn_plot = 'farfield_R.jpg';
    
    case 'green'
        %%% input %%%
        wavelength = 0.53; %(um)
        %%% output %%%
        fn_mat = 'data_G.mat';
        fn_plot = 'farfield_G.jpg';
        
    case 'blue'
        %%% input %%%
        wavelength = 0.46; %(um)
        %%% output %%%
        fn_mat = 'data_B.mat';
        fn_plot = 'farfield_B.jpg';       
end

%% Pre defined parameters
unit = 1e-6; % Convert um to m
wavelength = wavelength * unit;

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

rd_list = linspace(0,0.25,91)*2*pi;
% rd_list = 0.24*2*pi;
rd_id = -1;
for rd = rd_list
    rd_id = rd_id+1;
for i = 1:num_simul
    disp(['----------- similation ' num2str(i) ' of ' num2str(num_simul) ' ...']);
    
    mu = [0,0,0]; sigma = [15,15,1]/3;
    particles = zeros(N_particle, 6);
    particles(:,1:3) = [normrnd(mu(1),sigma(1),[N_particle,1])* unit, ...
                        normrnd(mu(2),sigma(2),[N_particle,1])* unit ...
                        normrnd(mu(3),sigma(3),[N_particle,1])* unit];
    particles(:,1:3) = rotate_particles(particles(:,1:3), rd);
    particles(:,4) = particle_size * unit;
    particles(:,5) = 1.331721;
    particles(:,6) = 0;

    radius_max = max(particles(:,4));
    lmax = ceil(6*radius_max/wavelength+1.5);
    
    [p_NM_, ~,~,fp_,Cs_,Ct_, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);

    %%% ------ averaging ------ %%%
    Cs = (i-1)/i*Cs + 1/i*Cs_;
    Ct = (i-1)/i*Ct + 1/i*Ct_;
    fp = (i-1)/i*fp + 1/i*fp_;
    p_NM = (i-1)/i*p_NM + 1/i*p_NM_;
    %%% ----------------------- %%%

    Cs
    Ct
    %% Save to disk
    save([out_dir fn_mat(1:end-4) '_' num2str(rd_id) '.mat'], 'particles', 'wavelength', 'lmax', 'p_NM', 'fp', 'Cs', 'Ct');
    if mod(i,20)==0
        save_plot([out_dir fn_plot(1:end-4) '_' num2str(rd_id) '.jpg'], particles, p_NM, fp);
    end

end
end

function particles = rotate_particles(particles, rd)
    rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)] ;
    roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)] ;
    rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1] ;
    particles = (rotx(-rd) * particles')';
%     particles = (roty(rand*2*pi) * particles')';
%     particles = (rotz(rand*2*pi) * particles')';
end

