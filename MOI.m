function I = MOI(x)   % ok+1
global moiCS

switch moiCS
    case 0  % best of neighborhood 
        if x.idx ~= x.N.idx(1)?  % joz N fully and timevar i jozv N nist
            I.pos = [x.pos; x.N.pos(1,:)];
            I.fit = [x.fit x.N.fit(1)];
            I.idx = [x.idx x.N.idx(1)];
            % I.pos = [x.pos; pop.pos(best,:,it)];   % self and best of N
            % I.fit = [x.fit; pop.fit(best,it)];
            I.size = 2;
            % I.idx = [x.idx best];
        else 
            I.pos = x.pos;   % self == best of N
            I.fit = x.fit;
            I.size = 1;
            I.idx = x.idx;
        end

    case 1 % fully informed     ok
        I = x.N; % I <== N.(pos & fit & idx & size)

    case 2 % weighted ranking       ok
        lowerPart=2^(x.N.size)-1;
        upperPart=zeros(1,x.N.size);
        for i=0:x.N.size-1
            upperPart(i+1)=2^(x.N.size-1-i);
        end
        w = upperPart/lowerPart;
        I = x.N; % I <== N.(pos & fit & idx & size)
        I.weight = w;
        

    case 3 % random informant   +1
        idx = randperm(x.N.size,2);
        I.pos = x.N.pos(idx,:);
        I.fit = x.N.fit(idx);
        I.idx = x.N.idx(idx);
        I.size = 2;
end
