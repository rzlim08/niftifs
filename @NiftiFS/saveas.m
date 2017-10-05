function saveas(obj, filename)
% save the NiftiFS file
n = inputname(1);
eval([n '= obj;']);
save([pwd filesep filename '.mat'], n);
end