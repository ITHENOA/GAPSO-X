function [w2,w3] = W23(X,x)   % ok
global paramW2CS paramW3CS it bornidx
global w2_cte w3_cte 

switch paramW2CS
    case 0 % w1
        w2 = x.w1;

    case 1 % rnd
        w2 = 0.5 + rand/2;

    case 2 % cte
        if it == 1 || ismember(x.idx,bornidx)
            w2 = w2_cte;
        else
            w2 = X(x.idx,it-1).w2;
        end
end

switch paramW3CS
    case 0 % w1
        w3 = x.w1;

    case 1 % rnd
        w3 = 0.5 + rand/2;

    case 2 % cte
        if it == 1 || ismember(x.idx,bornidx)
            w3 = w3_cte;
        else
            w3 = X(x.idx,it-1).w3;
        end
end
