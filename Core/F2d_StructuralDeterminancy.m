function n = F2d_StructuralDeterminancy(sys)
   % determine how many equations are missing to determine the stress state
   % in every point of the system.
   % n = (nU: number of unknowns) - (nE: number of available equations)
   % for this we remember that for every free-body-cut we get three
   % equations. each FBC, however creates a number of unknown forces.
   % we choose to cut each bar and each support next to nodes.
   
   % number of equations available
   nE = 3 * (sys.Nodes.nN + sys.Bars.nB);
   
   % number of unknowns
   nU = sum(sys.Nodes.Locked(:)) + sum(sys.Bars.Locked(:)) + sys.Bars.nB * 4;
   %    ^ support forces          ^ beam end-moments        ^ beam end-forces

   n = nU - nE;
   
end