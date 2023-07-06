function w1 = inertiaW1(w1,gb,x,v, bound,pop)   % abv?
global itMax it 
global inertiaW1CS
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv

switch inertiaW1CS
    case 0 % cte
        w1 = [w1 ; inertia_cte];

    case 1 % linear decreasing
        w1 = [w1 ; w1Max - (w1Max - w1Min) * it/itMax];

    case 2 % linear increasing 
        w1 = [w1 ; w1Min + (w1Max - w1Min) * it/itMax];

    case 3 % random
        w1 = [w1 ; 0.5 + rand / 2];

    case 4 % self-regulating
        dw = (w1Max - w1Min)/itMax;
        if x.pb == gb.fit(it)
            w1 = w1(end) + nu * dw;
        else
            w1 = w1(end) - dw;
        end

    case 5 % adaptive based on velocity (abv)
        popSize = sum(pop.fit(:,it) ~= inf);
        vBar = 1/popSize/d * sum(sum(abs(v(:,:,it))));
        vIdial = norm((bound(:,1)-bound(:,2))/2) * (1+cos(pi/0.95/itMax))/2; % norm! :\
        if vBar >= vIdial
            w1 = [w1 ; max(w1(end) - lambda_w1_abv, w1Min)];
        else
            w1 = [w1 ; max(w1(end) + lambda_w1_abv, w1Min)];
        end

    case 6 % double exponential self-adaptive
        R = norm(gb.pos(it,:)-x.pos) * (itMax-it)/itMax;
        w1 = [w1 ; exp(-exp(-R))];

    case 7 % rank-based
        [rank,~] = find(pop.pos == x.pos);
        popSize = sum(pop.fit(:,it) ~= inf);
        w1 = [w1 ; w1Max - (w1Max-w1Min) * rank/popSize];

    case 8 % success-based
        popSize = sum(pop.fit(:,it) ~= inf);
        S = sum(pop.fit(:,it) < min(pop.fit(:,1:it-1),[],2));
        w1 = [w1 ; w1Min + (w1Max - w1Min) * S/popSize];
         
    case 9 % convergence-based  (cb)
        C = abs(min(pop.fit(:,1:it-1),[],2) - min(pop.fit(:,1:it),[],2))...
            /(min(pop.fit(:,1:it-1),[],2) - min(pop.fit(:,1:it),[],2));
        D = abs(min(pop.fit(:,1:it),[],2) - gb.fit(it))...
            /(min(pop.fit(:,1:it),[],2) - gb.fit(it));
        w1 = [w1 ; 1 - abs((a_w1_cb-C)/(1+D)/(1+b_w1_cb))];

end