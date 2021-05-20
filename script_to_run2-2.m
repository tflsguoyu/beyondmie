close all; clear;
fn_particles = 'paras/correlated/negative/negative_0100_part_';
particle_size = 0.5;
out_dir = '../results/out/negative_N100_500nm/';
num_simul = 20;
wl_list = linspace(0.4,0.7,50);
for wl = wl_list(11:end)
    run('multiple_particle_simulation_color_correlated.m')
end


% close all; clear;
% fn_particles = 'paras/correlated/positive/positive_0100_part_';
% particle_size = 0.5;
% out_dir = '../results/out/positive_N100_500nm/';
% num_simul = 1;
% wl_list = linspace(0.4,0.7,50);
% for wl = 0.7
%     run('multiple_particle_simulation_color_correlated.m')
% end