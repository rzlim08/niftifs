function matrix =  get_scan(char_list)
sample = load_untouch_nii(char_list(1,:));
matrix = zeros([size(char_list,1), numel(sample.img)]);
for i = 1:size(char_list,1)
    volume = load_untouch_nii(char_list(i,:));
    matrix(i, :) = volume.img(:);
end


end