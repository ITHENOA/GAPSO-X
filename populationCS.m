function newpop=populationCS(option,particles,initialPopSize,finalPopSize,particlesToAdd,pIntitType,popTViterations,boundries,it,fits,gb,pop,gbp)
    popSize = size(pop,1);
    [~,idx]=sort(fits);
    switch option
    case 0 % constant    ok
        newpop=ini_pop(particles,boundries);
    case 1  % time-varying      ok
        if prod(gb(it-1) == gb(it-1:it-popTViterations))
            if size(pop,1)<finalPopSize
                newpop=[pop;ini_pop(1,boundries)];
            elseif popSize==finalPopSize
                newpop=[pop(1:idx(end)-1,:);pop(idx(end)+1:end,:)];
                newpop=[newpop;ini_pop(1,boundries)];
            end
        else
            if popSize > initialPopSize
                newpop=[pop(1:idx(end)-1,:);pop(idx(end)+1:end,:)];
            elseif size(pop,1)==initialPopSize
                newpop=[pop(1:idx(end)-1,:);pop(idx(end)+1:end,:)];
                newpop=[newpop;ini_pop(1,boundries)];
            end
        end
    case 3  % incremental       ok
            if it==1
                pop=ini_pop(initialPopSize,boundries);
            end
            if pIntitType==0 %Init-random       ok
                newpop=[pop;ini_pop(particlesToAdd,boundries)];
            elseif pIntitType==1 %Init-horizontal       ok
                newpop_p=ini_pop(particlesToAdd,boundries);
                newpop=[pop;newpop_p+rand(particlesToAdd,size(pop,2)).*(gbp-newpop_p)];
            end
    end
end

