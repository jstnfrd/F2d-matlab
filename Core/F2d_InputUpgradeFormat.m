function [sys, load] = F2d_InputUpgradeFormat(sys, load)
   % upgrade a data-struct to the latest format (and ensure optional fields
   % exist)
   
      
   % expand arrays from old to new format
   if size(sys.Nodes.Locked, 2) == 2
      sys.Nodes.Locked = [zeros(sys.Nodes.nN,2) sys.Nodes.Locked(:,1) zeros(sys.Nodes.nN,2) sys.Nodes.Locked(:,2)];
   end

   
   % ------------------------------------------
   % add default info, if not specified
   if ~isfield(sys.Nodes, 'PltInfo')
      sys.Nodes.PltInfo = zeros(sys.Nodes.nN,1);
   end
   
   if ~isfield(sys.Nodes, 'LockRot') % rotation of supports
      sys.Nodes.LockRot = false(sys.Nodes.nN,1);
   end
   
   if ~isfield(sys.Bars, 'LockRot') % rotation of supports
      sys.Bars.LockRot = false(sys.Bars.nB,2);
   end
   
   if ~isfield(sys.Bars, 'LockCS') % rotation of supports
      sys.Bars.LockCS = zeros(sys.Bars.nB,2) + 2;
   end
   
   % XXX: move sys.Bars.PltType to material properties (create materials as
   % needed for this)
end