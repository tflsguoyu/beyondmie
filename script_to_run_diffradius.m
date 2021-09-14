close all; clear;
fn_particles = 'paras/particles_100.txt';
N_particle = 100;
particle_size = 0.3;
wl = 0.7;
num_simul = 1;
out_dir = ['../results/out/diffradius_N' num2str(N_particle) '_' num2str(particle_size*1000) 'nm/'];
sigma_list = [0.02,0.06,0.1,0.2];
for sigma = sigma_list
    tic
    run('multiple_particle_simulation_diffradius.m')
    toc
end

for sigma = sigma_list
    tab_dir = [out_dir 'tab_' num2str(sigma)];
    save_tab_bin([out_dir 'data_' num2str(sigma)], [tab_dir, '.bin']);
end