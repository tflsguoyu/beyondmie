close all; clear;
size_scale = 1;
distance_scale = 100;
out_dir = '../results/out/multiple_1_100/';
flag = 'red'; run('multiple_particle_simulation.m')
flag = 'green'; run('multiple_particle_simulation.m')
flag = 'blue'; run('multiple_particle_simulation.m')
