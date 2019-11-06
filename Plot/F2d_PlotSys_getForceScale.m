function scale = F2d_PlotSys_getForceScale(BeamForce, MaxPaperSize, ForceType)
   % make that the maximum force is ploted at a given paper-size
   %    lx = max(sys.Nodes.x) - min(sys.Nodes.x);
   %    ly = max(sys.Nodes.y) - min(sys.Nodes.y);
   %    l = sqrt(lx^2 + ly^2);
   %
   maxForce = 0;
   for iB = 1:length(BeamForce)
      maxForce = max(abs([maxForce BeamForce(iB).End.(ForceType) BeamForce(iB).Max.(ForceType).v]));
   end
   
   if maxForce > 1e-5
      scale = MaxPaperSize / maxForce;
   else
      scale = 1;
   end
end