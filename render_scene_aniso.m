addpath(genpath('src'));

%% Mitsuba1
% render_mitsuba1('D:/gyDocuments/mitsuba/dist/mitsuba.exe', 'scenes/lucy_mtb1_tab1.exr', 'scenes/lucy_mtb1_tab.xml', 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test1.bin');
% render_mitsuba1('D:/gyDocuments/mitsuba/dist/mitsuba.exe', 'scenes/lucy_mtb1_tab2.exr', 'scenes/lucy_mtb1_tab.xml', 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test2.bin');

%% Mitsuba2
% render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_tab1_gpu.exr', 'scenes/lucy_mtb2_tab.xml', true, 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test1.bin');
% render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_tab1_cpu.exr', 'scenes/lucy_mtb2_tab.xml', false, 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test1.bin');
% render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_tab2_cpu.exr', 'scenes/lucy_mtb2_tab.xml', false, 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test2.bin');

%% RGB rendering
mistuba_dir = 'D:/gyDocuments/mitsuba/dist/mitsuba.exe';
scene_dir = 'scenes/lucy_mtb1_tab.xml';
imgRGB_dir = [out_dir 'render.exr'];

flag_list = {'R','G','B'};
for i = 1
    tab_dir = [out_dir 'tab_' flag_list{i}];
    load_tabs_save_bin([out_dir 'data_' flag_list{i}], [tab_dir, '.bin']);
    img_dir = [out_dir 'render_' flag_list{i} '.exr'];
    
%     V = 4/3*pi*R^3;
%     pho = 1/V
%     scale = pho * Ct
    scale = 10;
    sigma_t = 1;
%     albedo = min(max(Cs/Ct,0),1)
    albedo = 0.98;

    render_mitsuba1(...
        mistuba_dir, ...
        img_dir, ...
        scene_dir, ...
        scale, sigma_t, albedo, ...
        tab_dir);
end

% img_R = exrread([out_dir 'render_R.exr']);
% img_G = exrread([out_dir 'render_G.exr']);
% img_B = exrread([out_dir 'render_B.exr']);
% exrwrite(cat(3,img_R(:,:,1),img_G(:,:,1),img_B(:,:,1)), imgRGB_dir);

