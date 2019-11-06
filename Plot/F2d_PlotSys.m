function F2d_PlotSys(sys)
   % a quick and dirty visualization of the system input.
   hold on; axis equal; grid on; axis tight
   dx = .12;
   
   scale = F2d_PlotSys_getSysScale(sys);
   
   
   for iB = 1:sys.Bars.nB
      [x, y, ~, ~, ~, alpha] = F2d_ExtractBeamData(sys, iB);
      
      LabelTxt = sprintf('B%i/M%i', iB, sys.Bars.Material(iB));
      PltType = sys.Materials(sys.Bars.Material(iB)).PltInfo;
      F2d_PlotSys_Bar(x,y, LabelTxt, PltType);
      
      fac = [.07 .9];
      for iE = 1:2
         x_hinge = x(1) * (1-fac(iE)) + x(2) * fac(iE);
         y_hinge = y(1) * (1-fac(iE)) + y(2) * fac(iE);
         F2d_PlotSys_Hinge(x_hinge, y_hinge, sys.Bars.Locked(iB, F2d_getBeamEndDofPos(iE)), alpha, scale);
      end
      
      
   end
   
   for iN = 1:sys.Nodes.nN
      F2d_PlotSys_Support(sys.Nodes.x(iN), sys.Nodes.y(iN), ...
         sys.Nodes.Locked(iN,:), sys.Nodes.LockRot(iN),...
         scale);
      
   end
   
end