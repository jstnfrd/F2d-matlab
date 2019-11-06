function atest_MakeRefSols
   
   input('Regenerating reference-solutions. Sure?')
   
   
   Param = atest_GetParams();
   
   for tc = Param.tcVec
      tc
      res = atest_SolveStructural(tc);
      save(sprintf(Param.FileNameRefData, tc), 'res')
   end
end