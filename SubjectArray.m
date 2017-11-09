classdef SubjectArray < handle
    properties ( SetAccess = private)
        subjects = {};
    end
    methods
        function obj = SubjectArray()
        end
        function add(obj, Subject)
            if(~obj.contains(Subject.get_id))
                obj.subjects(end+1,:) = {Subject};
            else
                warning(['Subject: ' Subject.get_id ' already exists!'])
            end
        end
        function remove(obj, id)
            if(~obj.contains(id))
                warning(['Subject: ' id ' does not exist!'])
            else
                match_arr = obj.get_match(get_ids(obj), id);
                obj.subjects(match_arr) = [];
            end
        end
        function remove_strmatch(obj, pattern)
            match_arr = obj.get_strmatch(get_ids(obj), pattern);
            obj.subjects(match_arr) = [];
        end
        
        function match = get_strmatch(~, ids, pattern)
            match = find(cellfun(@(x) contains(x, pattern), ids));
        end
        function match = get_match(~, ids, id)
            match = find(cellfun(@(x) strcmp(x, id), ids));
        end
        function match = contains(obj, id)
            ids = get_ids(obj);
            if ~isempty(ids)
                match = any(obj.get_match(ids,id));
            else
                match = 0;
            end
        end
        function ids = get_ids(obj)
            ids = cellfun(@get_id, obj.subjects, 'UniformOutput', 0);
        end
    end
end