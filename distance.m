function best_idx = distance(pop,xi,num)
dis = sqrt(sum((xi-pop).^2,2))/max(sqrt(sum((xi-pop).^2,2)));
[~,idx] = sort(dis);
best_idx = idx(1:num);