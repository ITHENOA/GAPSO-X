function pop = POP(pop,bound,gb)   % pop.(pos,size) => pop.(fit)
global it newidx deadidx Aidx bornidx d
global popCS pIntitTypeCS2
global initialPopSize finalPopSize particlesToAdd popTViterations

bornidx = [];
deadidx = [];
popSize = pop.size(it+1);
switch popCS
case 0 % constant ---------------------------------------------------------
    % disp("pop ==> cte")
    % Do Nothing

case 1  % time-varying ----------------------------------------------------
    % disp("pop ==> time-varying")
    % deadidx = Aidx(end); % dead last idx (worst) %-1
    % Aidx = Aidx(1:end-1); % update idx vector
    if it > popTViterations
        if prod(gb.fit(it+1) == gb.fit(it+1-popTViterations:it+1)) % +1 after pop     2(it-1)
            if popSize < finalPopSize

                newidx = newidx + 1; % create new idx
                % ==> no dead
                Aidx = [Aidx newidx]; % update idx vector
                bornidx = newidx;
                
                pop.pos(newidx,:,it+1) = ini_pop(1,bound);  %(it)
                pop.fit(newidx,it+1) = f(pop.pos(newidx,:,it+1));


            elseif popSize == finalPopSize  % -1 +1

                newidx = newidx + 1; % create new idx
                deadidx = Aidx(end); % dead last idx (worst)
                bornidx = newidx;
                Aidx = [Aidx(1:end-1) newidx]; % update idx vector

                pop.pos(newidx,:,it+1) = ini_pop(1,bound); %(it)
                pop.fit(newidx,it+1) = f(pop.pos(newidx,:,it+1));

            end
        else
            if popSize > initialPopSize % -1 delete worst
                
                % ==> dont create new idx
                deadidx = Aidx(end); % dead last idx (worst)
                Aidx = Aidx(1:end-1); % update idx vector

            end
        end
    else
        pop.pos(Aidx,:,it+1) = pop.pos(Aidx,:,it+1);  %(it)(it-1)
        pop.fit(Aidx,it+1) = f(pop.pos(Aidx,:,it+1)); %2(it)  
    end

case 2  % incremental -----------------------------------------------------
    % disp("pop ==> incremental")
    % if popSize < finalPopSize && popSize + particlesToAdd > finalPopSize
    if popSize + particlesToAdd > finalPopSize
        particlesToAdd = finalPopSize - popSize;
    end
    if particlesToAdd > 0                                                       %new
        if pIntitTypeCS2 == 0 % Init-random       ok 
            pop.pos(newidx+1:newidx+particlesToAdd,:,it+1) = ini_pop(particlesToAdd,bound);

        elseif pIntitTypeCS2 == 1 % Init-horizontal       ok
            xprim=ini_pop(particlesToAdd,bound);
            pop.pos(newidx+1:newidx+particlesToAdd,:,it+1) = ...    %(it)
                xprim + rand(particlesToAdd,d) .* (gb.pos(it+1) - xprim); %(it-1)

        end

        pop.fit(newidx+1:newidx+particlesToAdd,it+1) = ...%(it)
            f(pop.pos(newidx+1:newidx+particlesToAdd,:,it+1));%(it)
        
        
        % update idx
        Aidx = [Aidx newidx+1:newidx+particlesToAdd]; % update idx vector  
        bornidx = newidx+1:newidx+particlesToAdd;
        newidx = newidx + particlesToAdd; % create new idx
        % ==> no dead
    end
end
pop.size(it+1) = numel(Aidx);
pop.fit(bornidx,1:it) = inf;


