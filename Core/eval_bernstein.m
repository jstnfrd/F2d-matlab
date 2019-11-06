function B = eval_bernstein(u)
   % evaluate the four 3rd-order bernstein polynomials at u
   
   B = zeros(4,numel(u));
   
   B(1,:) = (1-u).^3;
   B(2,:) = 3.*u .* (1-u).^2;
   B(3,:) = 3.*u.^2 .* (1-u);
   B(4,:) = u.^3;
end
