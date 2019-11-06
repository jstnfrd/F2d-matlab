function varargout = atest_F2d_DevTest_PlotLoad(tcVec)
   
   if nargin < 1 || isempty(tcVec)
      tcVec = [2];
   end
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   [varargout{1:nargout}] = atest_ProcessResults(tcVec, okVec);
   
end

function ok = runtest(tc)
   global ROOTPATH
   clf;
   if tc == 1
      tc_file = 210;
   elseif tc == 2
      tc_file = 300;
   else
      error('no such testcase: [%i]', tc)
   end
      [sys, loads] = F2d_InputFromFile(sprintf('%s/autotests/testsystems/%3i.inp', ROOTPATH, tc_file));
   
   F2d_PlotSys(sys);
   F2d_PlotLoad(sys, loads);
   
   ok = 1;
end


