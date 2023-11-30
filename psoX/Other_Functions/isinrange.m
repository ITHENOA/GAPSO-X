function out = isinrange(pos,bound)
% check pos in range(out=1) or not(out=0)

% INPUT
% pos:      (nPos, dim): positions
% bound:    (dim,[lb,ub]): boundary

% OUTPUT
% out:      (lagical)

out = prod(pos' >= bound(:,1) & pos' <= bound(:,2));