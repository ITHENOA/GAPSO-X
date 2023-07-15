function pos = boundCheck(pos,bound)
for dim = 1:size(bound,1)
    pos(dim) = max(bound(dim,1),pos(dim));
    pos(dim) = min(bound(dim,2),pos(dim));
end
