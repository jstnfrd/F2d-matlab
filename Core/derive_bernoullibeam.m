function derive_bernoullibeam(Locked)
   % derive various stuff for the bernoulli beam.
   % INPUT: Locked [1x2] is left/right end clampled? (all other DoFs are
   % locked here anyways)
   % coord-sys for forces is: fiber, for displacement: beam-local
   
   clc;clf; hold on;
   syms EI x  qL qR L c1 c2 c3 real
   syms q(x) w(x)
   
   q(x) = qL * (1 - x/L) + qR * (x/L);
   EIw4 = -q;
   EIw3 = int(EIw4, x) + c1;
   EIw2 = int(EIw3, x) + c2;
   EIw1 = int(EIw2, x) + c3;
   EIw0 = int(EIw1, x) + 0; % c4=0 due to BC
   
   % apply BC
   if Locked(1) % left side is clamped
      eqns(1) = EIw1(0) == 0;
   else
      eqns(1) = EIw2(0) == 0;
   end
   
   if Locked(2) % right side is clamped
      eqns(2) = EIw1(L) == 0;
   else
      eqns(2) = EIw2(L) == 0;
   end
   
   eqns(3) = EIw0(L) == 0;
   
   sol = solve(eqns, [c1, c2,c3]);
   c1 = sol.c1;
   c2 = sol.c2;
   c3 = sol.c3;
   
%    
%    % c4=c3=0 due to BC.
%    c2 = solve(EIw0(L) == 0, c2);
%    c1 = solve(subs(EIw1(L)) == 0, c1);
%    
   
   % actual functions of interest
   w(x) = subs(EIw0);
   Q(x) = subs(EIw3);
   M(x) = subs(EIw2);
   
   
   % beam-end forces (in local beam-cs)
   fprintf('-------------- case: [%i %i]\n', Locked)
   fprintf('mL = %s;\n', -simplify(M(0)))
   fprintf('mR = %s;\n', +simplify(M(L)))
   fprintf('qL = %s;\n', +simplify(Q(0)))
   fprintf('qR = %s;\n', -simplify(Q(L)))
   
   
   % monomial coefficients
   fprintf('-------------- coeffs:\n')
   fprintf('c_M0 = %s;\n', simplify(coeffs(M,x)))
   fprintf('c_Q0 = %s;\n', simplify(coeffs(Q,x)))
   fprintf('c_q0 = %s;\n', -simplify(coeffs(q,x)))
   
   
   % example
   L = 6;
   qL = 5;
   qR = 15;
   EI = 1;
   
   q_(x) = subs(q);
   w_(x) = subs(subs(w));
   Q_(x) = subs(subs(Q));
   M_(x) = subs(subs(M));
   
   
   subplot(4,1,1); hold on;plot([0 L], [0 0], '-k');ylabel('q(x)')
   fplot(q_, [0 L]);
   subplot(4,1,2); hold on;plot([0 L], [0 0], '-k');ylabel('w(x)')
   fplot(w_, [0 L]);
   subplot(4,1,3); hold on;plot([0 L], [0 0], '-k');ylabel('Q(x)')
   fplot(Q_, [0 L]); set(gca, 'YDir', 'reverse')
   subplot(4,1,4); hold on;plot([0 L], [0 0], '-k');ylabel('M(x)')
   fplot(M_, [0 L]); set(gca, 'YDir', 'reverse')
   
   
