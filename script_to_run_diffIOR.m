close all; clear;
fn_particles = 'paras/particles_100.txt';
N_particle = 100;
particle_size = 0.5;
wl = 0.7;
num_simul = 50;
out_dir = ['../results/out/diffIOR_N' num2str(N_particle) '_' num2str(particle_size*1000) 'nm/'];
ior_list = [1.2,1.3,1.4,1.5];
for ior = ior_list
    tic
    run('multiple_particle_simulation_diffIOR.m')
    toc
end

for ior = ior_list
    tab_dir = [out_dir 'tab_' num2str(ior)];
    save_tab_bin([out_dir 'data_' num2str(ior)], [tab_dir, '.bin']);
end