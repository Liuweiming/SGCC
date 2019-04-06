
% generate the complete population based on:
% wpop:  the weight population
% mem:   a complete individual
% group: the grouping structure

function gpop = getgpop(wpop, mem, group);

dim = size(mem, 2);
[popsize, wdim] = size(wpop);

gpop = zeros(popsize, dim);
for i = 1:wdim
    gpop(:, group{i}) = wpop(:, i) * ones(1, size(group{i}, 2));
end

gpop = gpop .* (ones(popsize, 1) * mem);

