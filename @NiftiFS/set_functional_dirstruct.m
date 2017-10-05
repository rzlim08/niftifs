function set_functional_dirstruct( obj, dirstruct )
% takes a string that describes the directory structure to the
% functional scans. A directory structure consists of a file
% path string, with special folders (eg. subjects, runs) in
% curly braces eg. {subjects}. Each dirstruct must start with
% {top_level}.
if nargin <2
    obj.functional_dirstruct = '{top_level}/{subjects}/{scans}';
    warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
else
    obj.functional_dirstruct = dirstruct;
    
end
end

