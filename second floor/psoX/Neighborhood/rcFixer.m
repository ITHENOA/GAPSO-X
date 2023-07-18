function rc = rcFixer(rc)
global Aidx

% remove equals connections (5 <=> 5)
rc(rc(:,1) == rc(:,2),:) = [];  
% removes nearby connections (4 <=> 5)
rc(abs(rc(:,1) - rc(:,2)) == 1,:) = []; 
% remove one of same connections (4 <=> 5) (5 <=> 4)
if size(rc,1)==0; return; end
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
rc(find(prod(rc == [min(min(rc)) max(max(rc))] | rc == [max(max(rc)) min(min(rc))],2)),:) = []; % dont remove find syntax
%
% while true
%     same_connections = prod(rc(1,:) == rc(2:end,:),2);
%     if sum(same_connections) == 0; break; end
%     rc(logical([0; same_connections]),:) = [];
% end