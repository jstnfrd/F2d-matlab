function F2d_PlotLoad_BentArrow(x,y, orientation, scale, varargin)
   % Orientation: 1:ccw, -1:clockwise
   
   FmtLine = {'r', 'LineWidth', 2};
   
   scale = scale * 3;
   
   hold on; axis equal
   plot(x, y, '+r')
   
   % in refecence polar CS
   tip_slope = 5;
   tip_height = .3 * scale;
   radius = .5 * scale;
   
   arrow_len = pi * .7;
   
   sd_plt = 20;
   
   
   % construct on reference-cs
   
   % tip
   r = [0 tip_height/tip_slope -tip_height/tip_slope 0 NaN];
   s = [0 tip_height tip_height 0 NaN];
   
   % tail
   r = [r 0 0 NaN];
   s = [s tip_height arrow_len NaN];
   
   [x_plt,y_plt] = pol2cart(linspaceVec(s * -orientation, sd_plt),...
      linspaceVec(r + radius, sd_plt));
   
   plot(x_plt + x, y_plt + y, FmtLine{:}, varargin{:});
   
end


function v_sd = linspaceVec(v, sd)
   
   nV = numel(v); % no of values
   
   v_sd = interp1(1:nV, v, 1:1/sd:nV);
   
end