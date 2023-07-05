function w1 = inertia(w1,gb,x,v, bound)
global itMax it 
global inertiaCS
global inertia_cte w1Max w1Min nu

switch inertiaCS
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

    case 5 % adaptive based on velocity
        % vBar = sum(sum(abs(v(:,:,it))));
        % vIdial = (bound(:,1)-bound(:,2))/2 * (1+cos(pi/0.95/tMax))/2;
        % if vBar >= 

    case 6 % double exponential self-adaptive
        R = norm(gb.pos(it,:)-x.pos) * (itMax-it)/itMax;
        w1 = exp(-exp(-R));

    case 7 % rank-based
    case 8 % success-based
    case 9 % convergence-based
end