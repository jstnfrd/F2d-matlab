function L = F2d_getLength(x,y)
   dx = x(2) - x(1);
   dy = y(2) - y(1);
   L = sqrt(dx^2 + dy^2);
end
