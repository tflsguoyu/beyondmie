close all; clear;
distance_scale = 50;
out_dir = '../results/out/multiple50/';
flag = 'red'; run('multiple_particle_simulation.m') % blue
flag = 'green'; run('multiple_particle_simulation.m') % green
flag = 'blue'; run('multiple_particle_simulation.m') % red


close all; clear;
distance_scale = 100;
out_dir = '../results/out/multiple100/';
flag = 'red'; run('multiple_particle_simulation.m') % blue
flag = 'green'; run('multiple_particle_simulation.m') % green
flag = 'blue'; run('multiple_particle_simulation.m') % red