dir = 'D:\gyDocuments\4_waveoptics\results\out\multiple_100_0.5nm\';
wl_list = round(linspace(400,700,50));
ct_list = [];
for wl = wl_list
    mat_dir = [dir 'data_' num2str(wl) '.mat'];
    load(mat_dir);
    ct_list = [ct_list Cs];
end
save('ct_list.mat', 'ct_list');
