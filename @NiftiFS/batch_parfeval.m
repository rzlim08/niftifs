function ret = batch_parfeval(obj,  func, cell_list)
tl =  '';
for i = 1:size(cell_list, 1)
    cl = cellfun(@(x)[tl x], cell_list{i}, 'uni', false);
    f(i) = parfeval(gcp(), func, 1, char(cl));
end
for i = 1:size(cell_list, 1)
    if(nargout(func)==0)
        fetchNext(f);
    else
        [completedIdx,value] = fetchNext(f);
        ret{completedIdx} = value;
    end
end
end