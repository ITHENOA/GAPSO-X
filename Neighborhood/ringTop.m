function Nidx = ringTop(xidx)
global Aidx

shuffle = sort(Aidx);
if xidx == shuffle(1)
    Nidx = [shuffle(2) shuffle(end)];
elseif xidx == shuffle(end)
    Nidx = [shuffle(1) shuffle(end-1)];
else 
    id = find(shuffle == xidx);
    Nidx = [shuffle(id-1) shuffle(id+1)];
end
