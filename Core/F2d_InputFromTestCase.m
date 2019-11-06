function [sys, load] = F2d_InputFromTestCase(TestCase)
   
   TestCaseMat = [...
      % +--------- TestCase
      % |  +------ CaseGeometry
      % |  |   +-- CaseLoad
     -1   0  -1
      0   0   0
      10  1   1
      21  2   1
      22  2   2
      23  2   3
      31  3   1
      32  3   2
      33  3   3
      ];
   
   
   iTC = find(TestCaseMat(:,1) == TestCase);
   assert(length(iTC) == 1);
   
   CaseGeometry = TestCaseMat(iTC, 2);
   CaseLoad = TestCaseMat(iTC, 3);
   
   
   % --------------------------------------------------------------------------
   % INPUTS:
   %
   %  sys.Nodes.
   %   .x         [nNx1]: x-coordinate (duh!)
   %   .y         [nNx1]: y-coordinate of that node
   %   .Locked    [nNx3]: is the dof locked? [ux uy phi]
   %                      (0=free,1=fixed,2=spring)
   %   .LockRot   [nNx1]: rotation of support in degrees ccw
   %   .LockStiff [nNx3]: stiffness of support in directon [ux uy phi]
   %   .nN        [nNx1]: number of nodes
   %
   %  sys.Bars.
   %   .Conn      [nBx2]: pointer to nodes [node-i node-j]
   %   .Locked    [nBx6]: is the dof locked? [ux-i uy-i phi-i ux-j uy-j phi-j], def: all locked
   %   .LockRot   [nBx2]: rotation of the locks [rot-i, rot-j] in deg, ccw, def: [0 0]
   %   .LockCS    [nBx2]: coord-sys of the lock-info (1=fiber,2=glob, def: 2)
   %   .LockStiff [nBx6]: stiffness of lock,
   %   .Material  [nBx1]: pointer to material, def: 
   %   .nB        [nBx1]: number of bars
   %
   %  sys.Materials(i).
   %   .E, .I, .A, : unit-appropriate material parameters
   %   .PltType    : 1: bar w/ fiber, 2: w/o fiber
   %
   % load.NodalLoad.
   %   .Node [nNLx1]: pointer to node
   %   .Load [nNLx3]: [Fx, Fy, M] in global CS (Fy>0 points up?)
   %
   % Load.BarLoad.
   %   .Bar  [nBLx1]: pointer to bar (bars can be referenced multiple times)
   %   .CS   [nBLx1]: coord sys: 1=fiber, 2=global, 3=projective
   %   .Load [nBLx4]: [qL qR nL nR] positive q values point downwards, pos. n to the right
   %
   % Load.BarEndLoad.
   %   .Bar  [nBLx1]: pointer to bar (bars can be referenced multiple times)
   %   .CS   [nBLx1]: coord sys: 1=fiber, 2=global, 3=projective
   %   .Load [nBLx3]: [Fx Fy M] positive q values point downwards, pos. n to the right
   %   .End  [nBLx1]; [1 or 2]: on which end is the bar acting on?
   % --------------------------------------------------------------------------
   
   
   % ------------------------------------------
   % geometry
   
   switch CaseGeometry
      case -1 % the empty one
         Nodes.x = []';
         Nodes.y = []';
         Nodes.Locked = [];
         Nodes.LockRot = [];
         
         Bars.Conn = [];
         Bars.Locked = ~~[];
         Bars.LockRot = [];
         Bars.LockCS = [];
         Bars.Material = [];
         
         Materials(1).E = 2.1e8;  % [kN/m^2]
         Materials(1).I = 2.5e-4; % [m^4]
         Materials(1).A = 1.5e-2; % [m^2]
         Materials(1).PltType = 1;
         
      case 0
         % the flexible one
         L = 3;
         q = 4; n= 0;
         Nodes.x = [0 4]';
         Nodes.y = [0 3]';
         Nodes.Locked = [1 1 0; 0 1 0];
         Nodes.LockRot = [0; 25];
         
         Bars.Conn = [1 2];
         Bars.Locked = ~~[1 1 0 1 1 1];
         Bars.LockRot = [0 0];
         Bars.LockCS = [1 2];
         Bars.Material = [1];
         
         Materials(1).E = 2.1e8;  % [kN/m^2]
         Materials(1).I = 2.5e-4; % [m^4]
         Materials(1).A = 1.5e-2; % [m^2]
         Materials(1).PltType = 1;
         
      case 1
         Nodes.x = [0 -1 4 7]';
         Nodes.y = [0 4 4 0]';
         Nodes.Locked = [1 1 0; 0 0 0; 0 0 0; 1 1 1];
         
         Bars.Conn = [1 2; 2 3; 3 4];
         Bars.Material = [1 1 1]';
         Bars.Locked = ~[1 0; 0 1; 1 0];
         Bars.PltType = [1 1 1]';
         
         Materials(1).E = 1000;
         Materials(1).I = .001;
         Materials(1).A = .01;
         
      case 2
         L = 13;
         a = 0;
         Nodes.x = [0,0.6666]';
         Nodes.y = [0,L]';
         Nodes.Locked = [1 1 1; 0 0 0];
         
         Bars.Conn = [1 2];
         Bars.Material = [1];
         Bars.Locked = ~~[1 1];
         
         Materials(1).E = 1000;
         Materials(1).I = 3;
         Materials(1).A = 5;
         
      case 3 % the roof
         Nodes.x = [0 3 7  7]';
         Nodes.y = [0 1 0 -2]';
         Nodes.Locked = [0 1 0; 0 0 0; 0 0 0; 1 1 1];
         
         Bars.Conn = [1 2; 2 3; 3 4];
         Bars.Material = [1 1 2]';
         Bars.Locked = [1 1; 1 0; 0 1];
         
         Materials(1).E = 2.1e8;  % [kN/m^2]
         Materials(1).I = 2.5e-4; % [m^4]
         Materials(1).A = 1.5e-2; % [m^2]
         
         Materials(2).E = 2.1e8;  % [kN/m^2]
         Materials(2).I = 1e-3;   % [m^4]
         Materials(2).A = 1.5e-2; % [m^2]
         
         
         
         
      otherwise
         if CaseGeometry >= 10 && CaseGeometry <= 15
            % rotated-support testcases
            L = 3;
            q = 4; n= 0;
            Nodes.x = [0 4]';
            Nodes.y = [0 3]';
            Nodes.Locked = [1 1 0; 0 1 0];
            Nodes.LockRot = [0; 25];
            
            Bars.Conn = [1 2];
            Bars.Locked = ~~[1 1 0 1 1 1];
            Bars.LockRot = [0 0];
            Bars.LockCS = [1 2];
            Bars.Material = [1];
            
            Materials(1).E = 2.1e8;  % [kN/m^2]
            Materials(1).I = 2.5e-4; % [m^4]
            Materials(1).A = 1.5e-2; % [m^2]
            Materials(1).PltType = 1;
            
            if CaseGeometry == 11
               Nodes.Locked = [1 1 0; 1 0 0];
               Nodes.LockRot = [0; 115];
            end
            
            
         else
            error('undefined');
         end
   end
   
   % ------------------------------------------
   % loads
   
   BarLoad.Bar = [];
   BarLoad.CS = [];
   BarLoad.Load = [];
   
   BarEndLoad.Bar = [];
   BarEndLoad.CS = [];
   BarEndLoad.Load = [];
   BarEndLoad.End = [];
   
   NodalLoad.Node = [];
   NodalLoad.Load = [];
   
   if CaseGeometry == 0 && CaseLoad == 0 || CaseGeometry >= 10 && CaseGeometry <= 15
      BarLoad.Bar = 1;
      BarLoad.CS = 2;
      BarLoad.Load = [q q n n];
