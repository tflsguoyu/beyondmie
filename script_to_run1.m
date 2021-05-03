close all; clear;
fn_particles = 'paras/particles_1.txt';
size_scale = 5/3;
out_dir = '../results/out/multiple_1_2/';
num_simul = 50;
flag = 'red'; run('multiple_particle_simulation.m')

close all; clear;
fn_particles = 'paras/particles_1.txt';
size_scale = 7/3;
out_dir = '../results/out/multiple_1_3/';
num_simul = 50;
flag = 'red'; run('multiple_particle_simulation.m')