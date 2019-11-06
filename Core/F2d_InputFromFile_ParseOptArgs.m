function res = F2d_InputFromFile_ParseOptArgs(line)
   % parse optional arguments from a line
   
   res = struct();
   
   tok = regexp(line, '[\w]+:\[[\d\-\+.e ]*\]|[\w]+:[\d\-\+.e]*', 'match');
   
   for tok_ = tok
      tok1 = tok_{1};
      tok2 = strsplit(tok1, ':');
      if numel(tok2) == 2
         res.(tok2{1}) = str2num(tok2{2});
      end
   end
end