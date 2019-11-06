function F2d_PlotSys_Bar(x,y, LabelTxt, PltType, varargin)
   
   
   if nargin < 3 || isempty(LabelTxt)
      LabelTxt = '';
   end
   
   if nargin < 4 || isempty(PltType)
      PltType = 1;
   end
   
   
   if isempty(varargin)
      if PltType == 1
         LW = 3;
      elseif PltType == 2
         LW = 2;
      else
         error('unknown PltType: %i', PltType);
      end
      
      FmtPlt = {'k', 'LineWidth', LW};
   else
      FmtPlt = varargin;
   end
   
   
   plot(x, y, FmtPlt{:});
   F2d_PlotSys_BarLabel(x, y, LabelTxt)
   
end