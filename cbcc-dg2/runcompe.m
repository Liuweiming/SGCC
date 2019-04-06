
% set the search range, and call the decc algorithm

function [bestval] = runcompe(fname, func_num, D, NP, Max_Gen, runindex, fid);
 
    if(ismember(func_num, [1, 4, 7:9, 12:14, 17:20]))
        XRmin = -100*ones(NP,D); 
        XRmax = 100*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    if(ismember(func_num, [2, 5, 10, 15]))
        XRmin = -5*ones(NP,D); 
        XRmax = 5*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    if(ismember(func_num, [3, 6, 11, 16]))
        XRmin = -32*ones(NP,D); 
        XRmax = 32*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end

    % the main step, call decc(), see the decc.m
    [bestval]  = decc(fname, func_num, D, Lbound, Ubound, NP, Max_Gen, runindex, fid);

end
