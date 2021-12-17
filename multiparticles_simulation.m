warning('off','all');
addpath(genpath('src'));

disp('')
disp('=============== Start simulation ===============')

%% Temporary folder and files
if ~exist(out_dir, 'dir')
   mkdir(out_dir)
end
tmp_file = [out_dir 'data.mat'];
tmp_plot = [out_dir 'farfield.png'];

%% Pre defined parameters
%%% retouch particles
scale = 1;
particles = readmatrix(particles_fn); % (x,y,z,radius,ior_real,ior_image)
[N,~] = size(particles);
particles(:,1:3) = particles(:,1:3) * scale;
if particle_radius > 0
    particles(:,4) = particle_radius;
end
if ior_R > 0
    particles(:,5) = ior_R;
end
if ior_I > 0
    particles(:,6) = ior_I;
end
%%% Convert um to m
unit = 1e-6;
particles(:,1:4) = particles(:,1:4) * unit;
wave_length = wave_length * unit;
%%% compute lmax, the larger the slower but more accurate 
radius_max = max(particles(:,4));
lmax = ceil(6 * radius_max / wave_length + 1.5);
%%% other paramters
k = 2 * pi / wave_length;
polar_angles = 0 : pi/180 : pi;
azimuthal_angles = 0 : pi/180 : 2*pi;


%% Simulation
Cs = 0;
Ct = 0;
fp = 0;
p_NM = 0;
for i = 1:num_simul
    disp(['----------- similating ' num2str(i) ' of ' num2str(num_simul) ' ...']);
    particles(:,1:3) = rotate_particles(particles(:,1:3));
    [p_NM_, ~,~,fp_,Cs_,Ct_, ~,~] = wave_simulate(particles, wave_length, lmax, polar_angles, azimuthal_angles);
    
    %%% ------ averaging ------ %%%
    Cs = (i-1)/i*Cs + 1/i*Cs_;
    Ct = (i-1)/i*Ct + 1/i*Ct_;
    fp = (i-1)/i*fp + 1/i*fp_;
    p_NM = (i-1)/i*p_NM + 1/i*p_NM_;
    %%% ----------------------- %%%

    %% Save temporary files to disk
    save(tmp_file, 'particles', 'wave_length', 'lmax', 'p_NM', 'fp', 'Cs', 'Ct');
    if mod(i,num_simul) >= 0
        save_plot(tmp_plot, particles, p_NM, fp);
    end

end

