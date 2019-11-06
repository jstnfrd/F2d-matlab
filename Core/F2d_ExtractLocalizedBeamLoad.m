function [Load,iB] = F2d_ExtractLocalizedBeamLoad(sys, load, iL)
   % return Load vector in local beam coords for given beam-load-index iL
   
   
   iB = load.BarLoad.Bar(iL); CS = load.BarLoad.CS(iL); Load = load.BarLoad.Load(iL,:);
   [x, y] = F2d_ExtractBeamData(sys, iB);
   [T2, L] = F2d_getRotMat(x,y,2);
   
   if CS == 2 || CS == 3
      % rotate into fiber-cs
      Load = Load .* [-1 -1 1 1]; % correct sign before rotation
      Load([3 1]) = T2 * Load([3 1])';
      Load([4 2]) = T2 * Load([4 2])';
      Load = Load .* [-1 -1 1 1]; % correct sign after rotation
   end
   if CS == 3
      % project onto horizontal length
      Load = Load .* (x(2) - x(1))/L;
   elseif CS == 4
      % project onto vertical length
      Load = Load .* (y(2) - y(1))/L;
   end
end
