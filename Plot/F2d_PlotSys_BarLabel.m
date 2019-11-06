function F2d_PlotSys_BarLabel(x, y, LabelTxt, varargin)
    
    alpha = atan2d(y(2)-y(1), x(2)-x(1));
    text(mean(x), mean(y), LabelTxt, 'VerticalAlignment', 'top',...
        'Rotation', alpha, 'HorizontalAlignment', 'center', varargin{:});
    
end