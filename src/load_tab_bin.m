%% Testing
% pmf = load_tab_bin('scenes/tab/test1.bin');

function pmf = load_tab_bin(fn)
    file_id = fopen(fn, 'r');
    n = fread(file_id, 1, 'int');
    pmf = flip(fread(file_id, 'float'));
    if n ~= length(pmf)
       disp(['N saved in file is ' num2str(n) ', but found ' num2str(length(pmf)) ' data.']); 
    end
    n = length(pmf);
    disp(['Successful loaded tabulated data from ' fn ', N = ' num2str(n) '.']);
end
