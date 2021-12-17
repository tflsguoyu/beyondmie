function save_tab_bin(out_dir)
    load([out_dir 'data.mat'], 'fp', 'Cs', 'Ct');
    
    fn_bin = [out_dir 'fp_tab.bin'];
    file_id = fopen(fn_bin, 'w');
    n = length(fp);
    fwrite(file_id, n, 'int');
    fwrite(file_id, flip(fp), 'float');
    fclose(file_id);
    disp(['Successful saved tabulated data to ' fn_bin ', N = ' num2str(n) '.']);
    
    fn_density_bin = [out_dir 'density.bin'];
    file_density_id = fopen(fn_density_bin, 'w');
        R = 2e-4;
        N = 1;
        V = 4/3*pi*R^3;
        pho = N/V;
        Cs = Cs*pho;
        Ct = Ct*pho;
        fwrite(file_density_id, Cs, 'float');
    fclose(file_density_id);
end