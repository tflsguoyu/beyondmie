% clear; close all;
% out_dir = '../results/out/aniso_hg/';
% run('render_scene_aniso_hg.m')

clear; close all;
out_dir = '../results/out/disk_N1000_0.3um_2/';
run('render_scene_aniso.m')

% clear; close all;
% out_dir = '../results/out/rainbow_1_0.5nm/';
% wl_list = linspace(0.4,0.7,50);
% for wl = wl_list
%     run('render_scene_color.m')
% end

% clear; close all;
% out_dir = '../results/out/rainbow_1_0.5nm/';
% wl_list = linspace(0.4,0.7,50);
% for wl = wl_list
%     run('render_scene_color.m')
% end

% run('multiple_particle_simulation_aniso.m')

% close all; clear;
% fn_particles = 'paras/particles_100.txt';
% size_scale = 1;
% out_dir = '../results/out/multiple_100_300/';
% num_simul = 10;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_50.txt';
% size_scale = 4/3;
% out_dir = '../results/out/multiple_50_1.5/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_100.txt';
% size_scale = 4/3;
% out_dir = '../results/out/multiple_100_1.5/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_500.txt';
% size_scale = 4/3;
% out_dir = '../results/out/multiple_500_1.5/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')


% clear; close all;
% out_dir = '../results/out/multiple_1_1.5/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_50_1.5/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_100_1.5/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_500_1.5/';
% run('render_scene.m')

