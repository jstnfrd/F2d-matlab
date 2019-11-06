function F2d_PlotLoad(sys, loads, varargin)
    % plot applied load on a system.
    
    [scale_force, scale_sys] = F2d_PlotLoad_getForceScale(sys, loads);
    
    for iNL = 1:numel(loads.NodalLoad.Node)
        iN = loads.NodalLoad.Node(iNL);
        
        F2d_PlotLoad_SingleForce(sys.Nodes.x(iN),sys.Nodes.y(iN),...
            loads.NodalLoad.Load(iNL,:), scale_force, scale_sys, varargin{:});
        
    end
    
    for iBL = 1:numel(loads.BarLoad.Bar)
        iB = loads.BarLoad.Bar(iBL);
        [x, y] = F2d_ExtractBeamData(sys, iB);
        F2d_PlotLoad_Beam(x, y, loads.BarLoad.Load(iB,:), loads.BarLoad.CS, scale_sys, scale_force, varargin{:})
        
    end
    
    for iBEL = 1:numel(loads.BarEndLoad.Bar)
        iB = loads.BarEndLoad.Bar(iBEL);
        iN = sys.Bars.Conn(iB, loads.BarEndLoad.End(iBEL));
        
        if loads.BarEndLoad.CS(iBEL) == 1
            [x, y] = F2d_ExtractBeamData(sys, iB);
            [T, ~] = F2d_getRotMat(x,y, 3);
            LoadVecGlob = (T' * loads.BarEndLoad.Load(iBEL,:)')';
        else
            LoadVecGlob = loads.BarEndLoad.Load(iBEL,:);
        end
        
        F2d_PlotLoad_SingleForce(sys.Nodes.x(iN),sys.Nodes.y(iN), ...
            LoadVecGlob, scale_force, scale_sys, varargin{:})
    end
    
end