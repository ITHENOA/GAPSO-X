function phi = AC(it,itMax,x_lb_fit,x_fit,gb)   % ok
global AC_CS
global phi1 phi2 phiMax phiMin %(user defined)

    switch AC_CS
        case 0 % cte    ok  
            phi = [phi1 phi2];
        case 1 % rnd    ok
            phi = rand(1,2).*(phiMax - phiMin) + phiMin;
        case 2 % time-var   ok
            phi(1) = 2.5 - it/itMax * 2;
            phi(2) = 0.5 + it/itMax * 2;
        case 3 % extrapolated   ok
            phi(1) = exp(-(it/itMax));
            A = abs(x_lb_fit - x_fit/gb.fit(it));%abs(x.lb.fit - x.fit/gb.fit(it)); %abs(gb - fx/gb);
            phi(2) = exp(phi(1) * A);
    end