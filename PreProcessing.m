classdef PreProcessing < handle
    properties
        output_dir = '';
        niftifs;
        spm_path = '';
        
    end
    methods
        function obj = PreProcessing(output_dir, niftifs, spm_path)
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
                    matlabbatch{1}.spm.temporal.st.prefix = obj.niftifs.slice_timing_prefix;
                case 'realign'
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
                    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = obj.niftifs.realignment_prefix;
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
                    matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = obj.niftifs.normalization_prefix;
                case 'smoothing'
                    matlabbatch{1}.spm.spatial.smooth.data = {}; % image list
                    matlabbatch{1}.spm.spatial.smooth.fwhm = [0,0,0] ;
                    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
                    matlabbatch{1}.spm.spatial.smooth.im = 0;
                    matlabbatch{1}.spm.spatial.smooth.prefix = obj.niftifs.smoothing_prefix;
                case 'segmentation'
                    spmfiles = cell(3,1); % creates cell array and next lines insert paths for relevant spm files
                    spmfiles{1} = fullfile(obj.spm_path, '/tpm/grey.nii');
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
            end
        end
        function vec = get_slice_vector(~, number_slices, ascending, interleaved)
            % Takes the number of slices as number_slices, and 2 flags to
            % set if the order of slices is ascending or descending, or
            % interleaved. 
            
            % eg. get_slice_vector(obj, 30, 1, 1)
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
        function run_slice_timing(obj, matlabbatch, TR, slice_vector, ref_slice, subjects)
            % runs SPM slice timing
            
            % eg. run_slice_timing(obj, obj.get_matlabbatch('slice_timing'), 2,
            %   get_slice_vector(obj, 30, 1, 1), 20,
            %   get_subj_scans(obj.niftifs))
            if nargin < 6
                subjects = get_subj_scans(obj.niftifs);
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
            for i=1:size(subjects, 1)
                for j =1:size(subjects(i).subject_runs, 1)
                    matlabbatch{1}.spm.temporal.st.scans = {subjects(i).subject_runs{j, 2}};
                    spm_jobman('run', matlabbatch);
                end
            end
        end
        
        function run_realignment(obj, matlabbatch, subjects)
            % run SPM realignment
            
            % eg. run_realignment(obj, obj.get_matlabbatch('realign'), subjs)
            if nargin < 3
                subjects = get_subj_scans(obj.niftifs);
            end
            current_dir = initialize_spm('realign');
            for i = 1:size(subjects, 1)
                for j = 1:size(subjects(i).subject_runs, 1)
                    matlabbatch{1}.spm.spatial.realign.estwrite.data = {subjects(i).subject_runs{j, 2}};
                    spm_jobman('run', matlabbatch);
                end
            end
            psfile = dir([pwd filesep 'spm_*20*.ps']);
            if size(psfile,1) ==1
                movefile(psfile.name, ['realignment_' date '.ps']);
            end
            cd(current_dir);
        end
        function run_realignment_unwarp(obj, matlabbatch, PM_files, subjects)
            % run SPM realign and unwarp
            
            % eg. run_realignment_unwarp(obj,
            %   obj.get_matlabbatch('realignunwarp'), PhaseMap_struct, subjs)
            if nargin < 3
                subjects = get_subj_scans(obj.niftifs);
            end
            current_dir = initialize_spm(obj, 'realign');
            for i = 1:size(subjects, 1)
                PM_file = PM_files(i);
                for j = 1:size(subjects(i).subject_runs, 1)
                    matlabbatch{1}.spm.spatial.realignunwarp.data.scans = subjects(i).subject_runs{j, 2};
                    matlabbatch{1}.spm.spatial.realignunwarp.data.pmscan = PM_file;
                    spm_jobman('run', matlabbatch);
                end
            end
            cd(current_dir);
        end
        function run_coregistration(obj, matlabbatch, subjects)
            % run SPM coregistration
            
            % eg. run_coregistration(obj, obj.get_matlabbatch('coregistration'),
            %   get_subj_scans(obj.niftifs)
            if nargin < 3
                subjects = get_subj_scans(obj.niftifs);
            end
            current_dir = initialize_spm(obj, 'coregistration');
            structurals = get_structural_scans(obj.niftifs);
            
            for i = 1:size(subjects,1)
                structural_scan = structurals(~cellfun(@isempty, strfind(structurals, subjects(i).name)));
                for j = 1:size(subjects(i).subject_runs, 1)
                    scan_folder = fileparts(subjects(i).subject_runs{j,2}{1,1});
                    mean_image = obj.niftifs.expand_folders([strsplit(scan_folder, filesep), ['mean', obj.niftifs.scan_strmatch]]);
                    a = 2;
                    % If mean image is not matched
                    while isempty(mean_image) && obj.niftifs.scan_strmatch(a) ~= '*'
                        mean_image = obj.niftifs.expand_folders([strsplit(scan_folder, filesep), ['mean', obj.niftifs.scan_strmatch(a:end)]]);
                        a = a+1;
                    end
                    mean_image = obj.niftifs.expand_folders([strsplit(scan_folder, filesep), ['mean', obj.niftifs.scan_strmatch(a:end)]]);
                    matlabbatch{1}.spm.spatial.coreg.estimate.ref = structural_scan; % T1 image path
                    matlabbatch{1}.spm.spatial.coreg.estimate.source = mean_image; % mean image path
                    matlabbatch{1}.spm.spatial.coreg.estimate.other = subjects(i).subject_runs{j, 2}; % functional images paths
                    spm_jobman('run', matlabbatch);
                end
            end
            cd(current_dir);
        end
        function run_normalization(obj, matlabbatch, subjects)
            % run SPM normalization
            
            % eg. run_normalization(obj,
            %   obj.get_matlabbatch('normalization'), subjs)
            if nargin < 3
                subjects = get_subj_scans(obj.niftifs);
            end
            initialize_spm(obj)
            structurals = get_structural_scans(obj.niftifs);
            if size(structurals, 1) ~= size(subjects,1)
                warning('There is not a single structural scan per member');
            end
            for i = 1:size(subjects, 1)
                structural_scan = structurals(~cellfun(@isempty, strfind(structurals, subjects(i).name)));
                structural_folder = fileparts(structural_scan{1,1});
                seg_sn_file = obj.niftifs.expand_folders([strsplit(structural_folder, filesep), '*seg_sn.mat']);
                
                for j = 1:size(subjects(i).subject_runs, 1)
                    matlabbatch{1}.spm.spatial.normalise.write.subj.matname = seg_sn_file;
                    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = subjects(i).subject_runs{j, 2};
                    spm_jobman('run', matlabbatch);
                end
            end
        end
        
        function run_smoothing(obj, matlabbatch, subjects)
            % run SPM smoothign
            
            % run_smoothing(obj, obj.get_matlabbatch('smoothing'), subjs)
            if nargin < 3
                subjects = get_subj_scans(obj.niftifs);
            end
            initialize_spm(obj);
            for i = 1:size(subjects, 1)
                for j = 1:size(subjects(i).subject_runs, 1)
                    matlabbatch{1}.spm.spatial.smooth.data = subjects(i).subject_runs{j, 2};
                    spm_jobman('run', matlabbatch);
                end
            end
        end
    end
end