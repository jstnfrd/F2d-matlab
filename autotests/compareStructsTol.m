function varargout = compareStructsTol(A, B, tol, ParentField)
   % compare data of both structs `A` and `B` if their fields are identical to
   % an absolute tolerance `tol`.
   
   if nargin < 3 || isempty(tol)
      tol = 1e-10;
   end
   
   if nargin < 4 || isempty(ParentField)
      ParentField = '';
   end
   
   %#ok<*AGROW>
   
   assert(all(size(A) == size(B)), sprintf('%s: sizes do not match. A:[%ix%i], B:[%ix%i]', ParentField, size(A), size(B)));
   
   if isnumeric(A) || islogical(A)
      [varargout{1:nargout}] = compareNumeric(A, B, tol, ParentField);
      return
   end

   for i = 1:numel(A)
      %assert(numel(fieldnames(A(i))) <= numel(fieldnames(B(i))), 'number of fields must be equal');
      Fields = fieldnames(A(i));
      
      for j = 1:numel(Fields)
         if numel(A) == 1
            FullFieldName = [ParentField '.' Fields{j}];
         else
            FullFieldName = [ParentField sprintf('(%i)',i) '.' Fields{j}];
         end
         assert(isfield(B(i), Fields{j}), sprintf('%s: fieldname not found in B', Fields{j}));
         a = A(i).(Fields{j});
         b = B(i).(Fields{j});
         
         if isstruct(a)
            [varargout{1:nargout}] = compareStructsTol(a, b, tol, FullFieldName);
         else
            [varargout{1:nargout}] = compareNumeric(a, b, tol, FullFieldName);
         end
      end
   end
end

function s = fmtNumeric(x)
%    if all(int64(x) == x)
%       s = sprintf('%+i ', x);
%    else
%       s = sprintf('%+e ', x);
%    end
   s = evalc('disp(x)');
   %s(end) = []; % remove \n
end


function varargout = compareNumeric(a, b, tol, FullFieldName)
   
   assert(all(size(a) == size(b)), sprintf('%s: sizes do not match. A:[%ix%i], B:[%ix%i]', FullFieldName, size(a), size(b)));
   
   % TODO: consider NaN-entries too
   ok = all(abs(a - b) <= tol);
   if ~ok
      msg = sprintf('%s: values do not match\n', FullFieldName);
      msg = [msg 'A:   ' newline fmtNumeric(a)];
      msg = [msg 'B:   ' newline fmtNumeric(b)];
      msg = [msg 'A-B: ' newline fmtNumeric(a-b)];
      
      if nargout == 0
         error(msg);
      else
         warning(msg);
         varargout = {false};
      end
   else
      varargout = {true};
   end
   
end