function undo(obj, num)
% undo the last change to the functional scans.
if nargin<2
    num = 1;
end
obj.functional_scans = obj.old_functionals{(end+1)-num, 2};
obj.set_scan_strmatch(obj.old_functionals{(end+1)-num, 1});
obj.old_functionals = obj.old_functionals(1:(end)-num, :);
end