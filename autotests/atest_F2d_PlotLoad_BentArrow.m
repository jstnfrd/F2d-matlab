function varargout = atest_F2d_PlotLoad_BentArrow(tcVec)
   
   clf;
   if nargin < 1 || isempty(tcVec)
      tcVec = [1:2];
   end
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   [varargout{1:nargout}] = atest_ProcessResults(tcVec, okVec);
   
end

function ok = runtest(tc)
   
   xA = [0 2];
   yA = [0 1];
   Orientation = [-1 1];
   
   F2d_PlotLoad_BentArrow(xA(tc), yA(tc),Orientation(tc), 1)
   ok = true;
   
end


