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
        function split(obj, num)
            new_sa = SubjectArray();
            for i = 0:num-1
               for j = 0:size(obj.subjects,1)-1
                  if mod(j, num) == i 
                     new_sa.add(obj.subjects{j+1});
                  end
               end
               save(['subjects_' num2str(i)], 'new_sa');
               new_sa = SubjectArray();
            end
        end
        
        function subjects = get_subjects(obj)
            subjects = obj.subjects;
        end
        function subject = pop_subject(obj)
            subject = obj.subjects{1};
            obj.subjects(1) = [];
        end
        function make_KV(obj, name)
            if(nargin<2)
                name = 'KV_subjects';
            end
           Key = obj.get_run_ids;
           Key = vertcat(Key{:});
           Value = obj.get_runs;
           save(name, 'Key', 'Value');
        end
        function remove_strmatch(obj, pattern)
            match_arr = obj.get_strmatch(get_ids(obj), pattern);
            obj.subjects(match_arr) = [];
        end
        function runs = get_runs(obj)
           runs = {};
           for i = 1:length(obj.subjects)
              run_vector = obj.subjects{i}.get_runs;
              for run = 1:length(run_vector)
                 runs{end+1} = run_vector(run); 
              end
           end
           runs = runs';
        end
        function match = get_strmatch(~, ids, pattern)
            match = find(cellfun(@(x) ~isempty(strfind(x, pattern)), ids));
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
        function cache(obj, path_to_remote, temp_path)
            if nargin<3
                temp_path = '/tmp';
            end
            cellfun(@(x)(cache(x, path_to_remote, temp_path)), obj.subjects);
            
        end
        function ids = get_run_ids(obj)
           ids = cellfun(@get_run_id, obj.subjects, 'UniformOutput', 0); 
            
        end
        function ids = get_ids(obj)
            ids = cellfun(@get_id, obj.subjects, 'UniformOutput', 0);
        end
    end
end