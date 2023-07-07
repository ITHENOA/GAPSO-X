function pm = PM(x,pm,N,gb)
global pmCS2
global PM_cte e m Sc Fc %(user defined)

switch  pmCS2
    case 1 % cte
        pm = [pm, PM_cte];

    case 2 % euclidean
        distance = norm(x.pos - x.pb.pos); % euclidean distance
        e = 0; % (0,1] used to weigh the diastance
        if distance == 0
            pm = [pm, e * pm(end)];
        else
            pm = [pm, e * distance];
        end

    case 3 % obj.func
        m = 0; % (0,1]
        obj_distance = (gb(it) - x.fit)/gb(it);
        if obj_distance == 0
            pm = [pm, m * pm(end)];
        else
            pm = [pm, m * obj_distance];
        end

    case 4 % success rate
        Sc = 0; % threshold (user defined)
        Fc = 0; % threshold (user defined)
        flagS=1;
        flagF=1;
        for i = 1:Sc
            if (gb(it+1-i) > gb(it-i)); flagS=0;break; end
        end
        for i = 1:Fc
            if (gb(it+1-i) < gb(it-i)); flagS=0;break; end
        end

        if flagS 
            pm = [pm, pm(end) * 2];
        elseif flagF
            pm = [pm, pm(end) * .5];
        else
            pm = [pm, pm(end)];
        end
end