classdef Preprocessor < handle
    properties
        output_dir = '';
        niftifs;
        spm_path = '';
        asc;
        interleaved;
        cache_scans = 0;
    end
    methods
        function obj = Preprocessor(output_dir, niftifs, spm_path)
            % Constructor that takes an output directory, NiftiFS file, and
            % path to the desired SPM
            if nargin <3
                spm_path = fileparts(which('spm'));
            end
            if exist(spm_path, 'dir')
                obj.spm_path = spm_path;
            else
                error('spm_path not found');
            end
            obj.setpath();
            obj.niftifs = niftifs;
            obj.output_dir = output_dir;
        end
        function setpath(obj)
            % Helper function to set the desired path to SPM to the top of
            % the path
            addpath(genpath(obj.spm_path));
        end
        function dir = initialize_spm(obj, task)
            % initialize the SPM functions cd's to the output directory if
            % needed
            if nargin < 2
                task = '';
            end
            dir = pwd;
            setpath(obj);
            spm_jobman('initcfg');
            if strcmp(task, 'realign') || strcmp(task,'coregistration')
                cd(obj.output_dir);
                spm('FnUIsetup','realign' ,1,1);
            end
        end
        function matlabbatch = get_matlabbatch(obj, step)
            % Gets the batch parameters.
            clear('matlabbatch');
            switch(step)
                case 'slice_timing'
                    matlabbatch{1}.spm.temporal.st.scans = {}; % image list
                    matlabbatch{1}.spm.temporal.st.nslices = 0; % number of slices
                    matlabbatch{1}.spm.temporal.st.tr = -1; % TR
                    matlabbatch{1}.spm.temporal.st.ta = -1; % TA
                    matlabbatch{1}.spm.temporal.st.so = -1; % scan order
                    matlabbatch{1}.spm.temporal.st.refslice = -1; % reference slice
                    matlabbatch{1}.spm.temporal.st.prefix = 'a';
                case {'realign','realignment'}
                    matlabbatch{1}.spm.spatial.realign.estwrite.data = {}; % image list
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9; % SPM default parameters unless specified
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
                    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
                    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [0 1]; % mean image only
                    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
                    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
                    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
                    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
                case 'realignunwarp'
                    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = {};
                    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = {};
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9; % SPM default parameters unless specified
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.interp = 2;
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.wrap = [0 0 0];
                    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
                    matlabbatch{1}.spm.spatial.realignunwarp.basfcn = [12,12];
                    matlabbatch{1}.spm.spatial.realignunwarp.regorder = 1;
                    matlabbatch{1}.spm.spatial.realignunwarp.lambda = 100000;
                    matlabbatch{1}.spm.spatial.realignunwarp.jm = 0;
                    matlabbatch{1}.spm.spatial.realignunwarp.fot = [4,5];
                    matlabbatch{1}.spm.spatial.realignunwarp.sot = [];
                    matlabbatch{1}.spm.spatial.realignunwarp.uwfwhm = 4;
                    matlabbatch{1}.spm.spatial.realignunwarp.rem = 1;
                    matlabbatch{1}.spm.spatial.realignunwarp.noi = 5;
                    matlabbatch{1}.spm.spatial.realignunwarp.expround = 'Average';
                case 'coregistration'
                    matlabbatch{1}.spm.spatial.coreg.estimate.ref = {}; % T1 image path
                    matlabbatch{1}.spm.spatial.coreg.estimate.source = {}; % mean image path
                    matlabbatch{1}.spm.spatial.coreg.estimate.other = {}; % functional images paths
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi'; % SPM default parameters
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
                    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
                    
                case 'normalization' %spm 8
                    matlabbatch{1}.spm.spatial.normalise.write.subj.matname = {}; % T1 seg sn
                    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {}; % image list
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve = 0; % default SPM parameters unless specified
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.bb = [-78 -112 -70 % bounding box extended to include cerebellum (-70)
                        78 76 85];
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.vox = [2 2 2]; % Voxel sizes = 2x2x2
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 1;
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'w';
                case 'smoothing'
                    matlabbatch{1}.spm.spatial.smooth.data = {}; % image list
                    matlabbatch{1}.spm.spatial.smooth.fwhm = [6,6,6] ;
                    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
                    matlabbatch{1}.spm.spatial.smooth.im = 0;
                    matlabbatch{1}.spm.spatial.smooth.prefix = 's';
                case 'segmentation'
                    spmfiles = cell(3,1); % creates cell array and next lines insert paths for relevant spm files
                    spmfiles{1} = fullfile(obj.spm_path, 'tpm/grey.nii');
                    spmfiles{2} = fullfile(obj.spm_path, '/tpm/white.nii');
                    spmfiles{3} = fullfile(obj.spm_path, '/tpm/csf.nii');
                    matlabbatch{1}.spm.spatial.preproc.data = {}; % T1 image path
                    matlabbatch{1}.spm.spatial.preproc.output.GM = [0 1 1]; % Grey Matter = Native + Unmodulated Normalized
                    matlabbatch{1}.spm.spatial.preproc.output.WM = [0 1 1]; % White Matter = Native + Unmodulated Normalized
                    matlabbatch{1}.spm.spatial.preproc.output.CSF = [0 1 1]; % CSF = Native + Unmodulated Normalized
                    matlabbatch{1}.spm.spatial.preproc.output.biascor = 1; % SPM default parameters starting here
                    matlabbatch{1}.spm.spatial.preproc.output.cleanup = 0;
                    matlabbatch{1}.spm.spatial.preproc.opts.tpm = spmfiles; % SPM files based on spm directory input
                    matlabbatch{1}.spm.spatial.preproc.opts.ngaus = [2
                        2
                        2
                        4];
                    matlabbatch{1}.spm.spatial.preproc.opts.regtype = 'mni';
                    matlabbatch{1}.spm.spatial.preproc.opts.warpreg = 1;
                    matlabbatch{1}.spm.spatial.preproc.opts.warpco = 25;
                    matlabbatch{1}.spm.spatial.preproc.opts.biasreg = 0.0001;
                    matlabbatch{1}.spm.spatial.preproc.opts.biasfwhm = 60;
                    matlabbatch{1}.spm.spatial.preproc.opts.samp = 3;
                    matlabbatch{1}.spm.spatial.preproc.opts.msk = {''};
                case 'newsegmentation'
                    matlabbatch{1}.spm.spatial.preproc.channel.vols = {};
                    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
                    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
                    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {[ fullfile(obj.spm_path, 'tpm', 'TPM.nii'), ',1']};
                    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
                    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm =  {[ fullfile(obj.spm_path, 'tpm', 'TPM.nii'), ',2']};
                    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
                    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm =  {[ fullfile(obj.spm_path, 'tpm', 'TPM.nii'), ',3']};
                    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
                    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm =  {[ fullfile(obj.spm_path, 'tpm', 'TPM.nii'), ',4']};
                    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
                    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = { [ fullfile(obj.spm_path, 'tpm', 'TPM.nii'), ',5']};
                    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
                    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm =  {[ fullfile(obj.spm_path, 'tpm', 'TPM.nii'), ',6']};
                    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
                    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
                    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
                    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
                    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
                    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
                    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
                    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
                    matlabbatch{1}.spm.spatial.preproc.warp.write = [0 0];
            end
        end
        function vec = get_slice_vector(obj, number_slices, ascending, interleaved)
            % Takes the number of slices as number_slices, and 2 flags to
            % set if the order of slices is ascending or descending, or
            % interleaved.
            % eg. get_slice_vector(obj, 30, 1, 1)
            obj.asc = ascending;
            obj.interleaved = interleaved;
            
            if ~interleaved
                if ascending
                    vec = 1:1:number_slices;
                elseif ~ascending
                    vec = number_slices:-1:1;
                end
            else
                if ascending && mod(number_slices,2)~=0
                    vec = [1:2:number_slices 2:2:number_slices-1];
                elseif ascending && mod(number_slices,2)==0
                    vec = [1:2:number_slices-1 2:2:number_slices];
                elseif ~ascending && mod(number_slices,2)~=0
                    vec = [number_slices:-2:1 number_slices-1:-2:2];
                elseif ~ascending && mod(number_slices,2)==0
                    vec = [number_slices:-2:2 number_slices-1:-2:1];
                end
                
            end
        end
        function run_slice_timing(obj, matlabbatch, TR, slice_vector, ref_slice, subject_array)
            % runs SPM slice timing
            
            % eg. run_slice_timing(obj, obj.get_matlabbatch('slice_timing'), 2,
            %   get_slice_vector(obj, 30, 1, 1), 20,
            %   get_subj_scans(obj.niftifs))
            if nargin < 6
                subject_array = get_subject_array(obj.niftifs);
            end
            number_slices = max(slice_vector);
            TA = TR-(TR/number_slices);
            matlabbatch{1}.spm.temporal.st.scans = {}; % image list
            matlabbatch{1}.spm.temporal.st.nslices = number_slices; % number of slices
            matlabbatch{1}.spm.temporal.st.tr = TR; % TR
            matlabbatch{1}.spm.temporal.st.ta = TA; % TA
            matlabbatch{1}.spm.temporal.st.so = slice_vector; % scan order
            matlabbatch{1}.spm.temporal.st.refslice = ref_slice;
            initialize_spm(obj);
            
            runs = obj.get_runs(subject_array);
            for i=1:size(runs, 1)
                try
                    scans = runs{i}.get_scans;
                    vol = spm_vol(strrep(scans{1,1}, ',1', ''));
                    if size(vol,1)>1
                        vol = vol(1);
                    end
                    if min(vol.dim) ~= max(slice_vector)
                        matlabbatch{1}.spm.temporal.st.nslices = min(vol.dim);
                        matlabbatch{1}.spm.temporal.st.so = obj.get_slice_vector(min(vol.dim), obj.asc, obj.interleaved);
                    end
                    matlabbatch{1}.spm.temporal.st.scans = {runs{i}.get_scans};
                    spm_jobman('run', matlabbatch);
                catch
                    warning(['Run: ' num2str(i) 'has not run']);
                end
            end
        end
        function runs = get_runs(~, x) 

            if isa(x, 'SubjectArray')
                runs = x.get_runs;
            else
                runs = x;
            end
        end
        function run_realignment(obj, matlabbatch, subjects)
            % run SPM realignment
            
            % eg. run_realignment(obj, obj.get_matlabbatch('realign'), subjs)
            if nargin < 3
                subjects = get_subject_array(obj.niftifs);
            end
            current_dir = obj.initialize_spm('realign');
            runs = obj.get_runs(subjects);
            for i=1:size(runs, 1)
                scans = runs{i}.get_scans;
                matlabbatch{1}.spm.spatial.realign.estwrite.data = {scans};
                try
                    spm_jobman('run', matlabbatch);
                catch
                    warning(['Run at: ' runs{i}.path 'has not run']);
                end
            end
            psfile = dir([pwd filesep 'spm_*20*.ps']);
            if size(psfile,1) ==1
                movefile(psfile.name, ['realignment_' date '.ps']);
            end
            cd(current_dir);
        end
        function run_realignment_unwarp(obj, matlabbatch, subjects)
            % run SPM realign and unwarp
            
            % eg. run_realignment_unwarp(obj,
            %   obj.get_matlabbatch('realignunwarp'), PhaseMap_struct, subjs)
            if nargin < 3
                subjects = get_subject_array(obj.niftifs);
            end
            current_dir = initialize_spm(obj, 'realign');
            subjects = obj.get_runs(subjects);
            for i = 1:size(subjects, 1)
                PM_file = subjects{i}.get_associated_matrix('phase_map');
                runs = subjects{i}.get_runs;
                for j = 1:size(runs, 1)
                    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = runs(j).get_scans;
                    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = {PM_file};
                    spm_jobman('run', matlabbatch);
                end
            end
            psfile = dir([pwd filesep 'spm_*20*.ps']);
            if size(psfile,1) ==1
                movefile(psfile.name, ['realignunwarp_' date '.ps']);
            end
            cd(current_dir);
        end
        function run_segmentation(obj, matlabbatch, subjects)
            if nargin < 3
                subjects = get_subject_array(obj.niftifs);
            end
            subjects = obj.get_runs(subjects);
            for i = 1:size(subjects,1)
                try
                    matlabbatch{1}.spm.spatial.preproc.data = {subjects{i}.get_structural_path};
                    spm_jobman('run', matlabbatch);
                catch
                    warning(['subject ' subjects{i}.get_id 'has not run']);
                end
                
            end
        end
        function run_newsegmentation(obj, matlabbatch, subjects)
            if nargin < 3
                subjects = get_subject_array(obj.niftifs);
            end
            subjects = obj.get_runs(subjects);
            for i = 1:size(subjects,1)
                try
                    matlabbatch{1}.spm.spatial.preproc.channel.vols = {subjects{i}.get_structural_path};
                    spm_jobman('run', matlabbatch);
                catch
                    warning(['subject ' subjects{i}.get_id 'has not run']);
                end
                
            end
        end
        
        function mean_image = get_mean_image(obj, scan, directory)
            scan_folder = fileparts(scan{1,1});
            mean_image = directory.expand_folders([strsplit(scan_folder, filesep), 'mean*']);
            a = 2;
            % If mean image is not matched
            if isempty(mean_image)
                while isempty(mean_image) && directory.scan_strmatch(a) ~= '*'
                    mean_image = directory.expand_folders([strsplit(scan_folder, filesep), ['mean', directory.scan_strmatch(a:end)]]);
                    a = a+1;
                end
                mean_image = directory.expand_folders([strsplit(scan_folder, filesep), ['mean', directory.scan_strmatch(a:end)]]);
            end
            
        end
        function run_coregistration(obj, matlabbatch, subject_array)
            % run SPM coregistration
            
            % eg. run_coregistration(obj, obj.get_matlabbatch('coregistration'),
            %   get_subj_scans(obj.niftifs)
            if nargin < 3
                subject_array = get_subject_array(obj.niftifs);
            end
            current_dir = initialize_spm(obj, 'coregistration');
            subjects = obj.get_runs(subject_array);
            for i = 1:size(subjects,1)
                structural_scan = {subjects{i}.get_structural_path};
                if(isempty(structural_scan))
                    warning(['subject ' subjects{i}.get_id 'has no structural scan']);
                    continue;
                end
                runs = subjects{i}.get_runs;
                for j = 1:size(runs, 1)
                    try
                        mean_image = get_mean_image(obj, runs(j).get_scans, obj.niftifs.functional_directory);
                        matlabbatch{1}.spm.spatial.coreg.estimate.ref = structural_scan; % T1 image path
                        matlabbatch{1}.spm.spatial.coreg.estimate.source = mean_image; % mean image path
                        matlabbatch{1}.spm.spatial.coreg.estimate.other = runs(j).get_scans; % functional images paths
                        spm_jobman('run', matlabbatch);
                    catch
                        warning(['subject ' subjects{i}.get_id ' has not run']);
                    end
                end
            end
            psfile = dir([pwd filesep 'spm_*20*.ps']);
            if size(psfile,1) ==1
                movefile(psfile.name, ['coregistration_' date '.ps']);
            end
            cd(current_dir);
        end
        function run_normalization(obj, matlabbatch, subjects)
            % run SPM normalization
            
            % eg. run_normalization(obj,
            %   obj.get_matlabbatch('normalization'), subjs)
            if nargin < 3
                subjects = get_subject_array(obj.niftifs);
            end
            initialize_spm(obj)
            subjects = obj.get_runs(subjects);
            for i = 1:size(subjects, 1)
                structural_scan = subjects{i}.get_structural_path;
                if(isempty(structural_scan))
                    warning(['subject ' subjects{i}.get_id 'has no structural scan']);
                    continue;
                end
                structural_folder = fileparts(structural_scan);
                seg_sn_file = obj.niftifs.functional_directory.expand_folders([strsplit(structural_folder, filesep), '*seg_sn.mat']);
                matlabbatch{1}.spm.spatial.normalise.write.subj.matname = seg_sn_file;
                runs = subjects{i}.get_runs;
                for j = 1:size(runs, 1)
                    try
                        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = runs(j).get_scans;
                        spm_jobman('run', matlabbatch);
                    catch
                        warning(['subject ' subjects{i}.get_id 'has not run']);
                    end
                end
            end
        end
        
        function run_smoothing(obj, matlabbatch, subjects)
            % run SPM smoothing
            % run_smoothing(obj, obj.get_matlabbatch('smoothing'), subjs)
            if nargin < 3
                subjects = get_subject_array(obj.niftifs);
            end
            initialize_spm(obj);
            runs = obj.get_runs(subjects);
            for i = 1:size(runs, 1)
                matlabbatch{1}.spm.spatial.smooth.data = runs{i}.get_scans;
                spm_jobman('run', matlabbatch);
                
            end
        end
    end
end
