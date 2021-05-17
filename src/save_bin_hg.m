%% Testing
% save_tab_bin(pmf, 'scenes/tab/test.bin');

function save_bin_hg(fn_bin)
    fn_cdf_bin = [fn_bin(1:end-4) '_cdf.bin'];
    fn_density_bin = [fn_bin(1:end-4) '_density.bin'];
    if isfile(fn_bin) && isfile(fn_cdf_bin) && isfile(fn_density_bin)
        disp(['Find tabulated binary file: ' fn_bin]);        
    else
        g = 0.8;
        theta = [0:180]/180*pi;
        p_N1 = 1/(4*pi)*(1-g^2)./(1+g^2-2*g*cos(theta(:))).^(3/2);
        p_NM = repmat(p_N1, [1,361]);
        cdf_NM = compute_cdf(p_NM);
        Cs = 1;
           
        file_id = fopen(fn_bin, 'w');
        file_cdf_id = fopen(fn_cdf_bin, 'w');
        file_density_id = fopen(fn_density_bin, 'w');
        n = 0;
        for i = 0:90
            fwrite(file_density_id, Cs, 'float');
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
        fclose(file_density_id);
        disp(['Successful saved tabulated data to ' fn_bin ', N = ' num2str(n) '.']);
    end
end