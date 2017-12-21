classdef NiftiFS < handle & matlab.mixin.Copyable
    properties ( SetAccess = private)
        functional_dirstruct = ''
        structural_dirstruct = ''
        subject_strmatch = '*'
        run_strmatch = '*'
        scan_strmatch = '*'
        group_strmatch = '*'
        structural_strmatch = '*'
        subject_array = SubjectArray();
        groups
        top_level
        old_functionals = {};
        structural_scans = {};
        is_nii = 0
        is_4D = 0;
        is_custom_suffix = 0;
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
        
        rm_list = struct('rm_runs',[], 'rm_subjects', [], 'rm_structurals', [])
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
        function set_is4D(obj, flag)
           obj.is_4D = flag; 
        end
        set_custom_suffix(obj, flag);
        reset_scan_strmatch(obj, strmatch);
        reset_top_level(obj, path);
        set_functional_scans(obj);
        set_structural_scans(obj);
        %% Get properties
        function subject_array = get_subject_array(obj) 
           subject_array = obj.subject_array; 
        end
        scans = get_functional_scans(obj);
        scans = get_structural_scans(obj);
        subj_struct = get_subj_scans(obj);
        subj_struct = get_random_subj(obj, number);
        
        flag = get_is4D(obj);
        %% Clear properties
        clear_subjects(obj);
        clear_runs(obj);
        clear_groups(obj);
        
        %% Methods
        filepath = expand_folders(obj, cellpath);
        filepath = expand_folders_structural(obj, cellpath);
        files = get_files(~, full_files);
        new_obj = move_functionals(obj, new_dir, subjs);
        filecell = cartesian(~, filepath, entry, only_dir);
        output = replace_entry(obj,entry);
        remove_runs(obj, pattern);
        remove_subjs(obj, pattern);
        function remove_structurals(obj, pattern)
            % removes all subjects that match a string, pattern. eg.
            % (remove_structurals(obj, 's01'))
            obj.rm_list.rm_structurals{end+1} = pattern;
            obj.structural_scans = ...
                obj.structural_scans(find(cellfun(@isempty, strfind(obj.structural_scans, pattern))));
        end
        rm(obj, patterns);
        counts = count_runs(obj);
        s = summary(obj);
        undo(obj, num);
        saveas(obj, filename);
        function subj_list = split_subjs(obj, num_to_split)
            subjs = obj.get_subj_scans;
            number_subjs_per_group = floor(size(subjs,1)/(num_to_split-1));
            subj_list = cell(num_to_split,1);
            for i = 1:num_to_split-1
                subj_list{i,1} = subjs((number_subjs_per_group*(i-1)+1):(number_subjs_per_group*(i-1)+number_subjs_per_group));
            end
            subj_list{end} = subjs((number_subjs_per_group*(i)+1): end);
        end
       
    end
end
