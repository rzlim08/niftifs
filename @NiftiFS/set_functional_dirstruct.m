function set_functional_dirstruct( obj, dirstruct )
% takes a string that describes the directory structure to the
% functional scans. A directory structure consists of a file
% path string, with special folders (eg. subjects, runs) in
% curly braces eg. {subjects}. Each dirstruct must start with
% {top_level}.
obj.functional_directory.set_dirstruct(dirstruct);
end

