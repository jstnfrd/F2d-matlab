function [scale_force, scale_sys] = F2d_PlotLoad_getForceScale(sys, loads)
   
   scale_sys = F2d_PlotSys_getSysScale(sys);
   
   max_load = max([...
      max(abs(loads.NodalLoad.Load(:)))
      max(abs(loads.BarLoad.Load(:)))
      max(abs(loads.BarEndLoad.Load(:)))
      ]);
   
   scale_force = scale_sys / max_load * 10;
   
end