function create_vdm_subjects(fs, path_to_subjs)
load('~/niftifs/IP.mat');
%% VDM params
IP.et{1} = 10;
IP.et{2} = 14.06;
IP.maskbrain = 1;
IP.blipdir = 1;
IP.tert = 44.54;

for i = 1:size(path_to_subjs)
   [IP.vdm, IP.vdmP, IP.epiP, IP.vdmP, IP.uepiP, IP.fm, IP.fmagP] = deal([]); 
   subj = path_to_subjs{i};
   phase = expand_folders(fs, [strsplit(subj, filesep), 'Localizer*', 'B0*', 'IM*1.nii']);
   magnitude = expand_folders(fs, [strsplit(subj, filesep), 'Localizer*', 'B0*', 'IM*2.nii']);
   epi = expand_folders(fs, [strsplit(subj, filesep), 'Functional', 'fMRI_ToL_1*', 'g*.nii']);
   sc = FieldMap('scale', phase{1,1});
   IP.P{1} = sc;
   IP.P{2} = spm_vol(magnitude{1,1});
   IP = FieldMap('CreateFieldMap',IP);
   [IP.vdm, IP.vdmP] = FieldMap('FM2VDM',IP);
   IP.epiP = spm_vol(epi{1});
   IP.vdmP = FieldMap('MatchVDM',IP);
   IP.uepiP = FieldMap('UnwarpEPI',IP);
   unwarp_info=sprintf('Unwarped EPI:echo time difference=%2.2fms, EPI readout time=%2.2fms, Jacobian=%d',IP.uflags.etd, IP.tert,IP.ajm);
   IP.uepiP = FieldMap('Write',IP.epiP,IP.uepiP.dat,'u',IP.epiP.dt(1),unwarp_info);
end

end