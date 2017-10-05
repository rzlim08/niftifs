function ret = parfeval_cell(~, func, cell_list)

for i = 1:size(cell_list, 1)
    f(i) = parfeval(gcp(), func, 1, cell_list{i});
end
ret = cell(size(cell_list));
for i = 1:size(cell_list, 1)
    [completedIdx,value] = fetchNext(f);
    ret{completedIdx} = value;
end
end