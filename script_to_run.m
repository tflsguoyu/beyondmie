close all; clear;

%% User defined parameters %%
%%% about particle
particles_fn = 'paras/particles.txt';
particle_radius = 0.5; % (um, if want to use the value from file, set it to -1) 
ior_R = 1.2; % (if want to use the value from file, set it to -1) 
ior_I = 0; % (if want to use the value from file, set it to -1) 
%%% about light
wave_length = 0.7; % (um)
%%% about simulation
num_simul = 20;
out_dir = 'out/';

%%%%%%%% Run simulation %%%%%%%%
run('multiparticles_simulation.m')

%%%%%%%% Save Results %%%%%%%%
% if ~exist(out_dir, 'dir')
%    mkdir(out_dir)
% end
% tab_dir = [out_dir 'tab_' num2str(ior)];
% save_tab_bin([out_dir 'data_' num2str(ior)], [tab_dir, '.bin']);
    