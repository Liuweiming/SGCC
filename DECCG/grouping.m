

% random grouping
function group = grouping(dim, subdim);

   dim_rand = randperm(dim);
   group = {};
   for i = 1:subdim:dim
      index = dim_rand(i:min(i+subdim-1, dim));
      group = {group{1:end} index};
   end
end

