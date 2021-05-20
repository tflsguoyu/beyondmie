close all; clear;
fn_particles = 'paras/particles_1.txt';
size_scale = 5/3;
out_dir = '../results/out/color_N1_500nm/';
num_simul = 1;
wl_list = linspace(0.4,0.7,50);
for wl = wl_list
    run('multiple_particle_simulation_color.m')
end


