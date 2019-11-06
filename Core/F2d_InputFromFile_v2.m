function [sys, load] = F2d_InputFromFile_v2(filename)
   
   lines = strsplit(fileread(filename), '\r\n');
   
   defined_nodes = false;
   defined_Bars = false;
   defined_nodalloads = false;
   defined_Barloads = false;
   
   iL = 1;
   while iL < numel(lines)
      
      %fprintf('%02i: [%s]\n', iL, lines{iL})
      if startsWith(lines{iL}, '## Nodes')
         %disp('> parsing Nodes')
         [sys.Nodes, skiplines] = ParseNodes(lines(iL:end));
      elseif startsWith(lines{iL}, '## Bars')
         %disp('> parsing Bars')
         [sys.Bars, skiplines] = ParseBars(lines(iL:end));
      elseif startsWith(lines{iL}, '## Materials')
         %disp('> parsing Materials')
         [sys.Materials, skiplines] = ParseMaterials(lines(iL:end));
      elseif startsWith(lines{iL}, '## NodalLoads')
         %disp('> parsing NodalLoads')
         [load.NodalLoad, skiplines] = ParseNodalLoads(lines(iL:end));
      elseif startsWith(lines{iL}, '## BarLoads')
         %disp('> parsing BarLoad')
         [load.BarLoad, skiplines] = ParseBarLoads(lines(iL:end));
      elseif startsWith(lines{iL}, '## BarEndLoads')
         %disp('> parsing BarEndLoad')
         [load.BarEndLoad, skiplines] = ParseBarEndLoads(lines(iL:end));
      else 
         skiplines = 1;
      end
      
      iL = iL + skiplines;
   end
   
end


function [Nodes, iL] = ParseNodes(lines)
   
   Nodes.x = zeros(0,1);
   Nodes.y = zeros(0,1);
   Nodes.Locked = false(0,3);
   Nodes.LockRot = zeros(0,1);
   Nodes.LockStiff = zeros(0,3);
   
   Defaults.Locked = ~~[0 0 0];
   Defaults.LockRot = 0;
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = line2nums(line);
         
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
            Nodes.LockRot(end+1,:) = Defaults.LockRot;
         end
         
         % optional parameters
         opts = F2d_InputFromFile_ParseOptArgs(line);
         Nodes.LockStiff(end+1,:) = getFieldOrDefault(opts, 'k', [0 0 0]);
      
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
   
   Bars.Conn     = zeros(0,2);
   Bars.Locked   = false(0,6);
   Bars.LockRot  = zeros(0,2);
   Bars.LockCS   = zeros(0,2);
   Bars.LockStiff= zeros(0,6);
   Bars.Material = zeros(0,1);
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = line2nums(line);
         
         % connectivity
         Bars.Conn(end+1,:) = vec(1:2);
         
         % locked?
         % [ux-i uy-i phi-i ux-j uy-j phi-j]
         if numel(vec) == 2
            % all defaults
            Bars.Locked(end+1,:) = [1 1 1 1 1 1];
         elseif numel(vec) == 4
            % phi-i, phi-j defined
            Bars.Locked(end+1,:) = [1 1 vec(3) 1 1 vec(4)];
         elseif numel(vec) == 8
            Bars.Locked(end+1,:) = [vec(3:8)];
         else
            error('could not parse this line with wrong length: %s', line)
         end
         
         % optional parameters
         opts = F2d_InputFromFile_ParseOptArgs(line);
         Bars.LockCS(end+1,:) = getFieldOrDefault(opts, 'cs', [2 2]);
         Bars.LockRot(end+1,:) = getFieldOrDefault(opts, 'r', [0 0]);
         Bars.LockStiff(end+1,:) = getFieldOrDefault(opts, 'k', [0 0 0 0 0 0]);
         Bars.Material(end+1,:) = getFieldOrDefault(opts, 'm', [1]);
         
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
   Materials.PltInfo = NaN;
   idx = 1;
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = line2nums(line);
         
         Materials(idx).E = vec(1);
         Materials(idx).I = vec(2);
         Materials(idx).A = vec(3);
         
         if numel(vec) > 3
            Materials(idx).PltInfo = vec(4);
         end
         
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
         vec = line2nums(line);
         
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
         vec = line2nums(line);
         
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
            
      
      elseif startsWith(line, '## /BarLoads')
         return
      elseif startsWith(line, '##')
            error('could not finish parsing BarLoad')
      end
   end
   error('could not finish parsing BarLoad')
end

function [BarEndLoad, iL] = ParseBarEndLoads(lines)
   
   BarEndLoad.Bar  = zeros(0,1);
   BarEndLoad.CS   = zeros(0,1);
   BarEndLoad.End  = zeros(0,1);
   BarEndLoad.Load = zeros(0,3);
   
   Defaults.Load = [0 0 0];
   
   for iL = 2:numel(lines)
      line = lines{iL};
      if ~startsWith(line, '#') && ~isempty(line)
         vec = line2nums(line);
         
         BarEndLoad.Bar(end+1,:) = vec(1);
         BarEndLoad.End(end+1,:) = vec(2);
         BarEndLoad.CS(end+1,:)  = vec(3);


         if numel(vec) == 5 % M=0
            BarEndLoad.Load(end+1,:) = [vec([4 5]) Defaults.Load(end)];
         elseif numel(vec) == 6
            BarEndLoad.Load(end+1,:) = vec(4:6);
         else
            error('problem parsing this line')
         end
            
      elseif startsWith(line, '## /BarEndLoads')
         return
      elseif startsWith(line, '##')
            error('could not finish parsing BarEndLoads')
      end
   end
   error('could not finish parsing BarEndLoads')
end


function nums = line2nums(line)
   % parse a line and return numbers, w/o optional arguments
   
   % cut off optional arguments (if any)
   strs = regexp(line, '^[\d\-\+.e\s]*', 'match');
   nums = str2num(strs{1});
end


function res = getFieldOrDefault(s, f, d)
   if isfield(s, f)
      res = s.(f);
   else
      res = d;
   end
end
