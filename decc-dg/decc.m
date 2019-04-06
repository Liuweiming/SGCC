% Author: Dr. Zhyenu Yang
% Modified by: Mohammad Nabi Omidvar
% email address: mn.omidvar AT gmail.com
%
% ------------
% Description:
% ------------
% This file is an implementation of cooperative co-evolution which
% uses SaNSDE algorithm as subcomponent optimizer.
%
% -----------
% References:
% -----------
% Omidvar, M.N.; Li, X.; Mei, Y.; Yao, X., "Cooperative Co-evolution with
% Differential Grouping for Large Scale Optimization," Evolutionary Computation,
% IEEE Transactions on, vol.PP, no.99, pp.1,1, 0
% http://dx.doi.org/10.1109/TEVC.2013.2281543
%
% --------
% License:
% --------
% This program is to be used under the terms of the GNU General Public License 
% (http://www.gnu.org/copyleft/gpl.html).
% Author: Mohammad Nabi Omidvar
% e-mail: mn.omidvar AT gmail.com
% Copyright notice: (c) 2013 Mohammad Nabi Omidvar


function gval = decc(fname, func_num, dim, Lbound, Ubound, popsize, Max_FEs, runindex)

    % for fitness trace
    tracerst = [];

    % the initial population
    pop = Lbound + rand(popsize, dim) .* (Ubound-Lbound);

    val = feval(fname, pop, func_num);
    [bestval, ibest] = min(val);
    bestmem = pop(ibest, :);
    FEs = popsize;
    gval = bestval;

    % the initial crossover rate for SaNSDE
    group = {};
    ccm = 0.5;
    sansde_iter = 100;
    Cycle = 0;
    iter = 1;

    %addpath('benchmark');

    group = diff_grouping(func_num);

    group_num = size(group, 2);

    display = 0;
    frequency = 100;

    while (FEs < Max_FEs)
        Cycle = Cycle + 1;

        for i = 1:group_num

            dim_index = group{i};
            one_iter = sansde_iter;

            subpop = pop(:, dim_index); 
            subLbound = Lbound(:, dim_index);        
            subUbound = Ubound(:, dim_index);

            if (FEs + (one_iter * popsize) > Max_FEs)
                if(group_num > 1)
                    one_iter = ceil((Max_FEs - FEs - popsize) / popsize);
                else
                    one_iter = ceil((Max_FEs - FEs) / popsize);
                end
            end

            [subpopnew, bestmemnew, bestvalnew, tracerst, ccm, used_FEs] = sansde(fname, func_num, dim_index, subpop, bestmem, bestval, subLbound, subUbound, one_iter, ccm, group_num);

            FEs = FEs + used_FEs;

            pop(:, dim_index) = subpopnew;
            if bestvalnew < bestval
                bestmem = bestmemnew;
                bestval = bestvalnew;
            end
            iter = iter + 1;
            gval(iter) = bestval;
            
            if(display == 1)
                fprintf(1, 'Function = %d, Run = %d, Cycle = %d, bestval = %e, Group = %d\n', func_num, runindex, Cycle, bestval, i);
            end

            if(FEs >= Max_FEs)
                 break;
            end
        end

    end
end
