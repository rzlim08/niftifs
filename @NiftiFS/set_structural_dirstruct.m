function set_structural_dirstruct(obj,dirstruct)
% takes a string that describes the directory structure to the
% structural scans. A directory structure consists of a file
% path string, with special folders (eg. subjects, runs) in
% curly braces eg. {subjects}. Each dirstruct must start with
% {top_level}
if nargin <2
    obj.structural_dirstruct = '{top_level}/{subjects}/{scans}';
    warning('no dirstruct given, default= {top_level}/{subjects}/{scans}');
else
    obj.structural_dirstruct = dirstruct;
end
end