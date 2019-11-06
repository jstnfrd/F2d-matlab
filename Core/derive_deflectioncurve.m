function derive_deflectioncurve
   clc;
   
   syms x wi wj phii phij c1 c2 c3 c0 L real
   
   w(x) = c3*x^3 + c2*x^2 + c1*x + c0;
   
   dwdx = diff(w,x);
   
   sol = solve([w(0)==wi; w(L)==wj; dwdx(0)==phii; dwdx(L)==phij], [c0 c1 c2 c3]);
   
   
   % print for copy&paste
   %for i = 1:numel(fieldnames(sol))
   for fnCell = fieldnames(sol)'
      fn = fnCell{1};
      fprintf('%s = ', fn)
      disp(sol.(fn))
   end
end