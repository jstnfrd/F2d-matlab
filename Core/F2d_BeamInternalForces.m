function res = F2d_BeamInternalForces(sys, load, sol)
   % compute M,Q,N for each beam, optimized for plotting. ie
   % compute values at the end and the location and value of maximum force
   
   for iB = 1:sys.Bars.nB
      iLoadVec = find(load.BarLoad.Bar' == iB);
      [~,~,~,~,L] = F2d_ExtractBeamData(sys, iB);
      cM1 = zeros(1,4);
      cQ1 = zeros(1,3);
      cN1 = zeros(1,3);
      
      % coefficients for beam-load
      for iL = iLoadVec
         Ld = F2d_ExtractLocalizedBeamLoad(sys, load, iL);
         [cM1_, cQ1_, ~, cN1_] = getLoadCoeffs(Ld(1), Ld(2), Ld(3), Ld(4),L);
         cM1 = cM1 + cM1_; cQ1 = cQ1 + cQ1_; cN1 = cN1 + cN1_;
      end
      
      % coefficients from solution
      cN0 = getLinCoeffs(sol.BeamEndForce(iB,[1 4]), L);
      cQ0 = getLinCoeffs(sol.BeamEndForce(iB,[2 5]), L);
      cM0 = getLinCoeffs(sol.BeamEndForce(iB,[3 6]), L);
      
      % superposed coefficients
      cN = cN1 + [0 cN0];
      cQ = cQ1 + [0 cQ0];
      cM = cM1 + [0 0 cM0];


      BeamForce(iB).Coeff.N = cN;
      BeamForce(iB).Coeff.Q = cQ;
      BeamForce(iB).Coeff.M = cM;
      
      % beam-end values
      BeamForce(iB).End.N = polyval(cN, [0,L]);
      BeamForce(iB).End.Q = polyval(cQ, [0,L]);
      BeamForce(iB).End.M = polyval(cM, [0,L]);
      
      % beamwise local extrema
      [BeamForce(iB).Max.N.x, BeamForce(iB).Max.N.v] = getExtrema(cN,L);
      [BeamForce(iB).Max.Q.x, BeamForce(iB).Max.Q.v] = getExtrema(cQ,L);
      [BeamForce(iB).Max.M.x, BeamForce(iB).Max.M.v] = getExtrema(cM,L);
      
      %BeamForce(iB).End
      %BeamForce(iB).Max.N
      %BeamForce(iB).Max.Q
      %BeamForce(iB).Max.M
   end
   
   res = BeamForce;
end


function [cM1, cQ1, cq1, cN1] = getLoadCoeffs(qL, qR, nL, nR, L)
   cM1 = [(qL - qR)/(6*L), -qL/2, (L*(7*qL + 3*qR))/20,-(L^2*(3*qL + 2*qR))/60];
   cQ1 = [(qL - qR)/(2*L), -qL, (L*(7*qL + 3*qR))/20];
   cq1 = [(qL - qR)/L, -qL];
   cN1 = [(nL - nR)/(2*L), -nL, (L*nL)/3 + (L*nR)/6];
end

function cLin = getLinCoeffs(f, L)
   % coefficients for linear polynomial
   fL = f(1); fR = f(2);
   cLin = [(fR-fL)/L, fL];
end

function [x,v] = getExtrema(p,L)
   % get extreme values of polynomial with coefficients p on open set (0 L)
   tol = 1e-5;
   x = roots(polyder(p));
   x(x < tol | x > L - tol) = [];
   v = polyval(p, x);
end
   
