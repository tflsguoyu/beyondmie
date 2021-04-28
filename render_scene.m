addpath(genpath('src'));

%% Mitsuba1
% render_mitsuba1('D:/gyDocuments/mitsuba/dist/mitsuba.exe', 'scenes/lucy_mtb1_tab1.exr', 'scenes/lucy_mtb1_tab.xml', 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test1.bin');
% render_mitsuba1('D:/gyDocuments/mitsuba/dist/mitsuba.exe', 'scenes/lucy_mtb1_tab2.exr', 'scenes/lucy_mtb1_tab.xml', 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test2.bin');

%% Mitsuba2
% render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_hg_gpu.exr', 'scenes/lucy_mtb2_hg.xml', true, '');
% render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_tab1_gpu.exr', 'scenes/lucy_mtb2_tab.xml', true, 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test1.bin');
% render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_tab1_cpu.exr', 'scenes/lucy_mtb2_tab.xml', false, 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test1.bin');
render_mitsuba2('D:/gyDocuments/mitsuba2/dist/mitsuba.exe', 'scenes/lucy_mtb2_tab2_cpu.exr', 'scenes/lucy_mtb2_tab.xml', false, 'D:/gyDocuments/4_waveoptics/codes/scenes/tab/test2.bin');

