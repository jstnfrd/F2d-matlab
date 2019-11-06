function Coeffs = F2d_BeamDeflectionCoeffs(sys, res)
   % extract coefficients to plot deflection line.
   
   for iB = 1:size(res.ux,1)
      [~,~,~,~,L] = F2d_ExtractBeamData(sys, iB);
      % u_y(x):
      uy_i = res.uy(iB,1); uy_j = res.uy(iB,2);
      phi_i = res.phi(iB,1); phi_j = res.phi(iB,2);
      Coeffs(iB).Coeff.ux = [...
         (2*uy_i - 2*uy_j + L*phi_i + L*phi_j)/L^3
         -(3*uy_i - 3*uy_j + 2*L*phi_i + L*phi_j)/L^2
         phi_i
         uy_i
         ];
      
      Coeffs(iB).Coeff.ux = [res.ux(iB,2) - res.ux(iB,1) / L, res.ux(iB,1)];
   end
end