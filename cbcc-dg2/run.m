% Author: Dr. Zhenyu Yang
% Modified by: Mohammad Nabi Omidvar
% email address: mn.omidvar AT gmail.com
%
% ------------
% Description:
% ------------
% This files is the entry point for the DECC-DG algorithm which is
% a cooperative co-evolutionary DE based on the differential grouping
% algorithm for finding the non-separable groups in black-box optimization.
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
%
% -----
% Note:
% -----
% In this program the number of objective function evaluations which is used
% by the differential grouping algorithm is automatically subtracted
% from the maximum number of evaluations allowed (Max_FEs).
% There is no need to manually do this.

clear all; close all;
% set random seed
rand('state', sum(100*clock));
randn('state', sum(100*clock));
addpath('benchmark');
addpath('benchmark/datafiles');

% problem dimension
D = 1000;

% population size
NP = 50;

% number of independent runs
runs = 2;

% number of fitness evaluations
Max_FEs = 3e6;

% for the benchmark functions initialization
global initial_flag;

myfunc = [1:20];

for fun=myfunc
    diffGrouping = sprintf('./dg2/results/F%02d', fun);
    load (diffGrouping);
    Max_FEs = Max_FEs - FEs;
    if(Max_FEs <= 0)
        error('The maximum number of function evalutions is less than the amount needed by differential grouping. No budget is left for the optimization stage.');
    end

    VTRs = [];
    func_num = fun;
    bestval = [];
    for runindex = 1:runs
        % trace the fitness
        %fprintf(1, 'Function %02d, Run %02d\n', fun, runindex);
        filename = sprintf('trace/tracef%02d_%02d.txt', func_num, runindex);
        fid = fopen(filename, 'w');
        
        initial_flag = 0;
        
        % the main step, call runcompe(), see the runcompe.m  
        [val] = runcompe('benchmark_func', func_num, D, NP, Max_FEs, runindex, fid);
        bestval = [bestval; val];
        fclose(fid);
    end
    
    bestval = sort(bestval);
    % the best results of each independent run
    filename = sprintf('result/bestf%02d.txt', func_num);
    fid = fopen(filename, 'w');
    fprintf(fid, '%e\n', bestval);
    fclose(fid);
    
    % mean
    filename = sprintf('result/meanf%02d.txt', func_num);
    fid = fopen(filename, 'w');
    fprintf(fid, '%e\n', mean(bestval));
    fclose(fid);
    
    % std
    filename = sprintf('result/stdf%02d.txt', func_num);
    fid = fopen(filename, 'w');
    fprintf(fid, '%e\n', std(bestval));
    fclose(fid);

end

