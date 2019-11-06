function F2d_QuickViz(filename)
   % a quick visualization of every aspect of the system and its solution
   
   [sys, loads] = F2d_InputFromFile(filename);
   
   
   res = F2d_Solver(sys, loads);
   res.BeamForce = F2d_BeamInternalForces(sys,loads, res);
   res.BeamDeflection = F2d_BeamDeflectionCoeffs(sys, res);
   
   figure(1); clf; 
   F2d_PlotSys(sys);
   F2d_PlotLoad(sys, loads)
   
   figure(2); clf;
   F2d_PlotRes(sys, res);

   
   