classdef Subject < handle
    properties ( SetAccess = private)
        path = {};
        id = {};
        structural_path = {};
        associated_matrices = [];
        runs = [];
        path_left = {};
    end
    methods
        function obj = Subject(id, path, dirstruct)
            if nargin<2
                error('A subject needs an id and a path');
            end
            obj.id = id;
            obj.path = path;
            obj.path_left = obj.get_remaining_path(dirstruct);
        end
        function rp = get_remaining_path(~,dirstruct)
            path_cell = strsplit(dirstruct, '{subjects}');
            rp = path_cell(2);
        end
        function path = get_path(obj)
            path = obj.path;
        end
        function id = get_id(obj)
            id = obj.id;
        end
        function id = get_run_id(obj)
            id = {};
            for run =1:length(obj.runs)
                id = [id;[obj.id '_' obj.runs(run).get_name]];
            end
        end
        function remove_run(obj, pattern)
           index = [];
           for run = 1:length(obj.runs)
              if ~isempty(strfind(obj.runs(run).get_name, pattern))
                 index = [index; run];
              end
           end
           obj.runs(index)= [];
        end
        function structural = get_structural_path(obj)
            structural = obj.structural_path;
        end
        function set_structural_path(obj, sp)
            obj.structural_path = sp;
        end
        function last = get_last_folder(~, str)
            split = strsplit(str, filesep);
            last = split{end};
        end
        
        function set_runs(obj, directory, is4D)
            obj.runs = [];
            run_dirstruct = strsplit(obj.path_left{:}, filesep);
            run_dirstruct(cellfun(@isempty, run_dirstruct)) = [];
            filepath = {obj.path};        
            if(~is4D)
                for i = 1:size(run_dirstruct, 2)
                    filepath = directory.cartesian(filepath, directory.replace_entry(run_dirstruct{i}), 1);
                    if(strcmp(run_dirstruct{i},'{runs}')); break; end
                end
                for i = 1:size(filepath)
                    obj.runs = [obj.runs; Run(filepath{i}, obj.get_last_folder(filepath{i}), obj.path_left{:})];
                end
            else
                for i = 1:size(run_dirstruct, 2)
                    filepath = directory.cartesian(filepath, directory.replace_entry(run_dirstruct{i}), 0);
                    if(strcmp(run_dirstruct{i},'{runs}')); break; end
                end
                for i = 1:size(filepath)
                    obj.runs = [obj.runs; RunScan(filepath{i}, obj.get_last_folder(filepath{i}), obj.path_left{:})];
                end
            end
        end
        function runs = get_runs(obj)
            runs = obj.runs;
        end
        function runs = get_run_cell(obj)
            runs = cell(size(obj.runs,1), 1);
            for i = 1:size(obj.runs)
               runs{i} = obj.runs(i);
           end
        end
        function set_scans(obj, directory)
            if(size(obj.runs)==0)
                obj.runs = [obj.runs; Run(obj.path, obj.id, obj.path_left{:})];
                
            end
            for i = 1:size(obj.runs)
                obj.runs(i).set_scans(directory);
            end
            
        end
        function add_associated_matrix(obj, name, data)
            obj.associated_matrices.(name) = data;
        end
        function mat = get_associated_matrix(obj, name)
            mat = obj.associated_matrices.(name);
        end
        function cache(obj, path_to_remote, temp_path)
            
           for i = 1:size(obj.runs)
              
             obj.runs(i).cache(path_to_remote, temp_path); 
               
           end
        end
        function bool = eq(obj, other)
            bool = (obj.id == other.id);
        end
        
    end
end