function inpos = posNearby(pos,x)
% INPUT
% pos:      (row) position
% x:        (cell) space division for each dimansion: x{dim} = [lb,..., ub] 
%               which length(x{dim}) == resolution(dim)

% OUTPUT
% inpos:    (row) possible position regard to resolutions 

dim = numel(pos);
inpos = zeros(1,dim);
for i = 1:dim
    [~, idx] = min(abs(x{i} - pos(i)));
    inpos(i) = x{i}(idx);
end