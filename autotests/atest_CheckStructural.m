function ok = atest_CheckStructural()
   
   Param = atest_GetParams();
   
   for tc = Param.tcVec
      tc
      res_is = atest_SolveStructural(tc);
      loaded = load(sprintf(Param.FileNameRefData, tc), 'res');
      res_ref = loaded.res;
      
      if nargout == 0
         compareStructsTol(res_ref, res_is);
      else
         ok = compareStructsTol(res_ref, res_is);
      end
   end
end