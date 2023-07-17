function pm = PM(x,oldPm,gb)
global pmCS it
global PM_cte e m Sc Fc %(user defined)

switch  pmCS
    case 1 % cte ----------------------------------------------------------
        pm = PM_cte;
        
    case 2 % euclidean
        distance = norm(x.pos - x.pb.pos); % euclidean distance
        % e = (0,1] used to weigh the diastance
        if distance == 0
            pm = e * oldPm;
        else
            pm = e * distance;
        end

    case 3 % obj.func -----------------------------------------------------
        % m = (0,1]
        obj_distance = (x.lb.fit - x.fit)/x.lb.fit;
        if obj_distance == 0
            pm = m * oldPm;
        else
            pm = m * obj_distance;
        end

    case 4 % success rate -------------------------------------------------
        % Sc = threshold (user defined)
        % Fc = threshold (user defined)
        if it < max(Sc,Fc)
            pm = oldPm;
        else
            flagS=1;
            flagF=1;
            for i = 1:Sc
                if (gb.fit(it+1-i) == gb.fit(it-i)); flagS=0; break; end
            end
            for i = 1:Fc
                if (gb.fit(it+1-i) < gb.fit(it-i)); flagF=0; break; end
            end
    
            if flagS 
                pm = oldPm * 2;
            elseif flagF
                pm =  oldPm * .5;
            else
                pm = oldPm;
            end
        end
end