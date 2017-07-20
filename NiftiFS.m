classdef NiftiFS < handle
    properties ( SetAccess = private)
        functional_dirstruct = ''
        structural_dirstruct = ''
        subject_strmatch = '*'
        path_to_subjects = {}
        path_to_runs = {}
        run_strmatch = '*'
        scan_strmatch = '*'
        group_strmatch = '*'
        subjects
        runs
        groups
        top_level
        is_nii = 0
        art_slice_prefix = 'g'
        art_slice = 0
        slice_timing_prefix = 'a'
        slice_timing = 0
        normalization_prefix = 'w'
        normalization = 0
        smoothing_prefix = 's'
        smoothing = 0
        
    end
    methods
        
        %% Constructor
        function obj = NiftiFS(top_level_dir)
            if nargin ~= 1
                error('A NiftiFS must take as a parameter, a top level directory which contains all Functional scans');
            end
            obj.top_level = top_level_dir;
        end
        
        %% Set properties
        function set_functional_dirstruct(obj,dirstruct)
            if nargin <2
                obj.functional_dirstruct = '{top_level}/{subjects}/{scans}';
                warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
            else
                obj.functional_dirstruct = lower(dirstruct);
                
            end
        end
        function set_structural_dirstruct(obj,dirstruct)
            if nargin <2
                obj.structural_dirstruct = '{top_level}/{subjects}/{scans}';
                warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
            else
                obj.structural_dirstruct = lower(dirstruct);
            end
        end
        function set_subject_strmatch(obj, strmatch)
            obj.subject_strmatch = strmatch;
        end
        function set_run_strmatch(obj, strmatch)
            obj.run_strmatch = strmatch;
        end
        function set_scan_strmatch(obj, strmatch)
            obj.scan_strmatch = strmatch;
        end
        function set_group_strmatch(obj, strmatch)
           obj.group_strmatch = strmatch; 
        end
        function set_subjects(obj)
            ndir = strsplit(obj.functional_dirstruct, '/{subjects}/');
            obj.path_to_subjects = expand_folders(obj, [strsplit(ndir{1}, filesep) '{subjects}']);
            obj.subjects = unique(obj.get_files(obj.path_to_subjects));
        end
        function set_runs(obj)
            if(~obj.run_strmatch)
                obj.runs = cell(0);
                return;
            end
            ndir = strsplit(obj.functional_dirstruct, '/{runs}/');
            obj.path_to_runs = expand_folders(obj, [strsplit(ndir{1}, filesep) '{runs}']);
            obj.runs = unique(obj.get_files(obj.path_to_runs));
        end
        function set_groups(obj)
           if(~obj.group_strmatch)
              obj.groups = cell(0); 
           end
           ndir = strsplit(obj.functional_dirstruct, '/{groups}/');
           path_to_groups = expand_folders(obj, [strsplit(ndir{1}, filesep) '{groups}']);
           obj.groups = unique(obj.get_files(path_to_groups));
        end
        function set_is_nii(obj, flag)
            obj.is_nii = flag;
        end
        
        %% Get properties
        function scans = get_functional_scans(obj)
            scans = expand_folders(obj, strsplit(obj.functional_dirstruct, filesep));
        end
        
        %% Clear properties
        function clear_subjects(obj)
            obj.path_to_subjects = {};
            obj.subjects = {};
            
        end
        function clear_runs(obj)
            obj.path_to_runs = {};
            obj.runs = {};
        end
        
        %% Methods
        function filepath = expand_folders(obj, cellpath)

            filepath = cell([0, 1]);
            for i = 1:size(cellpath, 2)
                if strcmp(cellpath{i}, '{subjects}') && ~isempty(obj.path_to_subjects)
                    filepath = obj.path_to_subjects;
                elseif strcmp(cellpath{i}, '{runs}') && ~isempty(obj.path_to_runs)
                    filepath = obj.path_to_runs;
                else
                    entry = obj.replace_entry(cellpath{i});
                    filepath = obj.cartesian(filepath, entry, i ~= size(cellpath,2));
                end
            end
        end
        function files = get_files(~, full_files)
            files = cell(size(full_files,1),1);
            for i = 1:size(full_files,1)
                split = strsplit(full_files{i}, filesep);
                files{i} = split{end};
            end
        end
        function filecell = cartesian(~, filepath, entry, only_dir)
            filecell = cell(0,1);
            if size(filepath,1)==0
                filecell = entry;
                return
            end
            if size(entry,1)==0
                filecell = filepath;
                return
            end
            for i = 1:size(filepath)
                for j = 1:size(entry)
                    if strfind(entry{j}, '*')
                        dirs = dir([filepath{i} filesep entry{j}]);
                        dirs=dirs(~ismember({dirs.name},{'.','..'}));
                        if only_dir
                            isub = [dirs(:).isdir]; %# returns logical vector
                            dirs = {dirs(isub).name}';
                        else
                            dirs = {dirs.name}';
                        end
                        for k = 1:size(dirs)
                            filecell{end+1, 1} = [filepath{i} filesep dirs{k}];
                        end
                        
                    else
                        filecell{end+1, 1} = [filepath{i} filesep entry{j}];
                    end
                    
                end
            end
        end
        function entry = replace_entry(obj,entry)
            switch entry
                case '{top_level}'
                    entry =  {obj.top_level};
                case '{subjects}'
                    entry = {obj.subject_strmatch};
                case '{runs}'
                    entry = {obj.run_strmatch};
                case '{groups}'
                    entry = {obj.group_strmatch};
                case '{scans}'
                    if ~obj.is_nii && isempty(strfind(obj.scan_strmatch, '.img'));
                        entry = {[obj.scan_strmatch '.img']};
                    elseif obj.is_nii && isempty(strfind(obj.scan_strmatch, '.nii'));
                        entry = {[obj.scan_strmatch '.nii']};
                    end
                otherwise
                    entry = {entry};
            end
        end
        function remove_runs(obj, pattern)
            obj.path_to_runs = ...
                obj.path_to_runs(find(cellfun(@isempty, strfind(obj.path_to_runs, pattern))));
            obj.runs = obj.runs(find(cellfun(@isempty, strfind(obj.runs, pattern))));
        end
        function remove_subjs(obj, pattern)
            obj.path_to_subjects = ...
                obj.path_to_subjects(find(cellfun(@isempty, strfind(obj.path_to_subjects, pattern))));
            obj.subjects = obj.subjects(find(cellfun(@isempty, strfind(obj.subjects, pattern))));
        end
        function rm(obj, patterns)
            for i = 1:size(patterns)
                remove_runs(obj, patterns{i});
                remove_subjs(obj, patterns{i});
            end
        end
        function counts = count_runs(obj)
            counts = cellfun(@(x) sum(~cellfun('isempty', strfind(obj.path_to_runs,x))),obj.subjects);
            counts = [obj.subjects num2cell(counts)];
            
        end
        
        %% Functional Methods
        function ret = feval_cell(~, func, cell_list)
            
           for i = 1:size(cell_list, 1)
              f(i) = parfeval(gcp(), func, 1, cell_list{i});
           end
           ret = cell(size(cell_list));
           for i = 1:size(cell_list, 1)
             [completedIdx,value] = fetchNext(f);
             ret{completedIdx} = value;
           end
        end
        
        function ret = parfor_cell(~, func, cell_list)
            
           parfor i = 1:size(cell_list, 1)
              ret{i} = feval(func, cell_list{i});
           end

        end
        
    end
end
