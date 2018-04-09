function create_vdm_subjects(fs, path_to_subjs)
IP = FieldMap('Initialise');
%% VDM params
IP.et{1} = 10;
IP.et{2} = 14.06;
IP.maskbrain = 1;
IP.blipdir = 1;
IP.tert = 44.54;

for i = 3:size(path_to_subjs)
   [IP.vdm, IP.vdmP, IP.epiP, IP.vdmP, IP.uepiP, IP.fm, IP.fmagP] = deal([]); 
   subject = path_to_subjs{i};
   subj = subject.path;
   runs = subject.get_runs;
   scans = runs(1).get_scans;
   phase = expand_folders(fs.functional_directory, [strsplit(subj, filesep), 'Localizer*', 'B0*', '*1.nii']);
   magnitude = expand_folders(fs.functional_directory, [strsplit(subj, filesep), 'Localizer*', 'B0*', '*2.nii']);
   epi = scans;
   sc = FieldMap('scale', phase{1,1});
   IP.P{1} = sc;
   IP.P{2} = spm_vol(magnitude{1,1});
   [IP.fm, IP.fmagP] = FieldMap('CreateFieldMap',IP);
   [IP.vdm, IP.vdmP] = FieldMap('FM2VDM',IP);
   IP.epiP = spm_vol(epi{1});
   IP.vdmP = FieldMap('MatchVDM',IP);
   IP.uepiP = FieldMap('UnwarpEPI',IP);
   unwarp_info=sprintf('Unwarped EPI:echo time difference=%2.2fms, EPI readout time=%2.2fms, Jacobian=%d',IP.uflags.etd, IP.tert,IP.ajm);
   IP.uepiP = FieldMap('Write',IP.epiP,IP.uepiP.dat,'u',IP.epiP.dt(1),unwarp_info);
end

end