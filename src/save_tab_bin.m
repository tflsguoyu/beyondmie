%% Testing
% save_tab_bin(pmf, 'scenes/tab/test.bin');

function save_tab_bin(fn_mat, fn_bin)
    load([fn_mat  '.mat']);
    
    file_id = fopen(fn_bin, 'w');
    n = length(fp);
    fwrite(file_id, n, 'int');
    fwrite(file_id, flip(fp), 'float');
    fclose(file_id);
    disp(['Successful saved tabulated data to ' fn_bin ', N = ' num2str(n) '.']);
    
    fn_density_bin = [fn_bin(1:end-4) '_density.bin'];
    file_density_id = fopen(fn_density_bin, 'w');
    Cs_list = [];
    Ct_list = [];
        R = 2e-4;
        N = 1;
        V = 4/3*pi*R^3;
        pho = N/V;
        Cs = Cs*pho
        Cs_list = [Cs_list, Cs];
        Ct = Ct*pho;
        Ct_list = [Ct_list, Ct];
        fwrite(file_density_id, Cs, 'float');
    fclose(file_density_id);
end