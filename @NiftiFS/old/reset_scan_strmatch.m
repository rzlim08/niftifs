function reset_scan_strmatch(obj, strmatch)
% reset the scan_strmatch parameter and reruns
% set_functional_scans.
obj.old_functionals{end+1, 2} = obj.functional_scans;
obj.old_functionals{end, 1} = obj.scan_strmatch;
obj.set_scan_strmatch(strmatch);
obj.set_functional_scans;
end