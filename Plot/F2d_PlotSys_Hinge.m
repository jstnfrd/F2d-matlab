function F2d_PlotSys_Hinge(x, y, Locks, rot, scale, varargin)
   
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
   l = 2; % width of symbol
   h = .5;%sind(60); % height of symbol
   d = h * .4; % distance to coord
   
   if ~Locks(1)
      % x is hingy
      plt_x = [plt_x NaN l/2 * [-1 1] NaN l/2 * [-1 1]];
      plt_y = [plt_y NaN h/2 * [1 1]  NaN h/2 * [-1 -1]];
      
   end
   
   if ~Locks(2)
      % y is hingy
      plt_x = [plt_x NaN h/2 * [1 1] NaN h/2 * [-1 -1]];
      plt_y = [plt_y NaN l/2 * [-1 1] NaN l/2 * [-1 1]];
   end
   
   
   if Locks(3) && any(~Locks(1:2))
      % phi is locked (and other hinges are there)
      patch_x = [-d d d -d -d];
      patch_y = [-d -d d d -d];
      
      plt_x = [plt_x NaN patch_x];
      plt_y = [plt_y NaN patch_y];
   elseif ~Locks(3)
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
      
      
      
   