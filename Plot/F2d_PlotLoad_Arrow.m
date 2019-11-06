function F2d_PlotLoad_Arrow(xA, yA, xB, yB, scale, varargin)
   % plot an arrow going from A to B.
   
   hold on; axis equal; grid on; axis tight
   
   
   FmtLine = {'r', 'LineWidth', 2};
   
   tip_slope = 5;
   
   arrow_len = sqrt((xB-xA).^2 + (yB-yA).^2);
   tip_height = 0.7 * scale;
   
   
   % construct on reference-cs
   
   % tip
   r = [0 tip_height/tip_slope -tip_height/tip_slope 0 NaN];
   s = [0 tip_height tip_height 0 NaN];
   
   % tail
   r = [r 0 0 NaN];
   s = [s tip_height arrow_len NaN];
   
   rot = atan2d(yA-yB, xA-xB) - 90;
   rotMat = [cosd(rot) -sind(rot); sind(rot) cosd(rot)];
   plt_xy = (rotMat * [r; s]) * 1 + [xB;yB];

   plot(plt_xy(1,:), plt_xy(2,:), FmtLine{:}, varargin{:});
   
end