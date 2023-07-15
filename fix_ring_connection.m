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

rc = rcFixer(rc);