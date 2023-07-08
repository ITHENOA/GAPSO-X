function w1 = inertiaW1(old_w1,gb,x,bound,pop,X,saveIdx)   % abv?
% need old_w1 : 4=self-regulating , 5=abv 
% depend on i : 4=self-regulating , 6=desa , 7=rank , 8=success ,
% 9=convergence | 5=abv
global itMax it d Aidx
global inertiaW1CS
global inertia_cte w1Max w1Min nu a_w1_cb b_w1_cb lambda_w1_abv

switch inertiaW1CS
    case 0 % cte
        % w1 = [w1 ; inertia_cte];
        w1 = inertia_cte;

    case 1 % linear decreasing
        % w1 = [w1 ; w1Max - (w1Max - w1Min) * it/itMax];
        w1 = w1Max - (w1Max - w1Min) * it/itMax;

    case 2 % linear increasing 
        % w1 = [w1 ; w1Min + (w1Max - w1Min) * it/itMax];
        w1 = w1Min + (w1Max - w1Min) * it/itMax;

    case 3 % random
        % w1 = [w1 ; 0.5 + rand / 2];
        w1 = 0.5 + rand / 2;

    case 4 % self-regulating                                                depend on i
        dw = (w1Max - w1Min)/itMax;
        if x.pb.fit == gb.fit(it)
            w1 = old_w1 + nu * dw;
        else
            w1 = old_w1 - dw;
        end

    case 5 % adaptive based on velocity (abv)                               depend on i ?
        % popSize = sum(pop.fit(:,it) ~= inf);
        popSize = pop.size(it);
        vBar = 1/popSize/d * sum(sum(abs(pop.v(Aidx,:,it))));? % v?  =pop.v(it,:)  =x.v    =v(:,:,it)  ??
        vIdial = norm((bound(:,1)-bound(:,2))/2) * (1+cos(pi*(it+1)/0.95/itMax))/2; % norm! :\  %vIdial(it+1)
        if vBar >= vIdial
            % w1 = [w1 ; max(w1(end) - lambda_w1_abv, w1Min)];
            w1 = max(old_w1 - lambda_w1_abv, w1Min);
        else
            % w1 = [w1 ; max(w1(end) + lambda_w1_abv, w1Min)];
            w1 = max(old_w1 + lambda_w1_abv, w1Min);
        end

    case 6 % double exponential self-adaptive  (desa)                       depend on i 
        R = norm(gb.pos(it,:)-x.pos) * (itMax-it)/itMax;
        % w1 = [w1 ; exp(-exp(-R))];
        w1 = exp(-exp(-R));

    case 7 % rank-based                                                     depend on i 
        % [rank,~] = find(pop.pos == x.pos);
        [rank,~] = find(Aidx == x.idx);                                     ?
        % popSize = sum(pop.fit(:,it) ~= inf);
        % w1 = [w1 ; w1Max - (w1Max-w1Min) * rank/popSize];
        w1 = w1Max - (w1Max-w1Min) * rank/pop.size(it);

    case 8 % success-based
        % popSize = sum(pop.fit(:,it) ~= inf);
        % S = sum(pop.fit(:,it) < min(pop.fit(:,1:it-1),[],2));
        repeated_idx = intersect(Aidx,saveIdx(it-1,:));
        sumS = sum(X(it, repeated_idx).pb.fit < X(it-1, repeated_idx).pb.fit);  ??????????
        w1 = w1Min + (w1Max - w1Min) * sumS/numel(repeated_idx); % numel(repeated_idx) ~= pop.size(it);
         
    case 9 % convergence-based  (cb)                                        depend on i 
        fpp = X(it-1,x.idx).pb.fit - X(it,x.idx).pb.fit;
        fpl = x.pb.fit - x.lb.fit;
        C = abs(fpp) / fpp;
        D = abs(fpl) / fpl;
        w1 = 1 - abs((a_w1_cb-C)/(1+D)/(1+b_w1_cb));
        % C = abs(min(pop.fit(:,1:it-1),[],2) - min(pop.fit(:,1:it),[],2))...
        %     /(min(pop.fit(:,1:it-1),[],2) - min(pop.fit(:,1:it),[],2));
        % D = abs(min(pop.fit(:,1:it),[],2) - gb.fit(it))...
        %     /(min(pop.fit(:,1:it),[],2) - gb.fit(it));
        % w1 = [w1 ; 1 - abs((a_w1_cb-C)/(1+D)/(1+b_w1_cb))];

end