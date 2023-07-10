function I = MOI(x)   % ok+1
global moiCS

switch moiCS
    case 0  % best of neighborhood 
        disp("Model of Influence ==> Best of Neighborhood")
        if x.idx ~= x.N.idx(1)  % joz N fully and timevar i jozv N nist
            I.pos = [x.pos; x.N.pos(1,:)];
            I.fit = [x.fit x.N.fit(1)];
            I.idx = [x.idx x.N.idx(1)];
            I.size = 2;
        else 
            I.pos = x.pos;   % self == best of N
            I.fit = x.fit;
            I.size = 1;
            I.idx = x.idx;
        end

    case 1 % fully informed     ok
        disp("Model of Influence ==> Fully Informed")
        I = x.N; % I <== N.(pos & fit & idx & size)

    case 2 % Weighted Ranking       ok
        disp("Model of Influence ==> Weighted Ranking")
        lowerPart=2^(x.N.size)-1;
        upperPart=zeros(1,x.N.size);
        for i=0:x.N.size-1
            upperPart(i+1)=2^(x.N.size-1-i);
        end
        w = upperPart/lowerPart;
        I = x.N; % I <== N.(pos & fit & idx & size)
        I.weight = w;
        

    case 3 % Random Informant   +1
        disp("Model of Influence ==> Random Informant")
        idx = randperm(x.N.size,2);
        I.pos = x.N.pos(idx,:);
        I.fit = x.N.fit(idx);
        I.idx = x.N.idx(idx);
        I.size = 2;
end
