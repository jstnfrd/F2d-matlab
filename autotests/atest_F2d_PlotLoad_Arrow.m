function varargout = atest_F2d_PlotLoad_Arrow(tcVec)
   
   clf;
   if nargin < 1 || isempty(tcVec)
      tcVec = [1:3];
   end
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   [varargout{1:nargout}] = atest_ProcessResults(tcVec, okVec);
   
end

function ok = runtest(tc)
   
   xA = [5 0 0];
   yA = [0 0 0];
   xB = [2 -1 4];
   yB = [-1 1 0];
   scale = [1 1 1];
   
%    if tc == 1
%    
%       
%    else
%       error('no such testcase: [%i]', tc)
%    end

  
   
   
   F2d_PlotLoad_Arrow(xA(tc), yA(tc), xB(tc), yB(tc), scale(tc))
   
   ok = true;
   
end


