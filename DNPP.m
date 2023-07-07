function dnpp = DNPP(x,pb,I,pop)
global it itMax
global dnppCS MtxCS

switch dnppCS
    case 0  % rectangular   
        dnpp_I = phi(1) * Mtx((prtInf(pb.pos(x.I.idx,:),x,pm,gb) - x.pos),d,pop);
        otherIdx = [];
        % for i = 1:x.N.size
        %     if ~sum(x.N.idx(i) == x.I.idx)
        %         otherIdx = [otherIdx, x.N.idx(i)];
        %     end
        % end
        % dnpp2 = phi(2) * Mtx((prtInf(pb.pos(otherIdx,:),x,pm,gb) - x.pos),d,pop);
        dnpp_other = phi(2) * Mtx((prtInf(pb.pos(setdiff(x.N.idx,x.I.idx),:),x,pm,gb) - x.pos),d,pop);
        dnpp = dnpp_I + dnpp_other;
        %
        idxI = zeros(size(I,1),1);
        for k = 1:size(I,1)
            idxI(k) = find(prod(pop.pos(:,:,it) == I(k,:),2));
        end
        popSize = sum(pop.fit(:,it) ~= inf);
        
        sumation = 0;
        for i = 1:popSize
            phi = AC(it,itMax,x.lb.fit,x.fix,gb);
            % bga rftim 
            % solve1: x(i).lb.fit,... 
            % solve2: a grate matrix [x,fit,lbfit]
            % solve3: after i loop in main -> X(it) = x
            % solve4: end of i loop in main --> pop.lb.fit(i,it) =
                        % x.lb.fit   ->   removed particle?
            if sum(idxI == i)
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
        