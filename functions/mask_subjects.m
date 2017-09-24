function mask_subjects(fs, path_to_subjs)


for i = 1:size(path_to_subjs)
   subj = path_to_subjs{i};
   phase = expand_folders(fs, [strsplit(subj, filesep), 'Localizers*', 'B0*', 'IM*1.nii']);
   magnitude = expand_folders(fs, [strsplit(subj, filesep), 'Localizers*', 'B0*', 'IM*2.nii']);
   
   
end

end