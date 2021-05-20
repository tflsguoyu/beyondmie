addpath(genpath('src'));

%% RGB rendering
mistuba_dir = 'D:/gyDocuments/mitsuba2/dist/mitsuba.exe';
% scene_dir = 'scenes/cube2020.xml';
scene_dir = 'scenes/rainbow_mtb2_tab.xml';

data_dir = [out_dir 'data_' num2str(round(wl*1000)) '.mat'];
load(data_dir);
tab_dir = [out_dir 'tab_' num2str(round(wl*1000)) '.bin'];
save_tab_bin(fp, tab_dir);
ct_list = [ct_list Cs];


% img_dir = [out_dir 'render_' num2str(round(wl*1000)) '.exr'];
% 
% N = 500/height(particles);
% R = 86.1*1e-6;
% V = 4/3*pi*R^3;
% pho = N/V;
% scale = pho * Ct /100
% sigma_t = 1;
% % albedo = min(max(Cs/Ct,0),1)
% albedo = 1;
% 
% render_mitsuba2(...
%     mistuba_dir, ...
%     img_dir, ...
%     scene_dir, ...
%     false, ...
%     scale, sigma_t, albedo, ...
%     tab_dir);
