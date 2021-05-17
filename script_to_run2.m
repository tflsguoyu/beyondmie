close all; clear;
fn_particles = 'paras/particles_100.txt';
size_scale = 5/3;
out_dir = '../results/out/multiple_100_0.5nm/';
num_simul = 20;
wl_list = linspace(0.4,0.7,50);
for wl = wl_list
    run('multiple_particle_simulation_color.m')
end


