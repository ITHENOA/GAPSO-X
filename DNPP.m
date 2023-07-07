function DNPP(option,x,pb,I,pop)
global it itMax
global MtxCS

switch option
    case 0  % rectangular
        idxI = zeros(size(I,1),1);
        for k = 1:size(I,1)
            idxI(k) = find(prod(pop.pos(:,:,it) == I(k,:),2));
        end
        popSize = sum(pop.fit(:,it) ~= inf);
        
        sumation = 0;
        for i = 1:popSize
            phi = AC(it,itMax,gb.fit(it),pop.fit(i,it));
            if sumation(idxI == i)
                sumation = sumation + phi(1)
            else
                sumation = sumation + phi(2)
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
        