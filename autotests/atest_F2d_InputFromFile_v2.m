function atest_F2d_InputFromFile_v2()
   clc
   
   testVec = [1];
   resVec = numel(testVec);
   
   for i = 1:numel(testVec)
      resVec(i) = runSingle(testVec(i));
   end
   
   resVec
   assert(all(resVec))
   
   
end

function res = runSingle(tc)
   
   switch tc
      case 1
         filename = './inputs/t_v2_tc1.inp';
         sys_ref.Nodes.x = [0 5 0]';
         sys_ref.Nodes.y = [0 0 3.3]';
         sys_ref.Nodes.Locked = ~~[0 1 0; 1 1 1; 1 0 0];
         sys_ref.Nodes.LockRot = [0 -5 33.3]';
         sys_ref.Nodes.nN = 3;
         sys_ref.Nodes.LockStiff = [11 2.5e4 -0; -1 2 3; 0 0 0]; 
         
         sys_ref.Bars.Conn = [1 2; 2 3; 3 1];
         sys_ref.Bars.Locked = ...
            ~~[1 1 1 1 1 1; 1 1 1 1 1 0; 1 0 1 0 0 1];
         sys_ref.Bars.Material = [2 1 1]';
         sys_ref.Bars.LockCS = [2 2; 2 1; 2 2];
         sys_ref.Bars.LockRot = [30 45; 0 0; 9 91];
         sys_ref.Bars.LockStiff = [1e8 Inf 0 0 0 0; 0 0 0 0 0 0; 0 0 0 2 4 8];
         
         sys_ref.Materials(1).E = 2.1e8;
         sys_ref.Materials(1).I = 2.5e-4;
         sys_ref.Materials(1).A = 1.5e-2;
         sys_ref.Materials(1).PltInfo = 1;
         sys_ref.Materials(2).E = 2.1e8;
         sys_ref.Materials(2).I = 1e-3;
         sys_ref.Materials(2).A = 1.5e-2;
         sys_ref.Materials(2).PltInfo = 2;
         
         load_ref.NodalLoad.Node = [1;3;2];
         load_ref.NodalLoad.Load = [12 12 0; -14 15 0; 0 13 -5.1];
         
            %   .Bar  [nBLx1]: pointer to bar (bars can be referenced multiple times)
   %   .CS   [nBLx1]: coord sys: 1=fiber, 2=global, 3=projective
   %   .Load [nBLx4]:
   
         load_ref.BarLoad.Bar = [1;3];
         load_ref.BarLoad.CS = [2;3];
         load_ref.BarLoad.Load = [3.5 3.5 0 0; 4.5 0 2 -2];
         
         load_ref.BarEndLoad.Bar = [2;3];
         load_ref.BarEndLoad.End = [1;2];
         load_ref.BarEndLoad.CS = [2;1];
         load_ref.BarEndLoad.Load = [1.2 -3 4.5; -1.2 45 0];
         
      otherwise
         error('tc not defined')
   end
 
   
   [sys_is, load_is] = F2d_InputFromFile_v2(filename);
   
   res_sys = compareStructsTol(sys_ref, sys_is,1e-12);
   res_load = compareStructsTol(load_ref, load_is,1e-12);
   
   res = res_sys && res_load;
   
end
