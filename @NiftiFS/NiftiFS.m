classdef NiftiFS < handle & matlab.mixin.Copyable
    properties ( SetAccess = private)
        functional_dirstruct = ''
        structural_dirstruct = ''
        subject_strmatch = '*'
        path_to_subjects = {}
        path_to_runs = {}
        run_strmatch = '*'
        scan_strmatch = '*'
        group_strmatch = '*'
        structural_strmatch = '*'
        subjects
        runs
        groups
        top_level
        functional_scans
        old_functionals = {};
        structural_scans
        is_nii = 0
        art_slice_prefix = 'g'
        art_slice = 0
        slice_timing_prefix = 'a'
        slice_timing = 0
        normalization_prefix = 'w'
        normalization = 0
        smoothing_prefix = 's'
        smoothing = 0
        unwarping_prefix = 'u'
        unwarping = 0
        realignment_prefix = 'r'
        realignment = 0
        
        rm_list = struct('rm_runs',[], 'rm_subjects', [])
    end
    methods
        
        %% Constructor
        
        % Takes the folder that encompasses all functional scans.
        % Structural scans are able to exist in a separate folder
        function obj = NiftiFS(top_level_dir)
            if nargin ~= 1
                error(['A NiftiFS must take as a parameter, a top level directory' ...
                    'which contains all Functional scans']);
            end
            obj.top_level = top_level_dir;
        end
        
        %% Set properties
        set_functional_dirstruct(obj,dirstruct);
        set_structural_dirstruct(obj,dirstruct);
        set_subject_strmatch(obj, strmatch);
        set_run_strmatch(obj, strmatch);
        set_scan_strmatch(obj, strmatch);
        set_group_strmatch(obj, strmatch);
        set_structural_strmatch(obj, strmatch);
        set_subjects(obj);
        set_runs(obj);
        set_groups(obj);
        set_is_nii(obj, flag);
        reset_scan_strmatch(obj, strmatch);
        reset_top_level(obj, path);
        set_functional_scans(obj);
        
        %% Get properties
        scans = get_functional_scans(obj);
        scans = get_structural_scans(obj);
        subj_struct = get_subj_scans(obj);
        subj_struct = get_random_subj(obj, number);     
        
        %% Clear properties
        clear_subjects(obj);
        clear_runs(obj);
        clear_groups(obj);
        
        %% Methods
        filepath = expand_folders(obj, cellpath);
        files = get_files(~, full_files);
        new_obj = move_functionals(obj, new_dir, subjs);
        filecell = cartesian(~, filepath, entry, only_dir);
        output = replace_entry(obj,entry);
        remove_runs(obj, pattern);
        remove_subjs(obj, pattern);
        rm(obj, patterns);
        counts = count_runs(obj);
        ran_art_slice(obj);
        ran_slice_timing(obj);
        ran_normalization(obj);
        ran_smoothing(obj);
        ran_unwarping(obj);
        undo(obj, num);
        saveas(obj, filename);
        
        %% Function Methods
        % function methods are just little layers that run functions on
        % cell lists easily.
        %They're roughly divided into:
        % 1. each cell evaluators (parfeval_cell, parfor_cell) which take
        % the form parfeval_cell(obj, @spm_vol, cell_list_path_to_scans);
        % this type of function reads the header for each scan
        % 2. batch cell evaluators (batch_parfor, batch_serial,
        % batch_parfeval)
        %eg. (batch_parfor(obj, @spm_reslice, cell_list_path_to_scans)
        
        output = parfeval_cell(~, func, cell_list);
        output = parfor_cell(~, func, cell_list);
        output = batch_parfor(obj,  func, cell_list);
        output = batch_serial(obj,  func, cell_list);
        output = batch_parfeval(obj, func, cell_list);
        
    end
end
