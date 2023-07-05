function I = MOI( N, xi, fits)   % ok+1
global moiCS

switch moiCS
    case 0  % best of neighborhood  ok
        [~,idx] = min(fit);
        I(1,:) = N(idx,:);
        I(2,:) = xi;

    case 1 % fully informed     ok
        I = N;

    case 2 % weighted ranking       ok
        [~,idx] = sort(fits);
        lowerPart=2^(size(N,1))-1;
        upperPart=zeros(1,size(N,2));
        for i=0:size(N,1)-1
            upperPart(i+1)=2^(size(N,1)-1-i);
        end
        w = upperPart/lowerPart;
        I=[N,w(idx)']; % last column is weight

    case 3 % random informant   +1
        I = N(randi(size(N,1)),:);
end
