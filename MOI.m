function I = MOI( N, x, pop,it,d)   % ok+1
global moiCS

switch moiCS
    case 0  % best of neighborhood  ok
        I.pos = [x.pos; pop.pos(best,:,it)];   % self and best of N
        I.fit = [x.fit; pop.fit(best,it)];
        I.size = 2;
        I.idx = [x.idx best];%  ??
        % [~,idx] = min(fit);
        % I(1,:) = N(idx,:);
        % I(2,:) = xi;

    case 1 % fully informed     ok
        I = N; % I <== N.(pos & fit & idx & size)

    case 2 % weighted ranking       ok
        [~,idx] = sort(fits);???
        lowerPart=2^(x.N.size)-1;%size(N,1)
        upperPart=zeros(1,d);%size(N,2)
        for i=0:x.N.size-1%size(N,1)-1
            upperPart(i+1)=2^(x.N.size-1-i);%size(N,1)-1
        end
        w = upperPart/lowerPart;
        % I=[N,w(idx)']; % last column is weight
        I = N; % I <== N.(pos & fit & idx & size)
        I.weight = ??? size(idx)~=size(N)? sort?
        

    case 3 % random informant   +1
        I = N(randi(size(N,1)),:);%?? chanta? -> tedad random[1:size(n)] va indx random? 
end
