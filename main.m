%% setting

close all;
warning off;
addpath('./EAalgorithms');
dbstop if error
benchmark = 'benchmark_func2013';
if strcmp(benchmark, 'benchmark_func2013')
    rmpath('./benchmark_func2008');
    addpath('./benchmark_func2013_large');
    func_name = {'Shifted Elliptic Function'
        'Shifted Rastrigin''s Function'
        'Shifted Ackley''s Function'
        '7-nonseparable, 1-separable Shifted and Rotated Elliptic Function'
        '7-nonseparable, 1-separable Shifted and Rotated Rastrigin''s Function'
        '7-nonseparable, 1-separable Shifted and Rotated Ackley''s Function'
        '7-nonseparable, 1-separable Shifted Schwefel''s Function'
        '20-nonseparable Shifted and Rotated Elliptic Function'
        '20-nonseparable Shifted and Rotated Rastrigin''s Function'
        '20-nonseparable Shifted and Rotated Ackley''s Function'
        '20-nonseparable Shifted Schwefel''s Function'
        'Shifted Rosenbrock''s Function'
        'Shifted Schwefel''s Function with Conforming Overlapping Subcomponents'
        'Shifted Schwefel''s Function with Conflicting Overlapping Subcomponents'
        'Shifted Schwefel''s Function'};

    save_func_name = {...
        'Elliptic', 'Rastrigin', 'Ackley', ... % Fully-separable Functions
        'Partially1Elliptic','Partially1Rastrigin', 'Partially1Ackley', 'Partially1Schwefel', ... % Partially Additive Separable Functions I
        'Partially2Elliptic','Partially2Rastrigin', 'Partially2Ackley', 'Partially2Schwefel',... % Partially Additive Separable Functions II
        'Rosenbrock', 'ConformingOverlappingSchwefel', 'ConflictingOverlappingSchwefel',... % Overlapping Functions
        'Schwefel'...                  % Hybrid Composition Function
        };
    initialRange = [-100, -5, -32, -100, -5, -32, -100, -100, -5, -32, -100, -100, -100, -100, -100
        100,  5,  32,  100,  5,  32,  100,  100,  5,  32,  100,  100,  100,  100,  100];
    initialRange = num2cell(initialRange, 1);
    searchRange = initialRange;                % Search range equal to Initial range for most of functions
    D  = 1000 * ones(1, 15);
    D(13:14) = 905 * ones(1, 2);
    D = num2cell(D);
elseif strcmp(benchmark, 'benchmark_func2008')
    rmpath('./benchmark_func2013_large');
    addpath('./benchmark_func2008');
    javaclasspath('./benchmark_func2008/FractalFunctions.jar')
    func_name = {'Shifted Sphere Function'
        'Shifted Schwefel''s Function'
        'Shifted Rosenbrock''s Function'
        'Shifted Rastrigin''s Function'
        'Shifted Griewank''s Function'
        'Shifted Ackley''s Function'
        'FastFractal "DoulbeDip" Function'};
    
    save_func_name = {'Sphere',...
        'Schwefel',...
        'Rosenbrock',...
        'Rastrigin',...
        'Griewank',...
        'Ackley',...
        'DoubleDip'};
    initialRange = [-100, -100, -100, -5, -600, -32, -1
        100, 100, 100, 5, 600, 32, 1];
    initialRange = num2cell(initialRange, 1);
    searchRange = initialRange;                % Search range equal to Initial range for most of functions
    D = 1000;
 elseif strcmp(benchmark, 'benchmark_func2010')
    rmpath('./benchmark_func2013_large');
    rmpath('./benchmark_func2008');
    addpath('./benchmark_func2010_large');
    func_name = {'Shifted Elliptic Function'
        'Shifted Rastrigin''s Function'
        'Shifted Ackley''s Function'
        'Single-group Shifted and Rotated Elliptic Function'
        'Single-group Shifted and Rotated Rastrigin''s Function'
        'Single-group Shifted and Rotated Ackley''s Function'
        'Single-group Shifted Schwefel''s Function'
        'Single-group Shifted Rosenbrock''s Function'
        'D/2m-group Shifted and Rotated Elliptic Function'
        'D/2m-group Shifted and Rotated Rastrigin''s Function'
        'D/2m-group Shifted and Rotated Ackley''s Function'
        'D/2m-group Shifted Schwefel''s Function'
        'D/2m-group Shifted Rosenbrock''s Function'
        'D/m-group Shifted and Rotated Elliptic Function'
        'D/m-group Shifted and Rotated Rastrigin''s Function'
        'D/m-group Shifted and Rotated Ackley''s Function'
        'D/m-group Shifted Schwefel''s Function'
        'D/m-group Shifted Rosenbrock''s Function'
        'Shifted Schwefel''s Function'
        'Shifted Rosenbrock''s Function'};

    save_func_name = {...
        'Elliptic', 'Rastrigin', 'Ackley', ... % Fully-separable Functions
        'Partially1Elliptic','Partially1Rastrigin', 'Partially1Ackley', 'Partially1Schwefel', 'Partially1Rosenbrock', ...  % Partially Additive Separable Functions I
        'Partially2Elliptic','Partially2Rastrigin', 'Partially2Ackley', 'Partially2Schwefel', 'Partially2Rosenbrock',...  % Partially Additive Separable Functions II
        'Partially3Elliptic','Partially3Rastrigin', 'Partially3Ackley', 'Partially3Schwefel', 'Partially3Rosenbrock',... % Partially Additive Separable Functions III
        'Schwefel', 'Rosenbrock' ...                  % Hybrid Composition Function
        };
    initialRange = [-100, -5, -32, -100, -5, -32, -100, -100, -100, -5, -32, -100, -100, -100, -5, -32, -100, -100, -100, -100
        100, 5, 32, 100, 5, 32, 100, 100, 100, 5, 32, 100, 100, 100, 5, 32, 100, 100, 100, 100];
    initialRange = num2cell(initialRange, 1);
    searchRange = initialRange;                % Search range equal to Initial range for most of functions
    D = 1000;
    
end

runs = 30;
maxFEs = 3000 * 1000;
parameters = struct(...
    'save_func_name', save_func_name,...
    'runs',           runs,...
    'maxFEs',         maxFEs,...
    'D',              D,...
    'initialRange',   initialRange,...
    'searchRange',    searchRange...
    );
for func_num = 1:15
%     SaNSDE(func_name, func_num, parameters(func_num));
%     CBCC3_DG2(func_name, func_num, parameters(func_num));
%     DECCG(func_name, func_num, parameters(func_num));
    SGCC(func_name, func_num, parameters(func_num));

end

