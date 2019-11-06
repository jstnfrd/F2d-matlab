function F2d_PlotLoad_SingleForce(x,y, LoadVec, scale_force, scale_sys, varargin)
   
   if norm(LoadVec(1:2)) > 0
      xB = x; yB = y;
      xA = xB - LoadVec(1) * scale_force;
      yA = yB - LoadVec(2) * scale_force;
      
      F2d_PlotLoad_Arrow(xA,yA,xB,yB,scale_sys, varargin{:});
   end
   if LoadVec(3) ~= 0
      F2d_PlotLoad_BentArrow(x,y, sign(LoadVec(3)), scale_sys, varargin{:})
   end
end