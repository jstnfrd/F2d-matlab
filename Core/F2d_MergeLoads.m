function [ loads ] = F2d_MergeLoads( loads_A, loads_B )
   
   loads = merge_recusive(loads_A, loads_B);
   
end

function M = merge_recusive(A, B)
   
   if isnumeric(A) || islogical(A)
      M = [A; B];
   elseif isstruct(A)
      fields = fieldnames(A);
      M = struct();
      for i = 1:numel(fields)
         M.(fields{i}) = merge_recusive(A.(fields{i}), B.(fields{i}));
      end
      
   else
      error('oops')
   end
   
end