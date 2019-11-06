function atest_F2d_InputFromFile_ParseOptArgs
   
   testVec = [2];
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
         line = '  ';
         out_ref = struct();
         
      case 2
         line = 'm:2  cs:[1 2]  r:[90 1.5] ';
         out_ref.m = 2;
         out_ref.cs = [1 2];
         out_ref.r = [90 1.5];
      otherwise
         error('TC not defined')
   end
   
   out_is = F2d_InputFromFile_ParseOptArgs(line);
   res = compareStructsTol(out_is, out_ref,0);
   compareStructsTol(out_ref, out_is,0);
end