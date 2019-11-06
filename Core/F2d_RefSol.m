function F2d_RefSol(sys, load, CaseGeometry, CaseLoad)
   
   Fx = 7;
   Fy = 8;
   L = 13;
   E = 1000;
   I = 3;
   A = 5;
   
   EI = E*I;
   EA = E*A;
   
   ux = Fx * L / EA
   uy = Fy * L^3 / 3 / EI
   
   
   kii = E * [A/L 0 0; 0 12*I/L^3 6*I/L^2; 0 6*I/L^2 4*I/L]
   
   
   
   