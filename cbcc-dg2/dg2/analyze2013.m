% Author: Mohammad Nabi Omidvar
% email address: mn.omidvar AT gmail.com
%
% ------------
% Description:
% ------------
% This file is used to analyze the performance of the differential
% grouping algorithm on the CEC'2013 LSGO benchmark problems.
% This program reads the data files generated by differential 
% grouping and shows how many variables from each of the formed groups
% are correctly identified and to which permutation group they
% belong.
%
% --------
%  Inputs:
% --------
%    1. funs: a vector containing the functions ids the functions that you want to analyze.
%    2. results_path: the path that contains the output of differential grouping.
%    3. data_path: the path that contains the datafiles relating to the benchmark suite.
%
% -----------
% References:
% -----------
% Omidvar, M. N., Yang, M., Mei, Y., Li, X., & Yao, X. (2017). DG2: A
% Faster and More Accurate Differential Grouping for Large-Scale Black-Box
% Optimization. IEEE Transactions on Evolutionary Computation.
% https://doi.org/10.1109/TEVC.2017.2694221
%
% Omidvar, M. N., Li, X., Mei, Y., & Yao, X. (2014). Cooperative co-evolution
% with differential grouping for large scale optimization. IEEE Transactions
% on Evolutionary Computation, 18(3), 378-393.
%
% --------
% License:
% --------
% This program is to be used under the terms of the GNU General Public License 
% (http://www.gnu.org/copyleft/gpl.html).
% Author: Mohammad Nabi Omidvar
% e-mail: mn.omidvar AT gmail.com
% Copyright notice: (c) 2013 Mohammad Nabi Omidvar

function analyze2013(funcs, results_path, data_path)
    warning('off','all')
    more off;

    numNonSep           = [0 0 0 7 7 7 7 20 20 20 20 1 20 20 1];
    bench_adj_path      = fullfile(data_path, 'adjacency');
    bench_datafile_path = fullfile(data_path, 'datafiles');

    for i=funcs
        filename = fullfile(results_path, sprintf('F%02d.mat', i));
        load(filename);
        filename = fullfile(bench_adj_path, sprintf('f%02d.mat', i));
        BENCH = load(filename);
    
        mat = zeros(length(nonseps), 20);
        drawline('=');
        fprintf(1, 'Function F: %02d\n', i);
        fprintf(1, 'FEs used: %d\n', evaluations.count);
        fprintf(1, 'Number of separables: %d\n', length (seps));
        fprintf(1, 'Number of non-separable groups: %d\n', length (nonseps));
    
        filename = fullfile(bench_datafile_path, sprintf('f%02d.mat', i));
        m = 0;
        p = 1:1000;
        s = [1000];
        dim = 1000;
        if(exist(filename))
            load(filename);
        end
        if(ismember(i, [13 14]))
            dim = 905;
        end
    
        if ~isempty(nonseps)
            fprintf(1, 'Expected sizes    |  ');
            for j=1:length(s)
                fprintf(1, ' %4d', s(j));
            end
            fprintf(1, '\n');
        end
        for j=1:length(nonseps)
            c = cumsum(s);
            fprintf(1, 'Size of G%02d: %3d  |  ', j, length (nonseps{j}));
            for g=1:length(s)
                if g == 1
                    ldim = 1;
                else
                    ldim = c(g-1) - ((g-1)*m) + 1;
                end
                udim = c(g) - ((g-1)*m);

                captured = length(intersect(p(ldim:udim), nonseps{j}));
                fprintf(1, ' %4d', captured);
                mat(j, g) = captured;
            end
            fprintf(1, '\n');
        end
    
        mat2 = mat;
        [temp I] = max(mat, [], 1);
        [sorted II] = sort(temp, 'descend');
        masks = zeros(size(mat));
        for k = 1:min(size(mat))
            mask = zeros(1, length(sorted));
            if sorted(k) == 0
                break;
            end
            mask(II(k)) = 1;
            masks(I(II(k)), :) = mask;
            mat(I(II(k)), :) = mat(I(II(k)), :) .* mask;
            [temp I] = max(mat, [], 1);
            [sorted II] = sort(temp, 'descend');
        end
        mat = mat2 .* masks;
    
        [temp I] = max(mat, [], 1);
        ind_mask = temp > 0;
        I = I .* ind_mask;
        dg_ind = I(1:numNonSep(i));
        dg_ind = dg_ind(dg_ind>0);
    
        Theta = triu(theta);
        ThetaI = triu(BENCH.Adj);
    
        [rho1 rho2 rho3] = rho_metrics(Theta, ThetaI);
        fprintf(1, 'Rho-metrics: rho1 = %f; rho2 = %f; rho3 = %f\n', rho1, rho2, rho3);
    
        found = find(triu(theta) == triu(BENCH.Adj));
        missed = (dim^2) - length(found);
        fprintf(1, 'Missed interactions: %d\n', missed);
    
        drawline('=');
        pause;
    
    end
    
end


% Helper Functions ----------------------------------------------------------
function drawline(c)
    for i=1:121
        fprintf(1,c);
    end
    fprintf('\n')
end
