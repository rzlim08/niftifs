%% Groups, Subjects, and Runs
% fs = NiftiFS(pwd);
% set_functional_dirstruct(fs, '{top_level}/meow/{groups}/{subjects}/{runs}/{scans}');
% set_subject_strmatch(fs, 's*');
% set_subjects(fs);
% set_groups(fs);
% set_runs(fs);
% set_scan_strmatch(fs, 'f*.img');

%% Subjects and Runs
fs = NiftiFS(pwd);
set_functional_dirstruct(fs, '{top_level}/{subjects}/{runs}/{scans}');
set_subject_strmatch(fs, 's*');
set_scan_strmatch(fs, 'f*.img');
set_subjects(fs);
set_runs(fs);

sc = get_subj_scans(fs);
tic;
for i = 1:size(sc, 2)
    batch_parfor(fs, @spm_reslice, sc(i).subject_runs(:, 2));
end
toc;
tic;
for i = 1:size(sc, 2)
    batch_serial(fs, @spm_reslice, sc(1).subject_runs(:, 2));
end
toc;
tic;
for i = 1:size(sc, 2)
    batch_parfeval(fs, @spm_reslice, sc(1).subject_runs(:, 2));
end
toc;
%% No Runs
% fs = NiftiFS(pwd);
% set_functional_dirstruct(fs, '{top_level}/{subjects}/{scans}');
% set_scan_strmatch(fs, 'f*.img')
% set_subjects(fs);
% get_functional_scans(fs);

%% StewartLab
% fs = NiftiFS(pwd);
% set_functional_dirstruct(fs, '{top_level}/{subjects}/Functional/{runs}/{scans}');
% set_subject_strmatch(fs, 'SESOCD*');
% set_run_strmatch(fs, 'fMRI_ToL*');
% set_scan_strmatch(fs, 'g*');
% set_is_nii(fs, 1);
