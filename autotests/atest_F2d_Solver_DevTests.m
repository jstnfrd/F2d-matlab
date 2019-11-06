function atest_F2d_Solver_DevTests()
   % test advanced features of the solver.
   clc
   tcVec = [140];
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   table(tcVec', okVec', 'VariableNames', {'TC', 'res'})
   
end 

function ok = runtest(tc)
   
   if tc == 101 || tc == 102
      a = 25; q = 4; L = 5; R = q*L;
      %Av = q * L / 2; Bv = Av * cosd(a); Bh = -Av * sind(a);
      B = R*2 / ( 3*sind(a) + 4*cosd(a) );
      Av = R - B * cosd(a);
      Ah = B * sind(a);
      res_ref.Reaction(1).Value = [Ah];
      res_ref.Reaction(2).Value = [Av];
      res_ref.Reaction(3).Value = [B];

   elseif tc == 103 || tc == 104
      R = 20; a = 15;
      Av = R; 
      Bh = 0;
      Bm = 2*R;
      res_ref.Reaction(1).Value = [Av];
      res_ref.Reaction(2).Value = [Bh];
      res_ref.Reaction(3).Value = [Bm];
      
   elseif tc == 110  % testing (rotated) bar-end-locks
      R = 10; a = 0;
      Ah = 0; Av = R; Am = 1*R; B = 0;
      res_ref.Reaction(1).Value = [Ah];      
      res_ref.Reaction(2).Value = [Av];      
      res_ref.Reaction(3).Value = [Am];
      res_ref.Reaction(4).Value = [B];
      
   elseif tc == 111 || tc == 112 || tc == 113
      R = 20; a = 15;
      Ah = R / (4*tand(a)-3); Av = Ah*tand(a);
      Bv = R - Av; Bh = -Ah;
      G = - Av * sind(a) - Ah * cosd(a); % 
      res_ref.Reaction(1).Value = [Ah];      
      res_ref.Reaction(2).Value = [Av];      
      res_ref.Reaction(3).Value = [Bh];
      res_ref.Reaction(4).Value = [Bv];
   elseif tc == 114
      R = 20; a = 15;
      Ah = 0; Av = 0;
      Bh = 0; Bv = R; Bm = -2*R;
      res_ref.Reaction(1).Value = [Ah];      
      res_ref.Reaction(2).Value = [Av];      
      res_ref.Reaction(3).Value = [Bh];
      res_ref.Reaction(4).Value = [Bv];
      res_ref.Reaction(5).Value = [Bm];
   elseif tc >= 120 && tc <= 123 % testing BarEndLoads
      Fh = 5; Fv = 15; Mg = 13;
      Bv = 1/6 * (2*Fh+2*Fv-Mg);
      Ah = -Fh; Av = Fv - Bv;
      res_ref.Reaction(1).Value = [Ah];      
      res_ref.Reaction(2).Value = [Av];      
      res_ref.Reaction(3).Value = [Bv];
   elseif tc >= 130 && tc <= 132
      Bv = 1/4; Av = -Bv; 
      Ah = 3 * Av; Bh = -Ah;
      res_ref.Reaction(1).Value = [Ah];
      res_ref.Reaction(2).Value = [Av];
      res_ref.Reaction(3).Value = [Bh];
      res_ref.Reaction(4).Value = [Bv];
   elseif tc == 135
      a = atan(4/3);
      Bv = -1/sin(a); Ma = -6*Bv; Av = Ma/6; Ah = 1/5*(-Ma-6*Bv);
      res_ref.Reaction(1).Value = [Ah];
      res_ref.Reaction(2).Value = [Av];
      res_ref.Reaction(3).Value = [Ma];
      res_ref.Reaction(4).Value = [Bv];
      
   elseif tc == 140 % test stiffness in hinge and rotated support
      res_ref = [];
   else
      error('TC %i not defined', tc);
   end
   
   res_is = atest_SolveStructural(tc);
   
   
   
   ok = compareStructsTol(res_ref, res_is);
end