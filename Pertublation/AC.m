function phi = AC(x,X,gb)   % ok
global it itMax
global AC_CS
global phi1 phi2 phiMax phiMin  %(user defined)

    switch AC_CS
        case 0 % cte ------------------------------------------------------
            phi = [phi1 phi2];

        case 1 % rnd ------------------------------------------------------
            if it == 1
                phi = rand(1,2).*(phiMax - phiMin) + phiMin;
            else
                X(x.idx,it).phi = X(x.idx,it-1).phi;
            end

        case 2 % time-var -------------------------------------------------
            phi(1) = 2.5 - it/itMax * 2;
            phi(2) = 0.5 + it/itMax * 2;

        case 3 % extrapolated ---------------------------------------------
            phi(1) = exp(-(it/itMax));
            A = abs(x.lb.fit - x.fit/gb.fit(it));%abs(x.lb.fit - x.fit/gb.fit(it)); %abs(gb - fx/gb);
            phi(2) = exp(phi(1) * A);
    end