classdef Run < handle
    properties ( SetAccess = protected)
        path = {};
        name = {};
        scans = [];
        associated_matrices = [];
        design_matrix;
        path_left;
        Z;
        betas;
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
            if size(path_cell, 2) == 2
                rp = path_cell(2);
            else
                rp = path_cell;
            end
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
        function set_design_matrix(obj, onsets, num_bins, cond_names, path)
            obj.design_matrix = Design(onsets, num_bins, cond_names, size(obj.scans,1));
            create_G(obj.design_matrix, path, obj.name);
        end
        function G = get_design_matrix(obj)
            G = obj.design_matrix.get;
        end
        
        function set_Z(obj, Z)
            obj.Z = Z;
        end
        function Z = get_Z(obj)
            Z = obj.Z.get;
        end
        function set_beta(obj, path)
            G = obj.get_design_matrix;
            Z = obj.get_Z;
            C =  G\Z;
            C = sqrtm(G'*G)*C;
            save(path, 'C', '-V7.3');
            obj.betas = path;
        end
        function beta = get_beta(obj)
            beta = obj.betas;
        end
        function scans = get_scans(obj)
            scans = obj.scans;
        end
    end
end