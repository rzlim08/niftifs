function matrix =  get_scan(char_list)
hdrs = spm_vol(char_list);
matrix = zeros([size(hdrs,1), prod(hdrs(1).dim)]);
for i = 1:size(hdrs,1)
    volume = spm_read_vols(hdrs(i));
    matrix(i, :) = volume(:);
end


end