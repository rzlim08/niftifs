function ss_image = image_calc_sample(im_path)
original = spm_vol(im_path);
[folder, file, ext] = fileparts(im_path);
c1_name = dir([folder filesep 'c1*.nii']);
c2_name = dir([folder filesep 'c2*.nii']);
c1 = spm_vol([folder filesep c1_name.name]);
c2 = spm_vol([folder filesep c2_name.name]);
original_image = spm_read_vols(original);
c1_image = spm_read_vols(c1);
c2_image = spm_read_vols(c2);
ss_image = original_image.*(c1_image+c2_image);
original.fname = [folder filesep 'ss' file ext];
spm_write_vol(original, ss_image);
end