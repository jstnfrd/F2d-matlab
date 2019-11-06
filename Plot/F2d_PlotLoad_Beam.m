function F2d_PlotLoad_Beam(x, y, LoadVec, CS, sys_scale, load_scale, varargin)
   % plot a continous beam-load
   
   
   sd = 10;
   
   if CS == 1
      [T, ~] = F2d_getRotMat(x,y, 4);
      Fxy_local = LoadVec([3 1 4 2]) .* [1 -1  1 -1];
      Fxy_global = (T' * Fxy_local')';
      
   else
      Fxy_global = LoadVec([3 1 4 2]) .* [1 -1  1 -1];
   end
   
   
   % draw arrows from A to B, where B is on the beam and A the fletchings
   xAi = x(1) - load_scale *  Fxy_global(1);
   xAj = x(2) - load_scale *  Fxy_global(3);
   yAi = y(1) - load_scale *  Fxy_global(2);
   yAj = y(2) - load_scale *  Fxy_global(4);
   
   xA = linspace(xAi, xAj, sd);
   yA = linspace(yAi, yAj, sd);
   xB = linspace(x(1), x(2), sd);
   yB = linspace(y(1), y(2), sd);
   
   for i = 1:sd
      F2d_PlotLoad_Arrow(xA(i), yA(i), xB(i), yB(i), sys_scale, varargin{:})
   end
   
   plot([xAi xAj], [yAi, yAj], 'Color', 'r', 'LineWidth', 2);
end
