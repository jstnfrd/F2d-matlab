function F2d_PlotSys_Support(x, y, Locks, rot, scale, varargin)
   
   if nargin < 4 || isempty(rot)
      rot = 0;
   end
   
   if nargin < 5 || isempty(scale)
      scale = .1;
   end
   
   if isempty(varargin)
      FmtLine = {'k', 'LineWidth', 2};
   else
      FmtLine = varargin;
   end
   
   plt_x = [NaN]; plt_y = [NaN];
   
   % basic symbol dimensions 
   w = 1; % width of symbol
   h = w*.866;%sind(60); % height of symbol
   d = .2; % distance to coord
   
   if Locks(1)
      % x is locked
      plt_x = [plt_x NaN d + [0 h h 0] NaN 2*d+h * [1 1]];
      plt_y = [plt_y NaN 0 -w/2 w/2 0 NaN -w/2 w/2];
      
   end
   
   if Locks(2)
      % y is locked
      plt_x = [plt_x NaN 0 -w/2 w/2 0 NaN -w/2 w/2];
      plt_y = [plt_y NaN -[d + [0 h h 0] NaN 2*d+h * [1 1]]];
   end
   
   if Locks(3) 
      % phi is locked
      patch_x = [-d d d -d -d];
      patch_y = [-d -d d d -d];
      
      plt_x = [plt_x NaN patch_x];
      plt_y = [plt_y NaN patch_y];
   elseif ~Locks(3) && any(Locks(1:2))
      sd = 32;
      th = linspace(0,2*pi, sd);
      rr = linspace(d,d, sd);
      [patch_x, patch_y] = pol2cart(th, rr);
      
      plt_x = [plt_x NaN patch_x];
      plt_y = [plt_y NaN patch_y];
   else
      patch_x = [NaN]; patch_y = [NaN];
   end
   
   rotMat = [cosd(rot) -sind(rot); sind(rot) cosd(rot)];
   plt_xy = (rotMat * [plt_x; plt_y]) * scale + [x;y];
   patch_xy = (rotMat * [patch_x; patch_y]) * scale + [x;y];
   
   patch(patch_xy(1,:)', patch_xy(2,:)', 'w');
   plot(plt_xy(1,:), plt_xy(2,:), FmtLine{:});
   
   
end
      
      
      
   