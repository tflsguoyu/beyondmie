close all; clear;
fn_particles = 'paras/particles_1.txt';
size_scale = 5/3;
out_dir = '../results/out/multiple_1_0.5nm/';
num_simul = 1;
wl_list = linspace(0.4,0.7,50);
for wl = wl_list
    run('multiple_particle_simulation_cl.m')
end


