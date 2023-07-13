function rc = fix_ring_connection(Aidx)

% % update ring
% for i = Aidx
%     trust_ring = ringTop(i);
%     X(i,it).N.idx = unique([X(i,it-1).N.idx, trust_ring]);
% end

% remain_connection (rc) : Allowed remain connections to delete
popSize = numel(Aidx);
rc1=[];
for i = Aidx
    rc1 = [rc1 ; ones(popSize,1)*i];
end
rc2=[];
for i = 1:popSize
    rc2 = [rc2 ; Aidx'];
end 
rc = [rc1 rc2];

% remove equals connections (5 <=> 5)
rc(rc(:,1) == rc(:,2),:) = [];  
% removes nearby connections (4 <=> 5)
rc(abs(rc(:,1) - rc(:,2)) == 1,:) = []; 
% remove one of same connections (4 <=> 5) (5 <=> 4)
i=1;
while true  
    if sum(prod(rc(i,:) == rc(:,2:-1:1),2))
        rc(i,:) = [];   
    else
        i=i+1;
    end
    if i > size(rc,1) ;break;end
end
% remove (1 <=> end) or (end <=> 1)
rc(find(prod(rc == [1 max(Aidx)] | rc == [max(Aidx) 1],2)),:) = []; % dont remove find syntax