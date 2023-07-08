function pop = populationCS(pop,bound,gb)
global it
global popCS pIntitTypeCS2
global particles initialPopSize finalPopSize particlesToAdd  popTViterations

popSize = pop.size(it-1);
switch popCS
case 0 % constant    ok
    pop.pos(:,:,it) = pop.pos(:,:,it-1);
case 1  % time-varying      ok
    if it > popTViterations
        if prod(gb.fit(it-1) == gb.fit(it-popTViterations:it-1)) % +1 after pop
            if popSize < finalPopSize
                pop.pos(popSize+1,:,it) = ini_pop(1,bound);
                pop.size(it) = pop.size(it-1) + 1;
                pop.fit(popSize+1,it) = f(pop.pos(popSize+1,:,it));
                pop.idx(it,pop.size(it)) = pop.size(it);

            elseif popSize == finalPopSize  % +1 on worst
                pop.idx(it,popSize) = popSize+1;
                pop.pos(popSize,:,it) = infini_pop(1,bound);
                pop.fit(popSize,it) = f(pop.pos(popSize,:,it));
                % pop.fit(popSize,1:it-1)=inf;

                pop.idx()

            end
        else
            if popSize > initialPopSize % -1 delete worst
                pop.pos(popSize,:,it) = inf;
                pop.size(it) = pop.size(it-1) - 1;
                pop.fit(popSize,1:it) = inf;
            end
        end
    end

case 2  % incremental       ok
        if pIntitTypeCS2 == 0 % Init-random       ok
            pop.pos(popSize+1:popSize+particlesToAdd,:,it) = ini_pop(particlesToAdd,bound);
        elseif pIntitTypeCS2 == 1 % Init-horizontal       ok
            xprim=ini_pop(particlesToAdd,bound);
            pop.pos(popSize+1:popSize+particlesToAdd,:,it) = ...
                xprim + rand(particlesToAdd,d) .* (gb.pos(it-1) - xprim);
        end
        pop.size(it) = pop.size(it-1) + particlesToAdd;
        pop.fit(popSize+1:popSize+particlesToAdd,it) = ...
            f(pop.pos(popSize+1:popSize+particlesToAdd,:,it));
end


