function asd = linspaceVec(a, sd)
   
   nV = numel(a); % no of values

   asd = interp1(1:nV, a, 1:1/sd:nV);
   
end