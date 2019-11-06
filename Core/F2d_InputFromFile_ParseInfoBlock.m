function [fmtVersion] = F2d_InputFromFile_ParseInfoBlock(filename)
   % parse the Info-block of the file
   
   lines = strsplit(fileread(filename), '\r\n');

   block_entered = false;
   
   iL = 1;
   while iL < numel(lines)
      line = lines{iL};
      %fprintf('%02i: [%s]\n', iL, lines{iL})
      if startsWith(line, '## Info')
         %disp('> parsing info block')
         block_entered = true;
         
      elseif startsWith(line, '## /Info')
         assert(block_entered, 'file structure messed up')
         return
      elseif startsWith(line, '##')
         fmtVersion = 1;
         
         
      elseif block_entered && startsWith(line, '# Format:')
         str_ver = strsplit(line, ':');
         fmtVersion = str2double(str_ver{2});
      end
      
      iL = iL + 1;
   end
end