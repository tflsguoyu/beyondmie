close all; clear;
fn_particles = 'paras/particles_50.txt';
N_particle = 50;
particle_size = 0.5;
num_simul = 16;
out_dir = ['../results/out/color_N' num2str(N_particle) '_' num2str(particle_size*1000) 'nm/'];
wl_list = linspace(0.4,0.7,2);
for wl = wl_list
    run('multiple_particle_simulation_color.m')
end

for wl = wl_list
    tab_dir = [out_dir 'tab_' num2str(wl*1000)];
    save_tab_bin([out_dir 'data_' num2str(wl*1000)], [tab_dir, '.bin']);
end