classdef NiftiFS < handle & matlab.mixin.Copyable
    properties ( SetAccess = private)
        functional_directory;
        structural_directory;
        subject_array = SubjectArray();
        groups
        top_level
        old_functionals = {};
        structural_scans = {};
        is4D = 0;
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
            obj.functional_directory  = Directory(top_level_dir);
            obj.structural_directory  = Directory(top_level_dir);
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
        set_is4D(obj, flag);
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
        %% Clear and Remove properties
        clear_subjects(obj);
        clear_runs(obj);
        clear_groups(obj);
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
        %% Methods
        new_obj = move_functionals(obj, new_dir, subjs);
        s = summary(obj);
        saveas(obj, filename);
    end
end
