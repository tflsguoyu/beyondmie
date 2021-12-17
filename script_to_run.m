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
num_simul = 1;
out_dir = 'out/';

%%%%%%%% Run simulation %%%%%%%%
run('multiparticles_simulation.m')

%%%%%%%% Save Results for rendering %%%%%%%%
save_tab_bin(out_dir);
    
%%%%%%%% Plot and save phase function %%%%%%%
polar_plot(out_dir);

