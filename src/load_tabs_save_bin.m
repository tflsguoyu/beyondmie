%% Testing
% save_tab_bin(pmf, 'scenes/tab/test.bin');

function load_tabs_save_bin(fn_mat, fn_bin)
    fn_cdf_bin = [fn_bin(1:end-4) '_cdf.bin'];
    if isfile(fn_bin) && isfile(fn_cdf_bin)
        disp(['Find tabulated binary file: ' fn_bin]);        
    else
        file_id = fopen(fn_bin, 'w');
        file_cdf_id = fopen(fn_cdf_bin, 'w');
        n = 0;
        for i = 0:90
            load([fn_mat '_' num2str(i) '.mat']);
            cdf_NM = compute_cdf(p_NM);
            fwrite(file_id, p_NM, 'float');
            fwrite(file_cdf_id, cdf_NM, 'float');
            n = n + width(p_NM) * height(p_NM);
            if i == 0
                disp(p_NM(1,1:10));
                disp(p_NM(1:10,1));
            end
        end
        fclose(file_id);
        fclose(file_cdf_id);
        disp(['Successful saved tabulated data to ' fn_bin ', N = ' num2str(n) '.']);
    end
end