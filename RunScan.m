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
    end
end