function varargout = atest_F2d_PlotDevTests(tcVec)
   
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
   
   if tc == 1
      tc_file = tc + 220;
      tc_file = 210;
      [sys, ~] = F2d_InputFromFile(sprintf('%s/autotests/testsystems/%3i.inp', ROOTPATH, tc_file));
      sys.Nodes.Locked(:) = 0;
      
      res_ref = true;
   else
      error('no such testcase: [%i]', tc)
   end
   
   
   res_is = checkKinematicy(sys);
   
   ok = compareStructsTol(res_ref, res_is, 0, 'res');

end


