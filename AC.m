function phi = AC(x,gb)   % ok
global it itMax
global AC_CS
global phi1 phi2 phiMax phiMin  rand_AC1 %(user defined)

    switch AC_CS
        case 0 % cte ------------------------------------------------------
            % disp("AC ==> cte")
            phi = [phi1 phi2];
        case 1 % rnd ------------------------------------------------------
            % disp("AC ==> v")
            phi = rand_AC1.*(phiMax - phiMin) + phiMin;
        case 2 % time-var -------------------------------------------------
            % disp("AC ==> time-var")
            phi(1) = 2.5 - it/itMax * 2;
            phi(2) = 0.5 + it/itMax * 2;
        case 3 % extrapolated ---------------------------------------------
            % disp("AC ==> extrapolated")
            phi(1) = exp(-(it/itMax));
            A = abs(x.lb.fit - x.fit/gb.fit(it));%abs(x.lb.fit - x.fit/gb.fit(it)); %abs(gb - fx/gb);
            phi(2) = exp(phi(1) * A);
    end