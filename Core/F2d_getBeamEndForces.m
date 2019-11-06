function F_local =  F2d_getBeamEndForces(L, Locked, qL, qR, nL, nR)
   % get end-forces for a beam under linear load
   % (forces in beam-local CS)
   
   if all(Locked == [1 1])
      mL = (L^2*(3*qL + 2*qR))/60;
      mR = -(L^2*(2*qL + 3*qR))/60;
      pyL = (L*(7*qL + 3*qR))/20;
      pyR = (L*(3*qL + 7*qR))/20;
      
   elseif all(Locked == [0 1])
      mL = 0;
      mR = -(L^2*(7*qL + 8*qR))/120;
      pyL = (L*(11*qL + 4*qR))/40;
      pyR = (L*(9*qL + 16*qR))/40;
      
   elseif all(Locked == [1 0])
      mL = (L^2*(8*qL + 7*qR))/120;
      mR = 0;
      pyL = (L*(16*qL + 9*qR))/40;
      pyR = (L*(4*qL + 11*qR))/40;
      
   elseif all(Locked == [0 0])
      mL = 0;
      mR = 0;
      pyL = (L*(2*qL + qR))/6;
      pyR = (L*(qL + 2*qR))/6;     
      
   end
   
   pxL = -(L*(2*nL + nR))/6;
   pxR = -(L*(nL + 2*nR))/6;
   
   F_local = [pxL pyL mL pxR pyR mR];
   
end
