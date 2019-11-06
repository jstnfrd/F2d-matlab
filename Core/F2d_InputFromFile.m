function [sys, load] = F2d_InputFromFile(filename)
   
   [fmtVersion] = F2d_InputFromFile_ParseInfoBlock(filename);
   
   switch fmtVersion
      case 1
         [sys, load] = F2d_InputFromFile_v1(filename);
      case 2
         [sys, load] = F2d_InputFromFile_v2(filename);
      otherwise
         error('couldnt recognize file format')
   end
         
         
