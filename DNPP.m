function DNPP(option,x,pb,I,pop)
global MtxCS

switch option
    case 0  % rectangular
        idx = zeros(size(I,1),1);
        for k = 1:size(I,1)
            idx(k) = find(prod(pop.pos(:,:,it) == I(k,:),2));
        end
        popSize = sum(pop.fit(:,it) ~= inf);
        for i = 1:popSize
            if idx == i
                phi1
            else
                phi2
            end
        end

    case 1  % spherical
    case 2  % standard
        MtxCS = 0;
    case 3  % gaussian
        MtxCS = 0;
    case 4  % discrete
        MtxCS = 0;
    case 5  % cauchy gaussian
        MtxCS = 0;
end
        