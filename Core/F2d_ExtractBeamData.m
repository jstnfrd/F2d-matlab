function [x,y,BeamNodes,BeamMat, L, alpha] = F2d_ExtractBeamData(sys, iB)
   % extract coords from the struct. (a typical lazyness function...)
   
   BeamNodes = sys.Bars.Conn(iB,:);
   BeamMat = sys.Materials(sys.Bars.Material(iB));
   x = sys.Nodes.x(BeamNodes);
   y = sys.Nodes.y(BeamNodes);
   
   if nargout > 4
       L = F2d_getLength(x,y);
   end
   
   if nargout > 5
       alpha = atan2(y(2)-y(1),x(2)-x(1));
   end
   
   
end
