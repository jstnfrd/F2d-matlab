function varargout = atest_F2d_PlotRes(tcVec)
   
   if nargin < 1 || isempty(tcVec)
      tcVec = [101];
   end
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   [varargout{1:nargout}] = atest_ProcessResults(tcVec, okVec);
   
end

function ok = runtest(tc)
   global F2D_ROOT
   
   filename = [F2D_ROOT sprintf('autotests/testsystems/%i.inp', tc)];

   
   
   [sys, loads] = F2d_InputFromFile(filename);
   
   
   res = F2d_Solver(sys, loads);
   res.BeamForce = F2d_BeamInternalForces(sys,loads, res);
   res.BeamDeflection = F2d_BeamDeflectionCoeffs(sys, res);
   
%    figure(1); clf; 
%    F2d_PlotSys(sys);
%    F2d_PlotLoad(sys, loads)
   
   figure(2); clf;
   F2d_PlotRes(sys, res);

end


