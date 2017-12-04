classdef Z < handle
    properties(SetAccess = private)
        variance
        path
    end
    methods
        function obj = Z(matrix, mask, path)
            Z = matrix(:, mask);
            [Z, meanZ, stdZ] = zscore(Z, 1);
            obj.path = path;
            save(path, 'Z', 'meanZ', 'stdZ');
        end
        function Z = get(obj)
           load(obj.path); 
        end
    end
end