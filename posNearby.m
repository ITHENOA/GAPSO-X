function inpos = posNearby(pos,x)

dim = numel(pos);
inpos = zeros(1,dim);
for i = 1:dim
    [~, idx] = min(abs(x{i} - pos(i)));
    inpos(i) = x{i}(idx);
end