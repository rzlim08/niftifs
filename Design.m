classdef Design < handle
    properties ( SetAccess = private)
        num_scans;
        num_conds;
        cond_names;
        onsets;
        num_bins;
        path;
    end
    
    methods
        function obj = Design(onsets, num_bins, cond_names, num_scans)
            if(size(cond_names,1) ~= size(onsets,1))
               error('onsets must be a matrix of size (num_conds*num_onsets)'); 
            end
            obj.onsets = ceil(onsets);
            obj.num_bins = num_bins;
            obj.cond_names = cond_names;
            obj.num_conds = size(cond_names,1);
            obj.num_scans = num_scans;
            
        end
        
        function G = createG(obj)
            G = zeros(obj.num_scans, obj.num_bins*obj.num_conds);
            for j = 1:obj.num_conds
                for i = 1:size(obj.onsets,2)
                    G(obj.onsets(j, i):obj.onsets(j,i)+obj.num_bins-1, ... 
                        (j-1)*obj.num_bins+1:(j-1)*obj.num_bins+obj.num_bins) = ...
                        G(obj.onsets(j, i):obj.onsets(j,i)+obj.num_bins-1, ...
                        (j-1)*obj.num_bins+1:(j-1)*obj.num_bins+obj.num_bins)|...
                        eye(obj.num_bins);
                end
            end
        end
        
        % Remove eventually
        function create_G(obj, dir, run_id)
            G = zeros(obj.num_scans, obj.num_bins*obj.num_conds);
            for j = 1:obj.num_conds
                for i = 1:size(obj.onsets,2)
                    G(obj.onsets(j, i):obj.onsets(j,i)+obj.num_bins-1, ... 
                        (j-1)*obj.num_bins+1:(j-1)*obj.num_bins+obj.num_bins) = ...
                        G(obj.onsets(j, i):obj.onsets(j,i)+obj.num_bins-1, ...
                        (j-1)*obj.num_bins+1:(j-1)*obj.num_bins+obj.num_bins)|...
                        eye(obj.num_bins);
                end
            end
            [~, name, ~] = fileparts(run_id);
            obj.path = [dir filesep 'G_'  name];
            save(obj.path, 'G');
        end
        function normalize(obj)
            load(obj.path);
            G = zscore(G, 1);
            save(obj.path, 'G')
        end
        function G = get(obj)
           load(obj.path) 
        end
    end
    
end