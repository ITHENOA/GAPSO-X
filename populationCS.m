function pop = populationCS(pop,bound,gb)   % pop.(pos,size) => pop.(fit)
global it newidx deadidx Aidx bornidx
global popCS  pIntitTypeCS2
global initialPopSize finalPopSize particlesToAdd  popTViterations

popSize = pop.size(it-1);
switch popCS
case 0 % constant    ok
    pop.pos(Aidx,:,it) = pop.pos(Aidx,:,it-1);
    pop.fit(Aidx,it) = f(pop.pos(Aidx,:,it));

case 1  % time-varying      ok
    if it > popTViterations
        if prod(gb.fit(it-1) == gb.fit(it-popTViterations:it-1)) % +1 after pop
            if popSize < finalPopSize

                newidx = newidx + 1; % create new idx
                % ==> no dead
                Aidx = [Aidx newidx]; % update idx vector
                bornidx = newidx;
                
                pop.pos(newidx,:,it) = ini_pop(1,bound);
                pop.fit(newidx,it) = f(pop.pos(newidx,:,it));


            elseif popSize == finalPopSize  % -1 +1

                newidx = newidx + 1; % create new idx
                deadidx = Aidx(end); % dead last idx (worst)
                bornidx = newidx;
                Aidx = [Aidx(1:end-1) newidx]; % update idx vector

                pop.pos(newidx,:,it) = infini_pop(1,bound);
                pop.fit(newidx,it) = f(pop.pos(newidx,:,it));

            end
        else
            if popSize > initialPopSize % -1 delete worst
                
                % ==> dont create new idx
                deadidx = Aidx(end); % dead last idx (worst)
                Aidx = Aidx(1:end-1); % update idx vector

            end
        end
    end

case 2  % incremental       ok
        if pop.size(it) < finalPopSize && pop.size(it) + particlesToAdd > finalPopSize
            particlesToAdd = finalPopSize - pop.size(it);
        end

        if pIntitTypeCS2 == 0 % Init-random       ok 
            pop.pos(newidx+1:newidx+particlesToAdd,:,it) = ini_pop(particlesToAdd,bound);

        elseif pIntitTypeCS2 == 1 % Init-horizontal       ok
            xprim=ini_pop(particlesToAdd,bound);
            pop.pos(newidx+1:newidx+particlesToAdd,:,it) = ...
                xprim + rand(particlesToAdd,d) .* (gb.pos(it-1) - xprim);

        end

        pop.fit(newidx+1:newidx+particlesToAdd,it) = ...
            f(pop.pos(newidx+1:newidx+particlesToAdd,:,it));

        Aidx = [Aidx newidx+1:newidx+particlesToAdd]; % update idx vector  
        bornidx = newidx+1:newidx+particlesToAdd;
        newidx = newidx + particlesToAdd; % create new idx
        % ==> no dead
end


