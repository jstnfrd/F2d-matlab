function [T, L] = F2d_getRotMat(x,y, n)
   % rotation matrix to transform
   % x_local = T * x_global
   % since inv(T) = T': x_global = T' * x_local
   % INPUT: x,y ... contains end coords of beam
   %        n ... size of matrix. values:
   %              2:rotate a vector (default),
   %              3:rotate forces/displacements and moment/rotation,
   %              4:like 2, but for both beam-ends
   %              6:like 3, but for both beam-ends
   
   dx = x(2) - x(1);
   dy = y(2) - y(1);
   L = sqrt(dx^2 + dy^2);
   vx = dx / L;
   vy = dy / L;
   
   T_ = [vx vy; -vy vx];
   
   if nargin == 2 || n == 2
      T = T_;
   elseif n == 3
      T = blkdiag(T_,1);
   elseif n == 4
      T = blkdiag(T_,T_);
   elseif n == 6
      T = blkdiag(T_,1,T_,1);
   else
      error('n invalid')
   end
   
end
