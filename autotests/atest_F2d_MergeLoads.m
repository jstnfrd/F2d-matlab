function atest_F2d_MergeLoads
   
   
   tcVec = [1 2];
   
   for i = 1:numel(tcVec)
      tc = tcVec(i);
      okVec(i) = runtest(tc);
   end
   
   [varargout{1:nargout}] = atest_ProcessResults(tcVec, okVec);
end

function ok = runtest(tc)
   
   if tc == 1
      loads_A.foo = [1;2];
      loads_B.foo = [11:12]';
      loads_ref.foo = [1 2 11:12]';
   elseif tc == 2
      loads_A.foo.x = [3 4];
      loads_B.foo.x = [99 11];
      loads_A.foo.y = [3.4];
      loads_B.foo.y = [4.3];
      loads_A.bar = [1 1];
      loads_B.bar = [0 0];
      
      
      loads_ref.foo.x = [3 4; 99 11];
      loads_ref.foo.y = [3.4; 4.3];
      loads_ref.bar = [1 1; 0 0];
      
   else
      erorr('no such testcase: %i', tc);
   end
   [ loads_is ] = F2d_MergeLoads( loads_A, loads_B );
   
   
   
   
   ok = compareStructsTol(loads_ref, loads_is, 0, 'loads');
   
   
end