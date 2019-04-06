%----------------------------------------------------------------------
% Classical Drop_Uniform_DECCG Algorithm
% Population size: NP = 100
% Function dimension: D = 30

% Mutation probability: F = 0.5
% Crossover probability: CR = 0.9
%----------------------------------------------------------------------

function SaNSDE(func_name, func_num, parameters)

algo_name = 'SaNSDE';
runs = parameters.runs;
save_func_name = parameters.save_func_name;
NP = 100;
D = parameters.D;
maxFEs = parameters.maxFEs;
inilb = parameters.initialRange(1);
iniub = parameters.initialRange(2);
lb = parameters.searchRange(1);
ub = parameters.searchRange(2);
addpath('./DECCG');
parfor run = 1:runs
    DECCG_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub);
end

end

function DECCG_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub)

gval = decc(@benchmark_func, func_num, D, lb * ones(NP, D), ub * ones(NP, D), NP, maxFEs / NP, run);
% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d, bestSolution = %e\n', algo_name, func_num, run, gval(end));


% save best solutions to file
saveFigPath = ['result_SaNSDE', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
if ~isdir(saveFigPath)
    mkdir(saveFigPath);
end
save([saveFigPath, filesep, 'bestSolution'], 'gval');
end



% The main DECC-G algorithm
function gval = decc(fname, func_num, dim, Lbound, Ubound, popsize, itermax, runindex)


% the initial population
pop = Lbound + rand(popsize, dim) .* (Ubound-Lbound);

val = feval(fname, pop, func_num);
[bestval, ibest] = min(val);
bestmem = pop(ibest, :);

% the initial crossover rate for SaNSDE
ccm = 0.5;
subdim = 1000;
oneitermax = itermax - 1;
dim_index = 1:dim; % all dimensions
weights = ones(1, dim);
subpop = bestmem .* (1 - weights) + pop(:, dim_index) .* weights;
subLbound = Lbound(:, dim_index);
subUbound = Ubound(:, dim_index);

[~, ~, ~,  ~, ~, gval] = sansde(fname, func_num, dim_index, subpop, bestmem, bestval, subLbound, subUbound, oneitermax, ccm);
end
