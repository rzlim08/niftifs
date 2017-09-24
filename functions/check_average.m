function ave_run = check_average(char_list)
hdrs = spm_vol(char_list);
matrix = zeros([size(hdrs,1), prod(hdrs(1).dim)]);
for i = 1:size(hdrs,1)
    volume = spm_read_vols(hdrs(i));
    matrix(i, :) = volume(:);
end
    ave_run = mean(matrix,1);
    
end