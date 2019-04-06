%----------------------------------------------------------------------
% Classical Drop_Uniform_DECCG Algorithm
% Population size: NP = 100
% Function dimension: D = 30

% Mutation probability: F = 0.5
% Crossover probability: CR = 0.9
%----------------------------------------------------------------------

function SGCC(func_name, func_num, parameters)


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
dist_par = [1, 3, 4, 5];
weight_type = {'rand', 'norm', 'beta', 'local', 'cc'};
for dist = dist_par
parfor run = 1:runs
    algo_name = 'SGCC';
    algo_name = [algo_name, '_', weight_type{dist}];
    DECCG_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, dist);
end
end

end

function DECCG_run(save_func_name, func_num, algo_name, maxFEs, run, NP, D, inilb, iniub, lb, ub, dist)

gval = decc(@benchmark_func, func_num, D, lb * ones(NP, D), ub * ones(NP, D), NP, maxFEs / NP, run, dist);
% print some information to the prompt
fprintf(1, 'algo_name = %s, fun_num = %d, run_num = %d, bestSolution = %e\n', algo_name, func_num, run, gval(end));


% save best solutions to file
saveFigPath = ['result_sgcc', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
if ~isdir(saveFigPath)
    mkdir(saveFigPath);
end
save([saveFigPath, filesep, 'bestSolution'], 'gval');
end



% The main DECC-G algorithm
function gval = decc(fname, func_num, dim, Lbound, Ubound, popsize, itermax, runindex, dist)


% the initial population
pop = Lbound + rand(popsize, dim) .* (Ubound-Lbound);

val = feval(fname, pop, func_num);
[bestval, ibest] = min(val);
bestmem = pop(ibest, :);

% the initial crossover rate for SaNSDE
ccm = 0.5;
Cycle = 1;
iter = 1;

gval(Cycle) = bestval;
while (iter < itermax)
    
    oneitermax = 200;
    if (iter + oneitermax >= itermax)
        oneitermax = itermax - iter;
    end
    if (oneitermax == 0)
        break;
    end
    dim_index = 1:dim; % all dimensions
    if dist == 1
        weights = rand(1, dim);
    elseif dist == 2
        weights = randn(1, dim);
        weights(weights <= 0.01) = 0.01;
        weights(weights > 1) = 1;
    elseif dist == 3
        weights = betarnd(2, 5, 1, dim);
        weights(weights > 1) = 1;
    elseif dist == 4
        weights = 0.3 * ones(1, dim);
        weights(weights > 1) = 1;
    else
        weights = zeros(1, dim);
        evo_index = datasample(1:dim, 100, 'Replace', false);
        weights(evo_index) = 1;
    end
    pmean = bestmem;
    subpop = pmean + weights .* (pop - pmean);
    subLbound = pmean + weights .* (Lbound - pmean);
    subUbound = pmean + weights .* (Ubound - pmean);
   
    
    subLbound = max(subLbound, Lbound);
    subUbound = min(subUbound, Ubound);
    
    [subpopnew, bestmemnew, bestvalnew,  ~, ccm] = sansde(fname, func_num, dim_index, subpop, bestmem, bestval, subLbound, subUbound, oneitermax, ccm);
    iter = iter + oneitermax;

    pop =pop + (subpopnew - subpop);
    pop = max(Lbound, min(pop, Ubound));
    val = feval(fname, pop, func_num);
    bestmem = bestmemnew;
    bestval = bestvalnew;
    [best, ibest] = min(val);
    if (best < bestval)
        bestval = best;
        bestmem = pop(ibest, :);
    end
    iter = iter + 1;
    Cycle = Cycle + 1;
    gval(Cycle) = bestval;
    
%     figure(1)
%     plot(std(pop));
%     figure(2)
%     hold off;
%     plot(std(subpop));
%     hold on;
%     plot(std(subpopnew));
%     pause(0.1);
    
%     fprintf(1, 'popsize = %d, bestval = %e\n', popsize, bestval);
end

end
