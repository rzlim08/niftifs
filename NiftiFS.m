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
        structural_strmatch = '*'
        subjects
        runs
        groups
        top_level
        functional_scans
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
        
    end
    methods
        
        %% Constructor
        
        % Takes the folder that encompasses all functional scans.
        % Structural scans are able to exist in a separate folder
        function obj = NiftiFS(top_level_dir)
            if nargin ~= 1
                error('A NiftiFS must take as a parameter, a top level directory which contains all Functional scans');
            end
            obj.top_level = top_level_dir;
        end
        
        %% Set properties
       
        function set_functional_dirstruct(obj,dirstruct)
            % takes a string that describes the directory structure to the
            % functional scans. A directory structure consists of a file
            % path string, with special folders (eg. subjects, runs) in
            % curly braces eg. {subjects}. Each dirstruct must start with
            % {top_level}. 
            if nargin <2
                obj.functional_dirstruct = '{top_level}/{subjects}/{scans}';
                warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
            else
                obj.functional_dirstruct = dirstruct;
                
            end
        end
        function set_structural_dirstruct(obj,dirstruct)
            % takes a string that describes the directory structure to the
            % structural scans. A directory structure consists of a file
            % path string, with special folders (eg. subjects, runs) in
            % curly braces eg. {subjects}. Each dirstruct must start with
            % {top_level}
            if nargin <2
                obj.structural_dirstruct = '{top_level}/{subjects}/{scans}';
                warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
            else
                obj.structural_dirstruct = dirstruct;
            end
        end
        function set_subject_strmatch(obj, strmatch)
            % sets a string to match for the subject (eg. 'WM*' for WM001, 
            % WM002, etc), can be left as * if all folders in the level are
            % subjects
            obj.subject_strmatch = strmatch;
        end
        function set_run_strmatch(obj, strmatch)
            % see subject strmatch
            obj.run_strmatch = strmatch;
        end
        function set_scan_strmatch(obj, strmatch)
            % see subject strmatch
            obj.scan_strmatch = strmatch;
        end
        function set_group_strmatch(obj, strmatch)
            % see subject strmatch
           obj.group_strmatch = strmatch; 
        end
        function set_structural_strmatch(obj, strmatch)
            % see subject strmatch
            obj.structural_strmatch = strmatch; 
        end
        function set_subjects(obj)
            % sets the 'subjects' variable to the folders that match the
            % subject_strmatch in the position as given by the dirstruct
            ndir = strsplit(obj.functional_dirstruct, '/{subjects}/');
            obj.path_to_subjects = expand_folders(obj, [strsplit(ndir{1}, filesep) '{subjects}']);
            obj.subjects = unique(obj.get_files(obj.path_to_subjects));
        end
        function set_runs(obj)
            % see set_subjects
            if(~obj.run_strmatch)
                obj.runs = cell(0);
                return;
            end
            ndir = strsplit(obj.functional_dirstruct, '/{runs}/');
            obj.path_to_runs = expand_folders(obj, [strsplit(ndir{1}, filesep) '{runs}']);
            obj.runs = unique(obj.get_files(obj.path_to_runs));
        end
        function set_groups(obj)
            % see set_subjects
           if(~obj.group_strmatch)
              obj.groups = cell(0); 
           end
           ndir = strsplit(obj.functional_dirstruct, '/{groups}/');
           path_to_groups = expand_folders(obj, [strsplit(ndir{1}, filesep) '{groups}']);
           obj.groups = unique(obj.get_files(path_to_groups));
        end
        function set_is_nii(obj, flag)
            % if >0 then scans are in .nii format, else, in analyze format
            obj.is_nii = flag;
        end
        
        function reset_scan_strmatch(obj, strmatch)
           obj.set_scan_strmatch(strmatch);
           obj.get_functional_scans;
        end
        
        %% Get properties
        function scans = get_functional_scans(obj)
            % gets all functional scans for all subjects, runs and groups.
            % This can be a bit time consuming if you have a lot of
            % subjects
            scans = expand_folders(obj, strsplit(obj.functional_dirstruct, filesep));
            obj.functional_scans = scans;
        end
        function scans = get_structural_scans(obj)
            % gets all structural scans for all subjects
            scans = expand_folders(obj, strsplit(obj.structural_dirstruct, filesep));
            obj.structural_scans = scans;
        end
        function subject_struct = get_subj_scans(obj)
            % gets scans but structured by subject -> scans, and
            % subject->runs->scans
           if(isempty(obj.subjects))
              error('no subjects');
           end
           if(isempty(obj.functional_scans))
             scans = get_functional_scans(obj);
           else
             scans = obj.functional_scans;
           end
           path = strrep(obj.path_to_subjects, obj.top_level, '');
           subject_struct = struct('name', {}, 'subject_scans', {}, 'subject_runs', {});
           for i=1:size(path, 1)
               subject_struct(i).name = path{i, 1};
               subject_struct(i).subject_scans = scans(~cellfun(@isempty, strfind(scans, path{i,1})));
               if ~isempty(any(~cellfun(@isempty, strfind(obj.path_to_runs, path{i, 1}))))
                   subj_runs = strrep(obj.path_to_runs(~cellfun(@isempty, ...
                       strfind(obj.path_to_runs, path{i, 1}))), ...
                       obj.top_level, '');
                   for j = 1:size(subj_runs)
                       subj_runs{j, 2} = scans(~cellfun(@isempty, strfind(scans, subj_runs{j,1})));
                   end
                   subject_struct(i).subject_runs = subj_runs;
               end
           end
        end
        function subject_struct = get_random_subj(obj, number)
           subject_struct = get_subj_scans(obj);
           vec = randperm(size(subject_struct,2), number);
           subject_struct = subject_struct(1, vec);
        end
        
        
        
        %% Clear properties
        function clear_subjects(obj)
            % clears the subject variables
            obj.path_to_subjects = {};
            obj.subjects = {};
            
        end
        function clear_runs(obj)
            % clears the run variables
            obj.path_to_runs = {};
            obj.runs = {};
        end
        function clear_groups(obj)
            % clears the group variables
            obj.groups = {};
        end
        %% Methods
        function filepath = expand_folders(obj, cellpath)
            % takes a dirstruct split by folder and returns the list of
            % directories at the end. Expands based on strmatches and
            % wildcard(*) selections
            
            filepath = cell([0, 1]);
            for i = 1:size(cellpath, 2)
                only_dir = i ~= size(cellpath,2);
                if strcmp(cellpath{i}, '{subjects}') && ~isempty(obj.path_to_subjects)
                    filepath = obj.path_to_subjects;
                    
                elseif strcmp(cellpath{i}, '{runs}') && ~isempty(obj.path_to_runs)
                    filepath = obj.path_to_runs;
                    
                else
                    entry = obj.replace_entry(cellpath{i});
                    filepath = obj.cartesian(filepath, entry, only_dir ||  ...
                        any(strcmp(cellpath{i}, {'{subjects}';'{runs}';'{groups}'})));
                end
            end
        end
        function files = get_files(~, full_files)
            % given a cell list of filepaths gets the last entry, could be
            % renamed
            files = cell(size(full_files,1),1);
            for i = 1:size(full_files,1)
                split = strsplit(full_files{i}, filesep);
                files{i} = split{end};
            end
        end
        function filecell = cartesian(~, filepath, entry, only_dir)
            % named as such because it gets the cartesian product between
            % the filepath and the values returned by entry. filepath is a
            % cell list of paths, entry is the name of a folder, file, or
            % wildcard, and only_dir is a flag which if set filters out
            % non-directory entries. Could be renamed. 
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
            % replaces the value in a path with an appropriate matcher 
            switch lower(entry)
                case '{top_level}'
                    entry =  {obj.top_level};
                case '{subjects}'
                    entry = {obj.subject_strmatch};
                case '{runs}'
                    entry = {obj.run_strmatch};
                case '{groups}'
                    entry = {obj.group_strmatch};
                case '{structs}' 
                    entry = {obj.structural_strmatch};
                case '{structurals}'
                    entry = {obj.structural_strmatch};
                case '{scans}'
                    if ~obj.is_nii && isempty(strfind(obj.scan_strmatch, '.img'))
                        entry = {[obj.scan_strmatch '.img']};
                    elseif obj.is_nii && isempty(strfind(obj.scan_strmatch, '.nii'))
                        entry = {[obj.scan_strmatch '.nii']};
                    else 
                        entry = {obj.scan_strmatch};
                    end
                otherwise
                    entry = {entry};
            end
        end
        function remove_runs(obj, pattern)
            % removes all runs that match a string, pattern. eg.
            % (remove_runs(obj, 'run01');
            obj.path_to_runs = ...
                obj.path_to_runs(find(cellfun(@isempty, strfind(obj.path_to_runs, pattern))));
            obj.runs = obj.runs(find(cellfun(@isempty, strfind(obj.runs, pattern))));
        end
        function remove_subjs(obj, pattern)
            % removes all subjects that match a string, pattern. eg.
            % (remove_subjs(obj, 's01'))
            obj.path_to_subjects = ...
                obj.path_to_subjects(find(cellfun(@isempty, strfind(obj.path_to_subjects, pattern))));
            obj.subjects = obj.subjects(find(cellfun(@isempty, strfind(obj.subjects, pattern))));
        end
        function rm(obj, patterns)
            % takes a cell list of patterns, and removes each one. eg.
            % (rm(obj, {'run01';'s01'}))
            for i = 1:size(patterns)
                remove_runs(obj, patterns{i});
                remove_subjs(obj, patterns{i});
            end
        end
        function counts = count_runs(obj)
            % if subjects contain runs, counts the number of runs for a
            % given subject
            
            counts = cellfun(@(x) sum(~cellfun('isempty', strfind(obj.path_to_runs,x))),obj.subjects);
            counts = [obj.subjects num2cell(counts)];
            
        end
        function saveas(obj, filename)
           n = inputname(1);
           eval([n '= obj']);
           save([pwd filesep filename '.mat'], n); 
        end
        %% Functional Methods
        
        
        % functional methods are just little layers that run functions on
        % cell lists easily. For more complicated processing, it is
        % recommended to manually build a pipeline. 
        
        
        %They're roughly divided into: 
        % 1. each cell evaluators (parfeval_cell, parfor_cell) which take
        % the form parfeval_cell(obj, @spm_vol, cell_list_path_to_scans);
        % this type of function reads the header for each scan
        
        % 2. batch cell evaluators (batch_parfor, batch_serial,
        % batch_parfeval)
        %eg. (batch_parfor(obj, @spm_reslice, cell_list_path_to_scans)
        function ret = parfeval_cell(~, func, cell_list)

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
              if(nargout(func) ==0)
                  feval(func, cell_list{i});
              else
                  ret{i} = feval(func, cell_list{i});
              end
           end

        end
        function ret = batch_parfor(obj,  func, cell_list)
           tl =  '';
           parfor i = 1:size(cell_list, 1)
              cl = cellfun(@(x)[tl x], cell_list{i}, 'uni', false);
              if(nargout(func) ==0)
                feval(func, char(cl));
              else
                 ret{i} = feval(func, char(cl));
              end
           end
        end
        function ret = batch_serial(obj,  func, cell_list)
           tl =  '';
           for i = 1:size(cell_list, 1)
              cl = cellfun(@(x)[tl x], cell_list{i}, 'uni', false);
              if(nargout(func) ==0)
                feval(func, char(cl));
              else
                ret{i} = feval(func, char(cl));
              end
           end
        end
        function ret = batch_parfeval(obj,  func, cell_list)
           tl =  '';
           for i = 1:size(cell_list, 1)
              cl = cellfun(@(x)[tl x], cell_list{i}, 'uni', false);
              f(i) = parfeval(gcp(), func, 1, char(cl));
           end
           for i = 1:size(cell_list, 1)
             if(nargout(func)==0)
                 fetchNext(f);
             else
             [completedIdx,value] = fetchNext(f);
             ret{completedIdx} = value;
             end
           end
        end
        
    end
end
