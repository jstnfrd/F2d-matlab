function [sys, load] = F2d_InputFromFile_v1(filename)
   
   lines = strsplit(fileread(filename), '\r\n');
   
   defined_nodes = false;
   defined_Bars = false;
   defined_nodalloads = false;
   defined_Barloads = false;
   
   iL = 1;
   while iL < numel(lines)
      
      %fprintf('%02i: [%s]\n', iL, lines{iL})
      if startsWith(lines{iL}, '## Nodes')
         disp('> parsing Nodes')
         [sys.Nodes, skiplines] = ParseNodes(lines(iL:end));
      elseif startsWith(lines{iL}, '## Bars')
         disp('> parsing Bars')
         [sys.Bars, skiplines] = ParseBars(lines(iL:end));
      elseif startsWith(lines{iL}, '## Materials')
         disp('> parsing Materials')
         [sys.Materials, skiplines] = ParseMaterials(lines(iL:end));
      elseif startsWith(lines{iL}, '## NodalLoads')
         disp('> parsing NodalLoads')
         [load.NodalLoad, skiplines] = ParseNodalLoads(lines(iL:end));
      elseif startsWith(lines{iL}, '## BarLoad')
         disp('> parsing BarLoad')
         [load.BarLoad, skiplines] = ParseBarLoads(lines(iL:end));
      else 
         skiplines = 1;
      end
      
      iL = iL + skiplines;
   end
   
end


function [Nodes, iL] = ParseNodes(lines)
   
   Nodes.x = zeros(0,1);
   Nodes.y = zeros(0,1);
   Nodes.Locked = ~~zeros(0,3);
   Nodes.LockRot = zeros(0,1);
   
   Defaults.Locked = ~~[0 0 0];
   Defaults.LockRot = 0;
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = strs2nums(strsplit(line));
         
         Nodes.x(end+1,:) = vec(1);
         Nodes.y(end+1,:) = vec(2);
         
         if numel(vec) > 2
            Nodes.Locked(end+1,:) = ~~vec(3:5);
         else
             Nodes.Locked(end+1,:) = Defaults.Locked;
         end
         
         if numel(vec) > 5
            Nodes.LockRot(end+1,:) = vec(6);
         else
            Nodes.LockRot(end+1,:) = Defaults.PltInfo;
         end
            
      
      elseif startsWith(line, '## /Nodes')
         Nodes.nN = numel(Nodes.x);
         return
      elseif startsWith(line, '##')
            error('could not finish parsing Nodes')
      end
   end
   error('could not finish parsing Nodes')
end


function [Bars, iL] = ParseBars(lines)
   
   Bars.Conn = zeros(0,2);
   Bars.Locked = zeros(0,2);
   Bars.Material = zeros(0,1);
   Bars.PltType = zeros(0,1);

   Defaults.Locked = ~~[1 1];
   Defaults.Material = 1;
   Defaults.PltType = 1;
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = strs2nums(strsplit(line));
         
         Bars.Conn(end+1,:) = vec(1:2);
         
         if numel(vec) > 2
            Bars.Locked(end+1,:) = ~~vec(3:4);
         else
            Bars.Locked(end+1,:) = Defaults.Locked;
         end
         
         if numel(vec) > 4
            Bars.Material(end+1,:) = vec(5);
         else
            Bars.Material(end+1,:) = Defaults.Material;
         end
         
         if numel(vec) > 5
            Bars.PltType(end+1,:) = vec(6);
         else
            Bars.PltType(end+1,:) = Defaults.PltType;
         end
      
      elseif startsWith(line, '## /Bars')
         Bars.nB = numel(Bars.Material);
         return
      elseif startsWith(line, '##')
            error('could not finish parsing Bars')
      end
   end
   error('could not finish parsing Bars')
end


function [Materials, iL] = ParseMaterials(lines)
   
   Materials.E = NaN;
   Materials.I = NaN;
   Materials.A = NaN;
   idx = 1;
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = strs2nums(strsplit(line));
         
         Materials(idx).E = vec(1);
         Materials(idx).I = vec(2);
         Materials(idx).A = vec(3);
         idx = idx + 1;
         
      elseif startsWith(line, '## /Materials')
         return
      elseif startsWith(line, '##')
            error('could not finish parsing Materials')
      end
   end
   error('could not finish parsing Materials')
end


function [NodalLoad, iL] = ParseNodalLoads(lines)
   
   NodalLoad.Node = zeros(0,1);
   NodalLoad.Load = zeros(0,3);
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = strs2nums(strsplit(line));
         
         NodalLoad.Node(end+1,:) = vec(1);
         NodalLoad.Load(end+1,:) = vec(2:4);
         
      elseif startsWith(line, '## /NodalLoads')
         return
      elseif startsWith(line, '##')
            error('could not finish parsing NodalLoads')
      end
   end
   error('could not finish parsing NodalLoads')
end


function [BarLoad, iL] = ParseBarLoads(lines)
   
   BarLoad.Bar = zeros(0,1);
   BarLoad.CS = zeros(0,1);
   BarLoad.Load = zeros(0,4);
   
   Defaults.Load = [0 0 0];
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = strs2nums(strsplit(line));
         
         BarLoad.Bar(end+1,:) = vec(1);
         BarLoad.CS(end+1,:) = vec(2);

         if numel(vec) == 3 % q=const, n=0
            BarLoad.Load(end+1,:) = [vec([3 3]) Defaults.Load(2:end)];
         elseif numel(vec) == 4 % q=linear, n=0
            BarLoad.Load(end+1,:) = [vec([3 4]) Defaults.Load(2:end)];
         elseif numel(vec) == 5 % q=linear, n=const
            BarLoad.Load(end+1,:) = vec([3 4 5 5]);
         elseif numel(vec) == 6 % q=linear, n=linear
            BarLoad.Load(end+1,:) = vec(3:6);
         else
            error('problem parsing this line')
         end
            
      
      elseif startsWith(line, '## /BarLoad')
         return
      elseif startsWith(line, '##')
            error('could not finish parsing BarLoad')
      end
   end
   error('could not finish parsing BarLoad')
end


function nums = strs2nums(strs)
   
   for i = 1:numel(strs)
      if ~isnan(str2double(strs{i}))
         nums(i) = str2double(strs{i});
      end
   end
end