%       NodalLoad.Node = [2];
%       NodalLoad.Load = [0 -10 5];
%       
   elseif CaseGeometry == 1 && CaseLoad == 1
      NodalLoad.Node = [2];
      NodalLoad.Load = [1 -3 0];
   elseif CaseGeometry == 2 && CaseLoad == 3
      BarLoad.Bar = 1;
      BarLoad.CS = [1];
      BarLoad.Load = [10 10 0 0];
      
   elseif CaseGeometry == 2 && CaseLoad == 1
      NodalLoad.Node = [2];
      NodalLoad.Load = [7 8 0];
   elseif CaseGeometry == 2 && CaseLoad == 2
      NodalLoad.Node = [2];
      NodalLoad.Load = [-8 7 0];
      
   elseif CaseGeometry == 3 && CaseLoad == 1
      NodalLoad.Node = [2 3];
      NodalLoad.Load = [2 -10 0; 5 0 0];
   elseif CaseGeometry == 3 && CaseLoad == 2
      NodalLoad.Node = [2];
      NodalLoad.Load = [0 0 20];
      
      
   elseif CaseGeometry == 3 && CaseLoad == 3
      BarLoad.Bar = [1:3]';
      BarLoad.CS = [1 3 2];
      BarLoad.Load = [15 3 0 0; 13 2 0 0; 2 4 0 0];
      
%       BarLoad.Bar = 1;
%       BarLoad.CS = 3;
%       BarLoad.Load = [2 2 0 0];
      
   elseif CaseLoad == -1
      % special test-case to return an empty data-structure
   else
      error('undefined');
   end
   
   Nodes.nN = numel(Nodes.x);
   Bars.nB = numel(Bars.Material);

   sys.Nodes = Nodes;
   sys.Bars = Bars;
   sys.Materials = Materials;
   load.NodalLoad = NodalLoad;
   load.BarLoad = BarLoad;
   load.BarEndLoad = BarEndLoad;


   [sys, load] = F2d_InputUpgradeFormat(sys, load);

end