function phi = AC(x,gb)   % ok
global it itMax
global AC_CS
global phi1 phi2 phi1Max phi1Min phi2Max phi2Min %(user defined)

    switch AC_CS
        case 0 % cte ------------------------------------------------------
            phi = [phi1 phi2];

        case 1 % rnd ------------------------------------------------------
            phi = rand(1,2).*([phi1Max phi2Max] - [phi1Min phi2Min]) + [phi1Min phi2Min];

        case 2 % time-var -------------------------------------------------
            phi(1) = 2.5 - it/itMax * 2;
            phi(2) = 0.5 + it/itMax * 2;

        case 3 % extrapolated ---------------------------------------------
            phi(1) = exp(-(it/itMax));
            A = abs((x.lb.fit - x.fit)/gb.fit(it));
            phi(2) = exp(phi(1) * A);
            if phi(2) > phi2Max
                phi(2) = phi2Max;
            elseif phi(2) < phi2Min
                phi(2) = phi2Min;
            end
    end
