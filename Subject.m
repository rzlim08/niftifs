classdef Subject < handle
    properties ( SetAccess = private)
        path = {};
        id = {};
        structural_path = {};
        runs = [];
    end
    methods
        function obj = Subject(id, path)
           if nargin<2
              error('A subject needs an id and a path'); 
           end
           obj.id = id;
           obj.path = path;
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
        function bool = eq(obj, other)
           bool = (obj.id == other.id); 
        end
    end
end