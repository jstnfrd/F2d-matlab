function example
    
    
    % Load system and load from an input file:
    %
    % Iin F2d, `Sys` stores the system, ie. node coordinates, member
    % connectivty, etc. Whereas as external forces acting on the system are
    % stored in `Loads`. This allows an easier treatment of load-cases.
    
    TC = 100; 
    [Sys, Load] = F2d_InputFromFile(sprintf('autotests/testsystems/%3i.inp', TC));
    
    % graphical representation of the system including applied load
    figure(1); clf; hold on; axis equal; grid on; title('system and load')
    F2d_PlotSys(Sys);
    F2d_PlotLoad(Sys, Load);
    
    % Solve for displacements (and reaction forces):
    %
    % `res` is a strcuct containing various beam- and node-wise results.
    res = F2d_Solver(Sys, Load);
    
    % ... This struct can be enriched by adding internal forces via
    % post-processing ...
    res.BeamForce = F2d_BeamInternalForces(Sys,Load, res);
    
    % ... For plotting deflection curves (which are cubic polynomials), add
    % the respective coefficients:
    res.BeamDeflection = F2d_BeamDeflectionCoeffs(Sys, res);
    
    
    % Plot results. 
    figure(2); clf; hold on; axis equal; grid on; title('results')
    F2d_PlotRes(Sys, res);