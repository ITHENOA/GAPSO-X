function [w2,w3] = W23(X,x)   % ok
global paramW23CS it
global w2_cte w3_cte 

switch paramW23CS
    case 0 % w1
        w2 = x.w1;
        w3 = x.w1;

    case 1 % rnd
        w2 = 0.5 + rand/2;
        w3 = 0.5 + rand/2;

    case 2 % cte
        if it == 1
            w2 = w2_cte;
            w3 = w3_cte;
        else
            w2 = X(x.idx,it-1).w2;
            w3 = X(x.idx,it-1).w3;
        end
end
