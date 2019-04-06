%----------------------------------------------------------------------
% Classical DECCG Algorithm
% Population size: NP = 100
% Function dimension: D = 30

% Mutation probability: F = 0.5
% Crossover probability: CR = 0.9
%----------------------------------------------------------------------

function DECCG(func_name, func_num, parameters)

algo_name = 'DECCG';
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
saveFigPath = ['result_deccg', filesep, 'conver_trend', filesep, save_func_name, filesep, algo_name, filesep, 'run_', num2str(run)];
if ~isdir(saveFigPath)
    mkdir(saveFigPath);
end
save([saveFigPath, filesep, 'bestSolution'], 'gval');
end
