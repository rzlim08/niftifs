classdef Subject < handle
    properties ( SetAccess = private)
        path = {};
        id = {};
        structural_path = {};
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
        function structural = get_structural_path(obj)
            structural = obj.structural_path;
        end
        function set_structural_path(obj, sp)
            obj.structural_path = sp;
        end
        function last = get_last_folder(obj, str)
            split = strsplit(str, filesep);
            last = split{end};
        end
        
        function set_runs(obj, niftifs)
            obj.runs = [];
            run_dirstruct = strsplit(obj.path_left{:}, filesep);
            run_dirstruct(cellfun(@isempty, run_dirstruct)) = [];
            filepath = {obj.path};
            for i = 1:size(run_dirstruct, 2)
                filepath = niftifs.cartesian(filepath, niftifs.replace_entry(run_dirstruct{i}), 1);
                if(strcmp(run_dirstruct{i},'{runs}')); break; end;
            end
            for i = 1:size(filepath)
                obj.runs = [obj.runs; Run(filepath{i}, obj.get_last_folder(filepath{i}), obj.path_left{:})];
            end
        end
        function set_scans(obj, niftifs)
           if(size(obj.runs)==0)
               obj.runs = [obj.runs; Run(obj.path, obj.id, obj.path_left{:})];
               
           end
           for i = 1:size(obj.runs)
               obj.runs(i).set_scans(niftifs);
           end
           
        end
        
        function bool = eq(obj, other)
            bool = (obj.id == other.id);
        end
        
    end
end