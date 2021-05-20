% clear; close all;
% out_dir = '../results/out/aniso_hg/';
% run('render_scene_aniso_hg.m')

% clear; close all;
% out_dir = '../results/out/disk_N50_0.3um/';
% run('render_scene_aniso.m')

% clear; close all;
% out_dir = '../results/out/multiple_100_0.5nm/';
% wl_list = linspace(0.4,0.7,50);
% for wl = wl_list
%     run('render_scene_color.m')
% end

clear; close all;
out_dir = '../results/out/color_N1_500nm/';
wl_list = linspace(0.4,0.7,50);
ct_list = [];
for wl = wl_list
    run('render_scene_color.m')
end
save([out_dir 'ct_list.mat'], 'ct_list');

% run('multiple_particle_simulation_aniso.m')

% close all; clear;
% fn_particles = 'paras/particles_50.txt';
% size_scale = 1;
% out_dir = '../results/out/multiple_N50_300nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_50.txt';
% size_scale = 4/3;
% out_dir = '../results/out/multiple_N50_400nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_50.txt';
% size_scale = 5/3;
% out_dir = '../results/out/multiple_N50_500nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_100.txt';
% size_scale = 1;
% out_dir = '../results/out/multiple_N100_300nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_100.txt';
% size_scale = 4/3;
% out_dir = '../results/out/multiple_N100_400nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_100.txt';
% size_scale = 5/3;
% out_dir = '../results/out/multiple_N100_500nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_500.txt';
% size_scale = 1;
% out_dir = '../results/out/multiple_N500_300nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_500.txt';
% size_scale = 4/3;
% out_dir = '../results/out/multiple_N500_400nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')
% 
% close all; clear;
% fn_particles = 'paras/particles_500.txt';
% size_scale = 5/3;
% out_dir = '../results/out/multiple_N500_500nm/';
% num_simul = 50;
% flag = 'red'; run('multiple_particle_simulation.m')

% clear; close all;
% out_dir = '../results/out/multiple_1_1.5/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N50_300nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N50_400nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N50_500nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N100_300nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N100_400nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N100_500nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N500_300nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N500_400nm/';
% run('render_scene.m')
% 
% clear; close all;
% out_dir = '../results/out/multiple_N500_500nm/';
% run('render_scene.m')

