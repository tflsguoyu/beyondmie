close all; clear;
N_particle = 50;
particle_size = 0.5;
num_simul = 2;
out_dir = ['../results/out/color_aniso_N' num2str(N_particle) '_' num2str(particle_size*1000) 'nm/'];
wl_list = linspace(0.45,0.7,26);
for wl = wl_list
    wl
    run('multiple_particle_simulation_color_aniso.m')
end

for wl = wl_list
    tab_dir = [out_dir 'tab_' num2str(wl*1000)];
    load_tabs_save_bin([out_dir 'data_' num2str(wl*1000)], [tab_dir, '.bin']);

end