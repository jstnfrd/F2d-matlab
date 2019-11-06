function varargout = atest_F2d_PlotSys_Support(tcVec)
   
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
   
   clf; axis equal; hold on; grid on; box on;
   
   plot([0 2 3], [0 1 2], 'k', 'LineWidth', 3);
   
   if tc == 1
      Locks = [1 1 1];
      rot = 15;
      scale = [];
      
   elseif tc == 2
      Locks = [1 1 0];
      rot = 15;
      scale = .2;
   else
      error('no such testcase: [%i]', tc)
   end

   F2d_PlotSys_Support(2, 1, Locks, rot, scale);
   ok = 1;

end


