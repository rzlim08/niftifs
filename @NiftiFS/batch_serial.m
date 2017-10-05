function ret = batch_serial(obj,  func, cell_list)
tl =  '';
for i = 1:size(cell_list, 1)
    cl = cellfun(@(x)[tl x], cell_list{i}, 'uni', false);
    if(nargout(func) ==0)
        feval(func, char(cl));
    else
        ret{i} = feval(func, char(cl));
    end
end
end