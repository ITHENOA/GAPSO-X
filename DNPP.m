function dnpp = DNPP(X, x, pop, saveIdx)%(i,it)
global it itMax d
global dnppCS MtxCS moiCS rand_cauchy_dnpp

for k = unique([x.I.idx, x.idx]); S(k) = 1; end
if moiCS == 2; S(x.I.idx) = x.I.weight; end % MOI(RANKED)

dnpp = zeros(1,d);   
switch dnppCS
    case 0  % rectangular ------------------------------------------------- 
        % disp("dnpp ==> rectangular")
        for k = x.I.idx
            if k == x.idx
                dnpp = dnpp + x.phi(1) * S(k) * Mtx((x.prtInfo - x.pos), pop, saveIdx);%mew  
            else
                dnpp = dnpp + X(k,it).phi(2) * S(k) * Mtx((X(k,it).prtInfo - x.pos), pop, saveIdx);%mew  
            end
        end 

    case 1  % spherical ---------------------------------------------------
        % disp("dnpp ==> spherical")
        P = 0;
        L = x.pos;
        P = x.pos + x.phi(1) * S(k) * Mtx((x.prtInfo - x.pos), pop, saveIdx); 
        for k = setdiff(x.I.idx, x.idx)
            L = L + X(k,it).phi(2) * S(k) * Mtx((X(k,it).prtInfo - x.pos), pop, saveIdx);
        end 
        C = (x.pos + L + P)/3;
        R = norm(C - x.pos);
        H = hipersphericalDist(C,R,d);
        dnpp = H - x.pos;

    case 2  % standard ----------------------------------------------------
        % disp("dnpp ==> standard")
        for k = x.I.idx
            q = (x.phi(1) * S(x.idx) * x.prtInfo + x.phi(2) * S(x.idx)...
                * X(k,it).prtInfo ) / (x.phi(1) * S(x.idx) + x.phi(2) * S(x.idx));
            dnpp = dnpp + q - x.pos;
        end

    case 3  % gaussian ----------------------------------------------------
        % disp("dnpp ==> gaussian")
        % if MtxCS ~= 0; error("forbidden in gaussian DNPP"); end
        for k = x.I.idx
            c = (x.prtInfo + X(k,it).prtInfo)/2;
            r = norm(x.prtInfo - X(k,it).prtInfo);
            q = normrnd(c,r);
            dnpp = dnpp + q - x.pos;
        end

    case 4  % discrete ----------------------------------------------------
        % disp("dnpp ==> discrete")
        % if MtxCS ~= 0; error("forbidden in discrete DNPP"); end
        nu = randi([0 1]); % U{0,1}
        for k = x.I.idx
            q = nu * x.prtInfo + (1-nu) * X(k,it).prtInfo;
            dnpp = dnpp + q - x.pos;
        end

    case 5  % cauchy gaussian ---------------------------------------------
        % disp("dnpp ==> cauchy gaussian")
        % if MtxCS ~= 0; error("forbidden in cauchy gaussian DNPP"); end  
        for k = x.I.idx
            q = zeros(1,d);
            for j = 1:d
                if rand <= rand_cauchy_dnpp
                    C = random(makedist('Stable','alpha',1,'beta',0,'gam',1,'delta',0)); % C(1): cauchy distribution
                    q(j) = x.pb.pos(j) + C * norm(x.prtInfo(j) - X(k,it).prtInfo(j));
                else
                    q(j) = X(k,it).pb.pos(j) + normrnd(0,1) * norm(x.prtInfo(j) - X(k,it).prtInfo(j));
                end
            end
            dnpp = dnpp + q - x.pos;
        end
end
        