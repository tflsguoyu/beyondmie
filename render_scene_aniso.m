addpath(genpath('src'));

%% RGB rendering
mistuba_dir = 'D:/gyDocuments/mitsuba/dist/mitsuba.exe';
scene_dir = 'scenes/box_mtb1_anisotab.xml';

flag_list = {'R','G','B'};
for i = 1
    tab_dir = [out_dir 'tab_' flag_list{i}];
    load_tabs_save_bin([out_dir 'data_' flag_list{i}], [tab_dir, '.bin']);
    img_dir = [out_dir 'render_' flag_list{i} '.exr'];
    
    scale = 1;
    albedo = 1;
    sigma_t = 1;

    render_mitsuba1(...
        mistuba_dir, ...
        img_dir, ...
        scene_dir, ...
        scale, sigma_t, albedo, ...
        tab_dir);
end

