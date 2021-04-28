%% Testing
% save_tab_bin(pmf, 'scenes/tab/test.bin');

function save_tab_bin(pmf, fn)
    file_id = fopen(fn, 'w');
    n = length(pmf);
    fwrite(file_id, n, 'int');
    fwrite(file_id, flip(pmf), 'float');
    disp(['Successful saved tabulated data to ' fn ', N = ' num2str(n) '.']);
end