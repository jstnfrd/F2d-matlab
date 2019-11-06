function F2d_PlotRes(sys, res, loads)
   
   
   if ~isfield(res, 'BeamIntForces') && nargin == 3
      res.BeamForce = F2d_BeamInternalForces(sys, loads, res);
   end
   
   if ~isfield(res, 'BeamDeflection') && nargin == 3
      res.BeamDeflection = F2d_BeamDeflectionCoeffs(sys, res);
   end
   
   %{
   subplot(2,2,1); title('u')
   F2d_PlotRes_Single(sys, res, 'u');
   subplot(2,2,2); title('M')
   F2d_PlotRes_Single(sys, res, 'M');
   subplot(2,2,3); title('Q')
   F2d_PlotRes_Single(sys, res, 'Q');
   subplot(2,2,4); title('N')
   F2d_PlotRes_Single(sys, res, 'N');
   %}

   clf; hold on; grid on; box on;
   
   subplot(1,3,1); title('M'); grid on; box on;
   F2d_PlotRes_Single(sys, res, 'M');
   subplot(1,3,2); title('Q'); grid on; box on;
   F2d_PlotRes_Single(sys, res, 'Q');
   subplot(1,3,3); title('N'); grid on; box on;
   F2d_PlotRes_Single(sys, res, 'N');