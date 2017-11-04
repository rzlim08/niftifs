classdef Run < handle
    properties ( SetAccess = private)
        path = {};
        name = {};
        scans = [];
        path_left;
    end
    methods
        function obj = Run(path, name, path_left)
            if nargin<2
                error('A run needs a name and a path');
            end
            obj.name = name;
            obj.path = path;
            obj.path_left = obj.get_remaining_path(path_left);
        end
        function path = get_path(obj)
            path = obj.path;
        end
        function set_path(obj, path)
            obj.path = path;
        end
        function name = get_name(obj)
            name = obj.name;
        end
        function rp = get_remaining_path(~,dirstruct)
            path_cell = strsplit(dirstruct, '{runs}');
            rp = path_cell(2);
        end
        function set_scans(obj, niftifs)
            obj.scans = [];
            scan_dirstruct = strsplit(obj.path_left{:}, filesep);
            scan_dirstruct(cellfun(@isempty, scan_dirstruct)) = [];
            filepath = {obj.path};
            for i = 1:size(scan_dirstruct, 2)
                filepath = niftifs.cartesian(filepath, niftifs.replace_entry(scan_dirstruct{i}), 0);
            end
            for i = 1:size(filepath)
                obj.scans = filepath;
            end
            
        end
        
    end
end