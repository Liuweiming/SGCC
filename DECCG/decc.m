
% The main DECC-G algorithm
function gval = decc(fname, func_num, dim, Lbound, Ubound, popsize, itermax, runindex)


% the initial population
pop = Lbound + rand(popsize, dim) .* (Ubound-Lbound);

val = feval(fname, pop, func_num);
[bestval, ibest] = min(val);
bestmem = pop(ibest, :);

% the initial crossover rate for SaNSDE
ccm = 0.5;
subdim = 100;
Cycle = 1;
iter = 1;

gval(Cycle) = bestval;
while (iter < itermax)
    
    group = grouping(dim, subdim);
    group_num = size(group, 2);
    
    for i = 1:group_num
        
        oneitermax = 100;
        if (iter + oneitermax >= itermax)
            oneitermax = itermax - iter;
        end
        if (oneitermax == 0)
            break;
        end
        Cycle = Cycle + 1;
        dim_index = group{i};
        
        subpop = pop(:, dim_index);
        subLbound = Lbound(:, dim_index);
        subUbound = Ubound(:, dim_index);
        
        [subpopnew, bestmemnew, bestvalnew, ~, ccm] = sansde(fname, func_num, dim_index, subpop, bestmem, bestval, subLbound, subUbound, oneitermax, ccm);
        
        iter = iter + oneitermax;
        
        pop(:, dim_index) = subpopnew;
        bestmem = bestmemnew;
        bestval = bestvalnew;
        gval(Cycle) = bestval;
    end
    
    val = feval(fname, pop, func_num);
    [best, ibest] = min(val);
    if (best < bestval)
        bestval = best;
        bestmem = pop(ibest, :);
    end
    iter = iter + 1;
    Cycle = Cycle + 1;
    oneitermax = 100;
    if (iter + oneitermax >= itermax)
        oneitermax = itermax - iter;
    end
    [newmember, newmem_val, ~, flag] = de_weight(fname, func_num, bestmem, bestval, Lbound, Ubound, popsize, oneitermax, group);
    if (flag == 0)
        iter = iter + oneitermax;
    end
    
    if (newmem_val < bestval)
        bestval = newmem_val;
        bestmem = newmember;
    end
    gval(Cycle) = bestval;
    Cycle = Cycle + 1;
    oneitermax = 100;
    if (iter + oneitermax >= itermax)
        oneitermax = itermax - iter;
    end
    [mem_val, mem_id] = max(val);
    member = pop(mem_id, :);
    [newmember, newmem_val, ~, flag] = de_weight(fname, func_num, member, bestval, Lbound, Ubound, popsize, oneitermax, group);
    if (flag == 0)
        iter = iter + oneitermax;
    end
    if (newmem_val < mem_val)
        val(mem_id) = newmem_val;
        pop(mem_id, :) = newmember;
    end
    if (newmem_val < bestval)
        bestval = newmem_val;
        bestmem = newmember;
    end
    gval(Cycle) = bestval;
    Cycle = Cycle + 1;
    oneitermax = 100;
    if (iter + oneitermax >= itermax)
        oneitermax = itermax - iter;
    end
    mem_id = randperm(popsize);
    mem_id = mem_id(1);
    mem_val = val(mem_id);
    member = pop(mem_id, :);
    [newmember, newmem_val, ~, flag] = de_weight(fname, func_num, member, bestval, Lbound, Ubound, popsize, oneitermax, group);
    if (flag == 0)
        iter = iter + oneitermax;
    end
    if (newmem_val < mem_val)
        val(mem_id) = newmem_val;
        pop(mem_id, :) = newmember;
    end
    if (newmem_val < bestval)
        bestval = newmem_val;
        bestmem = newmember;
    end
    gval(Cycle) = bestval;
%     fprintf(1, 'popsize = %d, bestval = %e\n', popsize, bestval);
end

