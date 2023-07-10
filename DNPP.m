function dnpp = DNPP(x, pop, prtInfo, phi, saveIdx)%(i,it)
global it itMax d
global dnppCS MtxCS

switch dnppCS
    case 0  % rectangular   
        dnpp = zeros(1,d);
        for i = x.I.idx
            if i == x.idx
                dnpp = dnpp + phi(1) * Mtx((prtInfo - x.pos), pop, saveIdx);         
            else
                dnpp = dnpp + phi(2) * Mtx((prtInfo - x.pos), pop, saveIdx);
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
        