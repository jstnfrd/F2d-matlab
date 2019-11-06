function res = atest_SolveStructural(TC)
   % run the system and return all the structural results
   
   if TC < 100
      [sys, load] = F2d_InputFromTestCase(TC);
   else   
      [sys, load] = F2d_InputFromFile(sprintf('autotests/testsystems/%3i.inp', TC));
   end
   
   if nargout == 0
      figure(1); clf; hold on; axis equal; grid on;
      F2d_PlotSys(sys);
      F2d_PlotLoad(sys, load);
   end
   
   res = F2d_Solver(sys, load);
   res.BeamForce = F2d_BeamInternalForces(sys,load, res);
   %res.BeamForce.End
   res.BeamDeflection = F2d_BeamDeflectionCoeffs(sys, res);
   %F2d_PlotRes_Single(sys, res, 'u')
   figure(2); clf; hold on; axis equal; grid on;
   F2d_PlotRes(sys, res);
   
end