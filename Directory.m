classdef Directory < handle
    %Directory Summary of this class goes here
    %   Detailed explanation goes here
    
    properties( SetAccess = private)
        top_level = ''
        dirstruct = ''
        subject_strmatch = '*'
        run_strmatch = '*'
        scan_strmatch = '*'
        group_strmatch = '*'
        structural_strmatch = '*'
    end
    
    methods
        function obj = Directory(top_level)
            obj.top_level = top_level;
        end
        function set_dirstruct( obj, dirstruct )
            % takes a string that describes the directory structure to the
            % functional scans. A directory structure consists of a file
            % path string, with special folders (eg. subjects, runs) in
            % curly braces eg. {subjects}. Each dirstruct must start with
            % {top_level}.
            if nargin <2
                obj.dirstruct = '{top_level}/{subjects}/{scans}';
                warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
            else
                obj.dirstruct = dirstruct;
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
        function subjects = set_subjects(obj)
            % sets the 'subjects' variable to the folders that match the
            % subject_strmatch in the position as given by the dirstruct
            ndir = strsplit(obj.dirstruct, [filesep '{subjects}' filesep]);
            subjects =  expand_folders(obj, [strsplit(ndir{1}, filesep) '{subjects}']);
        end
        function structurals = get_structurals(obj)
            structural_dirstruct = obj.dirstruct;
            if structural_dirstruct(end) == filesep
                structural_dirstruct = structural_dirstruct(1:end-1);
            end
            structurals = expand_folders(obj, strsplit(structural_dirstruct, filesep));
        end
        function last = get_last_folder(str)
            split = strsplit(str, filesep);
            last = split{end};
        end
        function dirstruct = get_dirstruct(obj)
            dirstruct = obj.dirstruct;
        end
        
        function filepath = expand_folders(obj, cellpath)
            % takes a dirstruct split by folder and returns the list of
            % directories at the end. Expands based on strmatches and
            % wildcard(*) selections
            
            filepath = cell([0, 1]);
            for i = 1:size(cellpath, 2)
                only_dir = (i ~= size(cellpath,2)) && ~isempty(cellpath{1,size(cellpath,2)});
                entry = obj.replace_entry(cellpath{i});
                filepath = obj.cartesian(filepath, entry, only_dir ||  ...
                    any(strcmp(cellpath{i}, {'{subjects}';'{runs}';'{groups}'})));
                
            end
            if strcmp(filepath, '*'); filepath = {}; end
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
                    entry = {obj.scan_strmatch};
                otherwise
                    entry = {entry};
            end
        end
    end
    
end

