function T = F2d_getRotMatFromAngle(alpha, n)
   
   if alpha ~= 0
      sa = sin(alpha); ca = cos(alpha);
      T_ = [ca sa; -sa ca];
   else
      T_ = eye(2);
   end
   
   if nargin == 1 || n == 2
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