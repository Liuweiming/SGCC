% ------------
% Description:
% ------------
% This function is used to read the differential grouping datafiles and
% form the subcomponents which are used by the cooperative co-evolutionary
% framework. This function is called in decc.m.
%
%--------
% Inputs:
%--------
%    fun : the function id for which the corresponding grouping should
%          be loaded by reading the differential grouping datafiles.

function group = diff_grouping(fun)

    filename = sprintf('./decc-dg/dg/results/F%02d', fun);

    load(filename);

    group = nonseps;

    if(~isempty(seps))
        group = {group{1:end} seps};
    end
end
