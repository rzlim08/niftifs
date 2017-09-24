for i = 1:size(subjs2)
   cmd = ['dcm2nii ' subjs2{i, 1}]; 
   unix(cmd);
end