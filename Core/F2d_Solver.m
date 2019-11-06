function [res, condM] = F2d_Solver(sys, load)
   % solve the given system of bars using the matrix stiffness method
   
   % assemble system stiffness matrix
   % (and load-vector)
   [BarwiseDof, NodalDof] = getDofMats(sys);
   nB = size(sys.Bars.Conn,1);
   nN = numel(sys.Nodes.x);
   nD = max(max(BarwiseDof));
   
   %
   % assemble global stiffness matrix
   GlobalK = zeros(nD);
   BeamData.BeamK = cell(nB,1);
   BeamData.T = cell(nB,1);
   
   for iB = 1:nB
      [x, y,~,BeamMat] = F2d_ExtractBeamData(sys, iB);
      [BeamK, T] = getBarStiffness(x, y, BeamMat.E, BeamMat.A, BeamMat.I);
      
      GlobalDofs = BarwiseDof(iB,:);
      
      GlobalK(GlobalDofs, GlobalDofs) = GlobalK(GlobalDofs, GlobalDofs) + BeamK;
      
      BeamData.BeamK{iB} = BeamK;
      BeamData.T{iB} = T;
   end
   
   %
   % add spring to supports
   Dof2Support = [];
   for iN = 1:sys.Nodes.nN
      if sys.Nodes.LockRot(iN) == 0
         for iD = 1:3
            if ~sys.Nodes.Locked(iN,iD) && sys.Nodes.LockStiff(iB,iD) ~= 0
               Dof = NodalDof(iB,iD);
               GlobalDofs(Dof, Dof) = GlobalDofs(Dof, Dof) + sys.Nodes.LockStiff(iB,iD);
               Dof2Support(end+1, [1 2]) = [iN iD];
               
            end
         end
      else
         Stiff = sys.Nodes.LockStiff(iB, ~sys.Nodes.Locked(iN, :));
         T = F2d_getRotMatFromAngle(sys.Nodes.LockRot(iN), 3);
         StiffRot = ( T * Stiff')';
         Dof = NodalDof(iN,:);
         
         GlobalDofs(Dof, Dof) = GlobalDofs(Dof, Dof) + StiffRot;
         Dof2Support(end+1, [1 2]) = [iN iD];
         
      end
   end
   
   %
   % add springs in beam-hinges
   GlobalK_BarSpring = zeros(nD);
   for iB = 1:nB
      for iE = 1:2
         [x, y] = F2d_ExtractBeamData(sys, iB);
         EndPos = F2d_getBeamEndDofPos(iE);
         iN = sys.Bars.Conn(iB,iE);
         CurrLockStiff = sys.Bars.LockStiff(iB, EndPos);
         if ~all(CurrLockStiff == 0)
            K_BarSpring = getSprigStiffness(x,y, CurrLockStiff, ...
               sys.Bars.LockCS(iB,iE), sys.Bars.LockRot(iB,iE));
            DofPos = [BarwiseDof(iB,EndPos) NodalDof(iN,:)];
            
            GlobalK_BarSpring(DofPos, DofPos) = GlobalK_BarSpring(DofPos, DofPos) + ...
               K_BarSpring;
         end
      end
   end
   
   GlobalK = GlobalK + GlobalK_BarSpring;
   
   %
   % enforce nodal constraints (ie. supports)
   Kext = zeros(0,nD);
   Fext = zeros(0,1);
   nSupports = 0;
   for iN = 1:sys.Nodes.nN
      for iD = 1:3
         if sys.Nodes.Locked(iN,iD)
            if sys.Nodes.LockRot(iN) ~= 0 && iD < 3 && xorVec(sys.Nodes.Locked(iN,1:2))
               if sys.Nodes.Locked(iN,1) % locked in x-dir [1 0]
                  vals = [cosd(sys.Nodes.LockRot(iN)) sind(sys.Nodes.LockRot(iN))];
               else % locked in y-dir [0 1]
                  vals = [sind(sys.Nodes.LockRot(iN)) -cosd(sys.Nodes.LockRot(iN))];
               end
               iDvals = 1:2;
            else
               iDvals = iD;
               vals = -1;
            end
            
            Kext(end+1, NodalDof(iN,iDvals)) = vals;
            Fext(end+1,1) = 0;
            Dof2Support(end+1, [1 2]) = [iN iD];
            nSupports = nSupports + 1;
         end
      end
   end
   
   
   %
   % enforce beam-end constrains (ie. (rotated) hinges)
   for iB = 1:nB
      for iE = 1:2
         LockedSub = sys.Bars.Locked(iB, (1:3)+(iE-1)*3); % sub-matrix of Lock-Info
         if (sys.Bars.LockRot(iB,iE) ~= 0 || sys.Bars.LockCS(iB,iE) == 1) && ...
               xorVec(LockedSub(1:2))
            BarDof = BarwiseDof(iB, (1:3)+(iE-1)*3);
            NodeDof = NodalDof(sys.Bars.Conn(iB,iE),:);
            LockRot = sys.Bars.LockRot(iB,iE) * pi/180; % from here on in [rad]
            if sys.Bars.LockCS(iB,iE) == 1 % local CS
                [~,~,~,~,~,alpha] = F2d_ExtractBeamData(sys, iB);
               LockRot = LockRot + alpha;
            end
            if all(LockedSub(1:2) == [0 1])
               % this case is like [1 0](locked in y-dir) but rotated by 90
               % deg. constraints below are for [1 0]-case.
               LockRot = LockRot + pi/2;
            end
            Pos = [BarDof(1:2) NodeDof(1:2)];
            Values = [cos(LockRot) sin(LockRot) -cos(LockRot) -sin(LockRot)];
            ValueRhs = 0; % add hinge-opening here.
            Kext(end+1, Pos) = Values;
            Fext(end+1,1) = ValueRhs;
         end
      end
   end
   
   
   %
   % assemble load vector (nodal loads)
   GlobalF = zeros(nD,1);
   for iN = load.NodalLoad.Node(:)'
      Load = load.NodalLoad.Load(find(load.NodalLoad.Node == iN, 1), :);
      LoadMask = Load ~= 0;
      cDofs = NodalDof(iN,:);
      assert(~any(cDofs==-1 & LoadMask), 'load specified where there is no DoF');
      Dofs = NodalDof(iN, LoadMask);
      GlobalF(Dofs) = GlobalF(Dofs) + Load(LoadMask)';
   end
   
   %
   % assemble continous beam loads
   BeamEndForceMat = zeros(nB,6); % end forces of beam in local-cs
   for iL = 1:length(load.BarLoad.Bar)
      [Load,iB] = F2d_ExtractLocalizedBeamLoad(sys, load, iL);
      [x,y] = F2d_ExtractBeamData(sys, iB);
      [T,L] = F2d_getRotMat(x,y,6);
      
      BeamEndForce_local = F2d_getBeamEndForces(L, [1 1], Load(1), Load(2), Load(3), Load(4));
      BeamEndForce_global = T' * BeamEndForce_local';
      
      BeamEndForceMat(iB,:) = BeamEndForce_local;
      % assembly
      GlobalDofs = BarwiseDof(iB,:);
      DofMask = GlobalDofs > 0 ;
      
      GlobalF(GlobalDofs(DofMask)) = ...
         GlobalF(GlobalDofs(DofMask)) - ...
         BeamEndForce_global(DofMask);
   end
   
   %
   % assemble beam-end single-loads
   for iL = 1:length(load.BarEndLoad.Bar)
      iB = load.BarEndLoad.Bar(iL);
      [x,y] = F2d_ExtractBeamData(sys, iB);
      [T,L] = F2d_getRotMat(x,y,3);
      
      Dofs = BarwiseDof(iB, (1:3) + 3*(load.BarEndLoad.End(iL)-1));
      
      if load.BarEndLoad.CS(iL) == 1 % local CS
         Values = load.BarEndLoad.Load(iL, :);
         Values(2) = -Values(2);
         Values = T' * Values';
      elseif load.BarEndLoad.CS(iL) == 2 % global CS
         Values = load.BarEndLoad.Load(iL, :)';
      else
         error(' CS %i invalid in this context', load.BarEndLoad.CS(iL));
      end
      
      GlobalF(Dofs) = GlobalF(Dofs) + Values;
   end
   
   %
   % solve SOE
   Mat = [GlobalK Kext'; Kext zeros(size(Kext,1))];
   Rhs = [GlobalF; Fext];
   
   
   % seems unreliable:
   if nargout == 2
      condM = cond(Mat);
      %assert(condM < 1e11, 'system seems kinematic, cond(M)=%.1e\n', condM);
      warning('off', 'MATLAB:nearlySingularMatrix')
   end
   Sol = Mat \ Rhs; % contains displacements for each DoF
   U = Sol(1:nD);
   
   if nargout == 2
      warning('on', 'MATLAB:nearlySingularMatrix')
   end
   
   %
   % reaction forces
   RhsReaction = Mat * Sol - Rhs;
   RF = [RhsReaction(abs(RhsReaction) > 1e-7); Sol(nD + (1:nSupports))];
   for iR = 1:numel(RF)
      res.Reaction(iR).Value = RF(iR);
      res.Reaction(iR).Node = Dof2Support(iR,1);
      res.Reaction(iR).Dir  = Dof2Support(iR,2);
   end

   
   % map to bar-wise results
   res.uX = zeros(nB,2); % displacements in global coords
   res.uY = zeros(nB,2);
   res.ux = zeros(nB,2); % displacements in local coords
   res.uy = zeros(nB,2);
   res.phi = zeros(nB,2); % rotations
   
   %BDm = BarwiseDof(:)>0;
   BeamUResMat = U(BarwiseDof);
   
   if nB == 1
      % fix a matlab inconsitency when there is only one bar..
      BeamUResMat = BeamUResMat';
   end
   
   for iB = 1:nB
      res.uX(iB,:) = BeamUResMat(iB,[1 4]);
      res.uY(iB,:) = BeamUResMat(iB,[2 5]);
      res.phi(iB,:) = BeamUResMat(iB,[3 6]);
      
      % rotate vectors into local cs
      T = BeamData.T{iB};
      xypxyp = T * BeamUResMat(iB,:)';
      res.ux(iB,:) = xypxyp([1 4]);
      res.uy(iB,:) = xypxyp([2 5]);
   end
   
   %res
   %res.BeamResMat = BeamResMat;
   
   
   % compute beam-end-forces (not due to loading!)
   BeamEndForce_local_sol = zeros(nB, 6);
   for iB = 1:nB
      % K * U = F => U' * K' = F'
      BeamF_global = BeamUResMat(iB,:) * BeamData.BeamK{iB}'; % global forces on beam
      BeamF_local = BeamF_global * BeamData.T{iB}' .* [-1 1 -1 1 -1 1]; % end-forces on local CS
      BeamEndForce_local_sol(iB,:) = BeamF_local;
   end
   %BeamEndForce_local_sol
   res.BeamEndForce = BeamEndForce_local_sol;
   
end



function [K, T] = getBarStiffness(x, y, E, A, I)
   
   [T,L] = F2d_getRotMat(x,y, 6);
   
   k11 = A / L;
   k22 = 12 * I / L^3;
   k23 = 6 * I / L^2;
   k33 = 4 * I / L;
   k36 = 2 * I / L;
   
   k = E * [...
      k11  0    0   -k11  0    0  ;
      0    k22  k23  0   -k22  k23;
      0    k23  k33  0   -k23  k36;
     -k11  0    0    k11  0    0  ;
      0   -k22 -k23  0    k22 -k23;
      0    k23  k36  0   -k23  k33];
   
   K = T' * k * T;
   
end

function [K] = getSprigStiffness(x,y, LockStiff, LockCS, LockRot)
   
   
   T_glob = F2d_getRotMat(x,y, 6);
   T_rot  = F2d_getRotMatFromAngle(LockRot, 6);
   
   ksub = diag(LockStiff);
   
   k = [ ksub -ksub; 
        -ksub  ksub];
     
   
   if LockCS == 1
      % transfer from local to global CS
      K = T_rot * (T_glob' * k);
   else
      K = T_rot * k;
   end
   
end


function [BarwiseDof, NodalDof] = getDofMats(sys)
   % establish link between node-dof and global dof-number
   
   nN = numel(sys.Nodes.x);
   nB = size(sys.Bars.Conn, 1);
   Dof = 1;% current number of DOFs
   NodalDof = zeros(nN, 3) - 1; %0=no DoF can be assigned. -1=no DoF _yet_ assigned
   BarwiseDof = zeros(nB, 6) - 1;
   
   % build bar-wise Dof-Connectivity
   for iB = 1:nB
      for iE = 1:2
         Node = sys.Bars.Conn(iB,iE);
         EndMsk = (1:3) + (iE-1)*3; % mask to access DOFs for the current beam-end
         %determine if DOFs shall be taken from node
         if (sys.Bars.LockRot(iB,iE) ~= 0 || sys.Bars.LockCS(iB,iE) == 1) && ...
            xorVec(sys.Bars.Locked(iB, EndMsk(1:2)))
            % special case: interaction between x/y.
            GetNodalDofMask = ~~[0 0 sys.Bars.Locked(iB,EndMsk(3))]; 
         else
            % regular case: take info completely from .Locked()
            GetNodalDofMask = ~~sys.Bars.Locked(iB,EndMsk); 
         end
         NewNodalDofMask = NodalDof(Node,:) == -1 & GetNodalDofMask; % positions where we need new nodal DOFs
         NodalDof(Node, NewNodalDofMask) = [1:sum(NewNodalDofMask)] + Dof - 1;
         Dof = Dof + sum(NewNodalDofMask);
         
         BarwiseDof(iB, EndMsk(GetNodalDofMask)) = NodalDof(Node, GetNodalDofMask); % write nodal DOFs in place
         BarwiseDof(iB, EndMsk(~GetNodalDofMask)) = [1:sum(~GetNodalDofMask)] + Dof - 1; % write new DOFs in place
         Dof = Dof + sum(~GetNodalDofMask);
      end
   end
end


function res = xorVec(vec)
   res = xor(vec(1), vec(2));
end
   