function [w2,w3] = param_W23(w1)   % ok
global paramW23CS
global w2_cte w3_cte

switch paramW23CS
    case 0 % w1
        w2 = w1;
        w3 = w1;

    case 1 % rnd
        w2 = 0.5 + rand/2;
        w3 = 0.5 + rand/2;

    case 2 % cte
        w2 = w2_cte;
        w3 = w3_cte;
end