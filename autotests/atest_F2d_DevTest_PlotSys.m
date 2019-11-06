function varargout = atest_F2d_DevTest_PlotSys(tcVec)
   
   if nargin < 1 || isempty(tcVec)
      tcVec = [1];
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
      [sys, ~] = F2d_InputFromFile(sprintf('%s/autotests/testsystems/%3i.inp', ROOTPATH, tc_file));
      
      res_ref = true;
   else
      error('no such testcase: [%i]', tc)
   end
   
   F2d_PlotSys(sys);
   
   ok = 1
end


