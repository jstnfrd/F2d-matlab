function F2d_PlotRes_Single(sys, res, PltField, varargin)
   % a quick and dirty visualization of the results
   
   hold on;
   
   sd = 31;
   sd_hatch = 7;
   
   if ~strcmp(PltField, 'u')
      scale = F2d_PlotSys_getForceScale(res.BeamForce, 2, PltField);
   else
      lx = max(sys.Nodes.x) - min(sys.Nodes.x);
      ly = max(sys.Nodes.y) - min(sys.Nodes.y);
      l = sqrt(lx^2 + ly^2);
      maxU = max(abs([res.uX(:); res.uY(:)]));
      scale = .2 * l / maxU;
   end
   
   switch PltField
      case 'M'
         PltColor = 'r';
      case 'Q'
         PltColor = 'b';
      case 'N'
         PltColor = 'g';
      case 'u'
         PltColor = 'm';
   end
   
   for iB = 1:sys.Bars.nB
      [x, y, ~, ~, L, alpha] = F2d_ExtractBeamData(sys, iB);
      plot(x,y, '-k', 'LineWidth',2);
      
      % results in fiber coordinates
      plt.x = linspace(0,L, sd);
      plt.xh = linspace(0,L, sd_hatch);
      plt.yh0 = zeros(1, sd_hatch);
      
      if ~strcmp(PltField, 'u')
         plt.y = -polyval(res.BeamForce(iB).Coeff.(PltField), plt.x) * scale;
         plt.yh = -polyval(res.BeamForce(iB).Coeff.(PltField), plt.xh) * scale;
      else
         plt.y = -polyval(res.BeamDeflection(iB).Coeff.ux, plt.x) * scale;
         plt.yh = -polyval(res.BeamDeflection(iB).Coeff.ux, plt.xh) * scale;
      end
      
      % results in global coordinates
      plt.X = x(1) + cos(alpha) * plt.x - sin(alpha) * plt.y;
      plt.Y = y(1) + sin(alpha) * plt.x + cos(alpha) * plt.y;
      
      plt.Xh = x(1) + cos(alpha) * plt.xh - sin(alpha) * plt.yh;
      plt.Yh = y(1) + sin(alpha) * plt.xh + cos(alpha) * plt.yh;
      plt.Xh0= x(1) + cos(alpha) * plt.xh - sin(alpha) * plt.yh0;
      plt.Yh0= y(1) + sin(alpha) * plt.xh + cos(alpha) * plt.yh0;
      
      plot(plt.X', plt.Y', '-', 'Color', PltColor,'LineWidth',2, varargin{:});
      plot([plt.Xh0; plt.Xh], [plt.Yh0; plt.Yh], ':', 'Color', PltColor, 'LineWidth',1, varargin{:});
    
   end

   axis equal; %axis tight
   
end