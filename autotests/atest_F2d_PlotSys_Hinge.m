function varargout = atest_F2d_PlotSys_Hinge(tcVec)
   
   if nargin < 1 || isempty(tcVec)
      tcVec = [1:4];
   end
   
   clf; 
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   [varargout{1:nargout}] = atest_ProcessResults(tcVec, okVec);
   
end

function ok = runtest(tc)
   
   axis equal; hold on; grid on; box on;
   
   plot([1.5 2 2.5], [.75 1 2], 'k', 'LineWidth', 3);
   
   if tc == 1
      Locks = [1 1 1];
      rot = 0;
      scale = [];
      
   elseif tc == 2
      Locks = [0 0 0];
      rot = 15;
      scale = .2;    
      
   elseif tc == 3
      Locks = [1 0 1];
      rot = 15;
      scale = .2;
            
   elseif tc == 4
      Locks = [0 1 1];
      rot = 15;
      scale = .2;
   else
      error('no such testcase: [%i]', tc)
   end

   F2d_PlotSys_Hinge(1*tc, 1, Locks, rot, scale);
   ok = 1;

end


