       function ret = parfor_cell(~, func, cell_list)
            parfor i = 1:size(cell_list, 1)
                if(nargout(func) ==0)
                    feval(func, cell_list{i});
                else
                    ret{i} = feval(func, cell_list{i});
                end
            end
        end