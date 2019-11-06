function is_determinant = F2d_StructuralDeterminancy_BruteForce(sys, load)
   
   nTrials = 3;
   
   solRef = F2d_Solver(sys, load);
   
   is_determinant = true;
   
   for iT = 1:nTrials
      
      TestMaterial = sys.Materials(1);
      TestMaterial.E = TestMaterial.E * (.5 + rand());
      TestMaterial.I = TestMaterial.I * (.5 + rand());
      TestMaterial.A = TestMaterial.A * (.5 + rand());
      
      sys.Materials(2) = TestMaterial;
      
      sys.Bars.Material = 1 + (rand(size(sys.Bars.Material)) > .5);
      
      sol = F2d_Solver(sys, load);
      
      if norm(solRef.BeamEndForce - sol.BeamEndForce) > 1e-3
         is_determinant = false;
         return;
      end
   
   end
   
end