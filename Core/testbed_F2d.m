function testbed_F2d
   clc; clf; hold on; grid on;

   [sysTC, loadTC] = F2d_InputFromTestCase(0);
%     [sysTXT, loadTXT] = F2d_InputFromFile('./inputs/t_hinges.inp');
   %[sysTXT, loadTXT] = F2d_InputFromFile('./makeExamples/inputs/030.inp');
   
   
   
   sys = sysTC; load = loadTC;
   %sys = sysTXT; load = loadTXT;
   
   F2d_PlotSys(sys);
   %n = F2d_StructuralDeterminancy(sys)
   %is_determinant = F2d_StructuralDeterminancy_BruteForce(sys, load)
   
   
   %PltScale= F2d_TexPlot_getSysScale(sys, [8 8], 0);
   
   res = F2d_Solver(sys, load);
   %res = sol;
   res.BeamForce = F2d_BeamInternalForces(sys,load, res);
   F2d_PlotRes_Single(sys, res, 'M'); 
   
   %F2d_TexPlot(sys, load, res, [], 'testbed', 2, [], [], 2);
   %F2d_TexPlot(sys, load, [], [], 'testbed', 0, [], [], 1);

end
