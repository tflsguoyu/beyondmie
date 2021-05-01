close all; clear;
distance_scale = 2;
out_dir = '../results/out/multiple2/';
flag = 'red'; run('multiple_particle_simulation.m') % blue
flag = 'green'; run('multiple_particle_simulation.m') % green
flag = 'blue'; run('multiple_particle_simulation.m') % red


close all; clear;
distance_scale = 10;
out_dir = '../results/out/multiple10/';
flag = 'red'; run('multiple_particle_simulation.m') % blue
flag = 'green'; run('multiple_particle_simulation.m') % green
flag = 'blue'; run('multiple_particle_simulation.m') % red
