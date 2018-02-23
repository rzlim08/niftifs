function print_unwarped(runs)

for i = 1:size(runs)

   after_file = dir([runs{i}.path filesep 'uag*.nii']);
   if ~isempty(after_file)
       before_file = dir([runs{i}.path filesep 'ag*.nii']);
       before_vol = spm_vol([runs{i}.path filesep before_file(1).name]);
       print_spm_image(before_vol, 'unwarped2', 'b4')
       after_vol = spm_vol([runs{i}.path filesep after_file(1).name]);
       print_spm_image(after_vol, 'unwarped2', 'after');
       spm_image('reset');
   end
   global st
   st.vols{1,1} = [];
   st.vols{2,1} = [];
   st.vols{3,1} = [];
end
end