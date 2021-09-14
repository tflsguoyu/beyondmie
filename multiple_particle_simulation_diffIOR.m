disp('')
disp('=============== New script ===============')
% close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% User defined parameters
wavelength = wl;
fn_mat = ['data_' num2str(ior) '.mat'];
fn_plot = ['farfield_' num2str(ior) '.jpg'];

%% Pre defined parameters
unit = 1e-6; % Convert um to m
wavelength = wavelength * unit;

distance_scale = 1;
particles = readmatrix(fn_particles); % (x,y,z,radius,ior_real,ior_image)
[N,~] = size(particles);
particles(:,4) = particle_size;
particles(:,5) = ior;
particles(:,1:4) = particles(:,1:4) * unit;
particles(:,1:3) = particles(:,1:3) * distance_scale;
 
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
    save([out_dir fn_mat], 'particles', 'wavelength', 'lmax', 'p_NM', 'fp', 'Cs', 'Ct');
    if mod(i,num_simul)==0
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


