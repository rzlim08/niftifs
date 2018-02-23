function print_spm_image(img, unique_name, bora)
fg = spm_figure('FindWin','Graphics');
if size(fg)==0; fg = spm_figure('GetWin', 'Graphics'); end
spm_orthviews('Image', img, [0.0 0.45 1 0.55], fg);
[folder, filename, ~] = fileparts(img.fname);
folders = strsplit(folder, filesep);
spm_orthviews('Caption', fg, [folders{7} '_' bora]);
spm_print(unique_name, fg);
end