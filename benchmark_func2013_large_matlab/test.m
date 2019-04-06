
clear all;
close all;
global initial_flag;

for i=1:15
    i
    initial_flag = 0;
    file = sprintf("./datafiles/f%02d.mat", i);
    load(file);
    benchmark_func(xopt+1, i)
end
