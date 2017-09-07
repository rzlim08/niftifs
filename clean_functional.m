function clean_functional(im_path)
hdr = spm_vol(im_path);
[folder, file, ext] = fileparts(im_path);
original_image = spm_read_vols(hdr);
image = imerode(original_image, strel('cube',3));
image = imdilate(image, strel('cube',3));
thresh = prctile(image(:), 90);
bi = image>thresh;
bi2 = imfill(bi, 'holes');
bi3 = bwconncomp(bi2, 6);
im2 = zeros(size(image));
[v, i] = max(cellfun(@(x)(size(x,1)), bi3.PixelIdxList));
im2(bi3.PixelIdxList{1,i}) = 1;
im2(im2==0) = 0.4;
new_image = original_image.*im2;
hdr.fname = [folder filesep 'ss' file ext];
spm_write_vol(hdr, new_image);
end