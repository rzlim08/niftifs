classdef RunScan < Run
    
    methods
        function obj = RunScan(path, name, path_left)
            if nargin<2
                error('A run needs a name and a path');
            end
            obj@Run(path, name, path_left);
        end
        function set_scans(obj, ~)
            obj.scans = [];
            
            num_scans = size(spm_vol(obj.path),1);
            scans = cell(num_scans, 1);
            scans(:, 1) = {obj.path};
            for i = 1:size(scans)
                scans{i} = [scans{i} ',' num2str(i)];
            end
            obj.scans = scans;
        end
        function move_scans(obj, from, to)
            obj.path = strrep(obj.path, from, to);
        end
        function cache(obj, from, to)
            old_path = obj.path;
            obj.uncache_path = old_path;
            move_scans(obj, from, to);
            new_path = obj.path;
            mkdir(fileparts(new_path));
            copyfile(old_path, new_path);
        end
        function uncache(obj)
            copyfile(obj.path, obj.uncache_path);
        end
            
        function n = spm_select_get_nbframes(file)
            % spm_select_get_nbframes(file) Get the number of volumes of a 4D nifti file, excerpt from SPM12 spm_select.m
            N   = nifti(file);
            dim = [N.dat.dim 1 1 1 1 1];
            n   = dim(4);
        end
    end
    
end