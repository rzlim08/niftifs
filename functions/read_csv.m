function read_csv(fs, scans)
for i = 1:size(scans,1)
   file_name = scans{i,:};
   reorient_params = csvread(file_name);
   f = strsplit(file_name, filesep);
   d = expand_folders(fs, [f(1:end-3) 'Localizers*' 'B0*' 'IM*.nii']);
   auto_reorient(d, reorient_params);
end
end

function auto_reorient(P, B)
Mats = zeros(4,4,numel(P));
for i=1:numel(P)
    Mats(:,:,i) = spm_get_space(P{i});
end
mat = spm_matrix(B);
for i=1:numel(P)
    spm_get_space(P{i},mat*Mats(:,:,i));
end

end