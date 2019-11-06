function scale = F2d_PlotSys_getSysScale(sys)
   % get a scaling factor for symbols, etc.
   
   xyU = [max(sys.Nodes.x) max(sys.Nodes.y)];
   xyL = [min(sys.Nodes.x) min(sys.Nodes.y)];
   
   diagL = norm(xyU - xyL);
   
   scale = .03 * diagL;
   
end