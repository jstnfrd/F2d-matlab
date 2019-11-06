function derive_tensionbar
   clc;clf; hold on;
   syms EA x  nL nR L c1 c2 real
   syms n(x) u(x)
   
   n(x) = nL * (1 - x/L) + nR * (x/L);
   
   EAu2 = -n;
   EAu1 = int(EAu2, x) + c1;
   EAu0 = int(EAu1, x) + c2;
   
   % apply BC
   c2 = 0;
   c1 = solve(subs(EAu0(L))==0,c1);
   
   % actual functions of interest
   u(x) = subs(EAu0 / EA);
   N(x) = subs(EAu1);
   
   % beam-end forces (sign already considering local-cs)
   fprintf('nL = %s;\n', -simplify(N(0)))
   fprintf('nR = %s;\n', simplify(N(L)))

   
   % numerical example
   L = 5;
   nL = 4;
   nR = 4;
   EA = 1000;
   
   n_(x) = subs(n);
   u_(x) = subs(u);
   N_(x) = subs(N);
   
   
   subplot(3,1,1); hold on;plot([0 L], [0 0], '-k');
   fplot(n_, [0 L]);
   subplot(3,1,2); hold on;plot([0 L], [0 0], '-k');
   fplot(u_, [0 L]);
   subplot(3,1,3); hold on;plot([0 L], [0 0], '-k');
   fplot(N_, [0 L]);
%    subplot(4,1,3); hold on;plot([0 L], [0 0], '-k');
%    fplot(Q_, [0 L]);
%    subplot(4,1,4); hold on;plot([0 L], [0 0], '-k');
%    fplot(M_, [0 L]);
%    
%    
