close all; clear;
fn_particles = 'paras/particles_10.txt';
size_scale = 7/3;
out_dir = '../results/out/multiple_10_3/';
num_simul = 50;
flag = 'red'; run('multiple_particle_simulation.m')

close all; clear;
fn_particles = 'paras/particles_50.txt';
size_scale = 7/3;
out_dir = '../results/out/multiple_50_3/';
num_simul = 50;
flag = 'red'; run('multiple_particle_simulation.m')

close all; clear;
fn_particles = 'paras/particles_100.txt';
size_scale = 7/3;
out_dir = '../results/out/multiple_100_3/';
num_simul = 50;
flag = 'red'; run('multiple_particle_simulation.m')
