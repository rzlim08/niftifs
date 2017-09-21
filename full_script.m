
for i =52:size(subjs,2)
   not_empty =  ~cellfun(@isempty, subjs(i).subject_runs(:,2));
   runs = subjs(i).subject_runs(not_empty, :); 
   disp(['Running subject ' num2str(i)]);
   % run slice timing
   parfor j = 1:size(runs,1)
      run_slice_timing(runs{j,2}); 
   end
end
reset_scan_strmatch(spt, 'ag*.nii');
subjs = get_subj_scans(spt);

clear matlabbatch
load('matlab_batch.mat');
for i =1:size(subjs,2)
   not_empty =  ~cellfun(@isempty, subjs(i).subject_runs(:,2));
   runs = subjs(i).subject_runs(not_empty, :); 
   disp(['Running subject ' num2str(i)]);
   path = strsplit(subjs(i).subject_scans{1,1}, filesep);
   vdm_file = spt.expand_folders([path(1:7) 'Local*' 'B0*' 'vdm5_sc*.nii']);
   if strcmp(vdm_file{1,1}, 'vdm5_sc*.nii')
      disp(['Subject ' num2str(i) ' has no vdm file!']);
      vdm_file = [];
   end
   %% run realign and unwarp
   for j = 1:size(runs,1)
      matlabbatch{1,1}.spm.spatial.realignunwarp.data.scans = [];
      matlabbatch{1,1}.spm.spatial.realignunwarp.data.pmscan = [];
      matlabbatch{1,1}.spm.spatial.realignunwarp.data.scans = runs{j, 2};
      matlabbatch{1,1}.spm.spatial.realignunwarp.data.pmscan = vdm_file;
      spm_jobman('run', matlabbatch);
   end
    disp(['Done subject ' num2str(i)]);
end
reset_scan_strmatch(spt, 'uag*.nii');
subjs = get_subj_scans(spt);

clear matlabbatch
load('co_reg_batch.mat');
for i =1:size(subjs,2)
    not_empty =  ~cellfun(@isempty, subjs(i).subject_runs(:,2));
    runs = subjs(i).subject_runs(not_empty, :);
    disp(['Running subject ' num2str(i)]);
    
    s = structural(i);
    
    %% run realign and unwarp
    for j = 1:size(runs,1)
        fold = fileparts(runs{j,2}{1,1});
        mean_image = spt.expand_folders([strsplit(fold, filesep), 'meanua*.nii']);
        matlabbatch{1,1}.spm.spatial.coreg.estimate.ref = s;
        matlabbatch{1,1}.spm.spatial.coreg.estimate.source = mean_image;
        matlabbatch{1,1}.spm.spatial.coreg.estimate.other = runs{j, 2};
        spm_jobman('run', matlabbatch);
        matlabbatch{1,1}.spm.spatial.coreg.estimate.ref = [];
        matlabbatch{1,1}.spm.spatial.coreg.estimate.source = [];
        matlabbatch{1,1}.spm.spatial.coreg.estimate.other = [];
    end
    disp(['Done subject ' num2str(i)]);
end
structural = get_structural_scans(spt);
structural = structural(40);
clear matlabbatch
load('normalize_batch.mat');
for i =1:size(subjs,2)
    not_empty =  ~cellfun(@isempty, subjs(i).subject_runs(:,2));
    runs = subjs(i).subject_runs(not_empty, :);
    disp(['Running subject ' num2str(i)]);
    
    s = spt.expand_folders([strsplit(fileparts(structural{i}), filesep), '*seg_sn.mat']);
    for j = 1:size(runs,1)
        matlabbatch{1}.spm.spatial.normalise.write.subj.matname = s; % T1 seg sn
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = runs{j, 2}; % image list
        spm_jobman('run', matlabbatch);
        matlabbatch{1}.spm.spatial.normalise.write.subj.matname = []; % T1 seg sn
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = []; % image list
    end
    
end
clear matlabbatch;
load('smooth_batch.mat');
set_scan_strmatch(spt, 'wuag*.nii');
get_functional_scans(spt);
subjs = spt.get_subj_scans;
for i =1:size(subjs,2)
    not_empty =  ~cellfun(@isempty, subjs(i).subject_runs(:,2));
    runs = subjs(i).subject_runs(not_empty, :);
    disp(['Running subject ' num2str(i)]);
    for j = 1:size(runs,1)
        matlabbatch{1}.spm.spatial.smooth.data = runs{j, 2}; % image list
        spm_jobman('run', matlabbatch);
    end
    
end
