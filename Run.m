classdef Run < handle
    properties ( SetAccess = protected)
        path = {};
        uncache_path = [];
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
        function move_scans(obj, from, to)
            obj.scans = cellfun(@(x)(strrep(x, from, to)), obj.scans, 'UniformOutput', 0);
        end
        function cache(obj, from, to)
            old_path = obj.scans;
            obj.uncache_path = old_path;
            move_scans(obj, from, to);
            new_path = obj.scans;
            [folder, ~, ext] = fileparts(new_path{1,1});
            mkdir(folder);
            cellfun(@(x, y) (copyfile(x,y)), old_path, new_path);
            if strcmp(ext,'.img')
                old_hdr_path = cellfun(@(x)(strrep(x, 'img', 'hdr')), old_path, 'UniformOutput', 0);
                new_hdr_path = cellfun(@(x)(strrep(x, 'img', 'hdr')), new_path, 'UniformOutput', 0);
                cellfun(@(x, y) (copyfile(x,y)), old_hdr_path, new_hdr_path);
            end
        end
        function uncache(obj)
            copyfile(fileparts(obj.scans{1,1}), fileparts(obj.uncache_path{1,1}));
            obj.scans = obj.uncache_path;
            obj.uncache_path = [];
        end
        function uncache_no_write(obj)
            obj.scans = obj.uncache_path;
            obj.uncache_path = [];
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
        function append_scan(obj, prefix)
            obj.scans = cellfun(@(x) obj.filename_append(x, prefix), obj.scans, 'UniformOutput', 0);
        end
        function fn = filename_append(~, x, prefix)
            [folder, file, ext] = fileparts(x);
            fn = [folder filesep prefix file ext];
        end
        function set_design_matrix(obj, onsets, num_bins, cond_names, path)
            obj.design_matrix = Design(onsets, num_bins, cond_names, size(obj.scans,1));
            create_G(obj.design_matrix, fileparts(obj.path), obj.name);
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
        function add_associated_matrix(obj, name, data)
            obj.associated_matrices.(name) = data;
        end
        function mat = get_associated_matrix(obj, name)
            mat = obj.associated_matrices.(name);
        end
        function scans = get_scans(obj)
            scans = obj.scans;
        end
    end
end