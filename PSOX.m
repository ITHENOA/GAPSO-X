clear;clc
run('Configuration.m')

global topCS alpha_mtxCS2 inertiaW1CS popCS
global it itMax Aidx deadidx bornidx

% Load initialize (pop, TOP, MOI)
[pop, ini_X, gb, pb_it] = INITIALIZE(bound);

X = struct('idx',[],'pos',[],'fit',[],'v',[],'pb',[],'N',[],'I',[],'lb',[]);
saveIdx = cell(1,itMax);

for it = 1:itMax
    saveIdx{it} = Aidx;
    
    for i = Aidx
        if it == 1
            x = ini_X(i); % .({idx},{pos},{fit},{v},{pb.fit},{pb.pos},{N},{I},{lb.pos},{lb.fit},{lb.idx})
        else
            x = X(i,it);
        end
    
        % ------------- Calculate parameters for update velocity --------------
        % w1
        if it == 1
            if inertiaW1CS == 8 || inertiaW1CS == 9 % need previos iteration
                x.w1 = ini_w1_45;
            else
                x.w1 = inertiaW1(ini_w1_45,gb,x,bound,pop,[],[]);
            end
        else
            x.w1 = inertiaW1(ini_w1_45,gb,x,bound,pop,X,saveIdx);
        end
        % w2, w3
        [x.w2, x.w3] = param_W23(x.w1);
        % Perturbation Magnitud (PM)
        if it == 1
            x.pm = ini_pm_234;
        else
            x.pm = PM(x, X(i,it-1).pm, gb);
        end
        % Pert_Info
        x.prtInfo = pertInf(pb_it.pos(i,:), x.pm);
        % phi
        x.phi = AC(x, gb);
        % DNPP
        if it == 1 && alpha_mtxCS2 == 2 % adaptive alpha Need previous iteration
            alpha_mtxCS2 = 0; % use cte alpha
        	    x.dnpp = DNPP(x, pop, x.prtInfo, x.phi, []); 
            alpha_mtxCS2 = 2; % back to adaptive alpha
        else
            x.dnpp = DNPP(x, pop, x.prtInfo, x.phi, saveIdx); 
        end
        % Pert_Rand
        x.prtRnd = pertRnd(x.pos, pm);
        % ----- save -----
        X(i,it) = x;
        x=[];
        % -------------------------- Update Velocity --------------------------
        X(i,it+1).v = X(i,it).w1 * X(i,it).v + X(i,it).w2 * X(i,it).dnpp + X(i,it).w3 * X(i,it).prtRnd;
        % -------------------------- Update Position --------------------------
        X(i,it+1).pos = X(i,it).pos + X(i,it+1).v;        
    end
    clear ini_X 

    for i = Aidx    % -------------- Update Pb --------------------------------
        X(i,it+1).fit = f(X(i,it+1).pos);
        if X(i,it+1).fit < X(i,it).fit && isinrange(X(i,it+1).pos,bound) % && toye bound bood ? 
            X(i,it+1).pb.pos = X(i,it+1).pos;%? formul 3 ?
            X(i,it+1).pb.fit = X(i,it+1).fit;
        else
            X(i,it+1).pb = X(i,it).pb;
        end
    end

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % apply stagnation detection, particles reinitialization %optional
    
    % ------------------------- Update Population ------------------------
    pop = populationCS(pop,bound,gb);  % +1 | +1,-1 | -1 | +particlesToAdd
    % sort idxs
    [~, idx] = sort(pop.fit(Aidx,it));
    Aidx = Aidx(idx);
    % pb ha ke avaz nashode - faghat in jedida pb nadaran
    % momkene gb taghir kone
    % % personal best & global best
    % [pb_it.fit(Aidx), itOfMin] = min(pop.fit(Aidx,:),[],2);
    % for i=1:numel(Aidx)
    %     pb_it.pos(Aidx(i),:) = pop.pos(Aidx(i),:,itOfMin(i));
    % end
    % [gb.fit(it), idx] = min(pb_it.fit(Aidx));
    % gb.pos(it,:) = pb_it.pos(Aidx(idx),:);
    % gb.idx(it) = Aidx(idx);


    % ------------------------- Update Topology ------------------------
    if popCS ~= 0     % top(time-var) or pop(~cte)
        %%%%%%%%%%%%% popCS ~= 0 %%%%%%%%%%%%%
        % we have a dead
        if numel(deadidx) ~= 0  
            % if numel(bornidx) == 0 && (topCS == 0 || topCS == 1 || topCS == 2)%new
            %     % dar soorati ke az shuffle rstefade konim
            %     for i = Aidx
            %         x.idx = i;
            %         X(i,it+1).N.idx = TOP(pop,x,N);
            %         X(i,it+1).N.pos = pop.pos(X(i,it+1).N.idx,:,it+1);
            %         X(i,it+1).N.fit = pop.fit(X(i,it+1).N.idx,it+1);
            %         X(i,it+1).N.size = numel(X(i,it+1).N.idx);
            %     end
            % else
                for i = setdiff(Aidx,bornidx) % repeated
                    x = X(i,it);
                    if sum(x.N.idx == deadidx) % dead blong i ?
                        id = find(x.N.idx == deadidx);
                        X(i,it+1).N.idx = [x.N.idx(1:id-1) x.N.idx(id+1:end)];
                        X(i,it+1).N.pos = pop.pos(X(i,it+1).N.idx,:,it+1);
                        X(i,it+1).N.fit = pop.fit(X(i,it+1).N.idx,it+1);
                        X(i,it+1).N.size = numel(X(i,it+1).N.idx);
                    end
                end
            % end
        end
        % we have new born(s)
        if numel(bornidx) ~= 0
            if topCS == 5 % Time-Varing
                % assign C neighbors to every new particle,
                % C = average number of neighbors that every
                % particle in the swarm has at iteration t
                idx = saveIdx(it,:);
                idx = idx(idx ~= 0);
                s=0;
                for i = numel(idx)
                    s = s + X(i,it).N.size;
                end
                C = s / numel(idx);

            elseif topCS == 4 % Hierarchical
                % new particles are always placed at the bottom of the tree

            else % ring || fully || von newman
                % find some random particle and add each newborns to it's
                % neighborhood and add all this particles to each
                % newborns's neghborhood
                repeated_idx = setdiff(Aidx,bornidx); 
                rnd_idx = randperm(numel(repeated_idx), n_addToNeighborhood);
                rnd_N_idx = repeated_idx(rnd_idx);
                for i = 1:numel(bornidx) % give one newborn
                    for j = rnd_N_idx   % add to all random neighborhood
                        % add newborn to a neighborhood
                        X(j,it+1).N.idx = [X(j,it).N.idx, bornidx(i)];
                        X(j,it+1).N.pos = pop.pos(X(j,it+1).N.idx,:,it+1);
                        X(j,it+1).N.fit = pop.fit(X(j,it+1).N.idx,it+1);
                        X(j,it+1).N.size = numel(X(j,it+1).N.idx);
                    end
                    % add all random particles to this newborn
                    X(bornidx(i),it+1).N.idx = rnd_N_idx;
                    X(bornidx(i),it+1).N.pos = pop.pos(rnd_N_idx,:,it+1);
                    X(bornidx(i),it+1).N.fit = pop.fit(rnd_N_idx,it+1);
                    X(bornidx(i),it+1).N.size = numel(rnd_N_idx);
                end
                
            end
        else
            if topCS == 5

            end
        end

    else
        % it => it+1    (Aidx(it+1) == Aidx(it))
        X(Aidx,it+1).N = X(Aidx,it).N;
    end

      
end



%%  --------------------- Main ----------------------
for i = 1:itMax

    



    % 

    % 
    % % assign bornidxs to other exsited particle's neighbor on this it
    % % according to less neighbor size 
    % if numel(bornidx) ~= 0 && numel(deadidx) == 0
    %     idxs = setdiff(Aidx,bornidx);
    %     % [sorted, id] = sort(X(idxs,it-1).N.size);
    %     for i = 1:numel(bornidx)
    %         for j=1:numel(idxs)
    %             vectosort(j)=X(idxs(j),it-1).N.size
    %         end
    %         [sorted, id] = sort(vectosort);
    %         X(idxs(id(1)),it-1).N.size=X(idxs(id(1)),it-1).N.size+1;
    %         % X(idxs(id(1)),it).N.idx = [X(idxs(id(1)),it-1).N.idx bornidx(i)];
    %         % X(id(check),it).N.pos = pop.pos(X(id(check),it).N.idx,:,it);
    %         % X(id(check),it).N.fit = pop.fit(X(id(check),it).N.idx,it);
    % 
    % 
    %     end
    % end

    for i = Aidx % -------------- particle ------------------
        x.v = pop.v(i,:,it);                                                
        % Define the Particle
        x.pb.fit = pb_it.fit(i); 
        x.pb.pos = pb_it.pos(i,:,it);
        x.fit = pop.fit(i,it);
        x.pos = pop.pos(i,:,it);
        x.idx = i;
        if numel(deadidx) ~= 0  % we have a dead
            if sum(X(i,it-1).N.idx == deadidx) % dead blong i ?
                if numel(bornidx) ~= 0 % we have a born too ?
                    id = find(X(i,it-1).N.idx == deadidx);
                    X(i,it).N.idx(id) = bornidx;
                    X(i,it).N.pos(id,:) = pop.pos(bornidx,:,it);
                    X(i,it).N.fit(id) = pop.fit(bornidx,it);

                else % we dont have a born
                    id = find(X(i,it-1).N.idx == deadidx);
                    X(i,it).N.idx = [X(i,it).N.idx(1:id-1) X(i,it).N.idx(id+1:end)];
                    X(i,it).N.pos = pop.pos(X(i,it).N.idx,:,it);
                    X(i,it).N.fit = pop.fit(X(i,it).N.idx,it);
                    X(i,it).N.size = X(i,it).N.size -1;
                end
            end
        end
        if sum(i==bornidx)
            if topCS == 5
                topCS = 3;
                flag = true;
            end
            x.N = TOP(pop, x, []);
            x.N.size = numel(x.N.idx);  % x.N.(pos & fit & idx & size)
            [x.N.fit, idx] = sort(x.N.fit); % N.fit sort
            x.N.pos = x.N.pos(idx,:); % N.pos sort
            x.N.idx = x.N.idx(idx,:); % N.idx sort
            if flag
                topCS = 5;
                flag = false;
            end
        end

        % % Neighborhood(N) <== TOP(pop{fit,pos,size},x{idx},N(i,it-1))
        % x.N = TOP(pop, x, X(i,it-1).N);   % x.N.(pos & fit & idx)
        % x.N.size = numel(x.N.idx);  % x.N.(pos & fit & idx & size)
        % [x.N.fit, idx] = sort(x.N.fit); % N.fit sort
        % x.N.pos = x.N.pos(idx,:); % N.pos sort
        % x.N.idx = x.N.idx(idx,:); % N.idx sort
        if it == 1
            x.N = X(i,1).N;

        end

        % Local best <== N
        x.lb.fit = x.N.fit(best);
        x.lb.pos = x.N.pos(best,:);
        x.lb.idx = x.N.idx(best);

        % % Influencer(I) <== model of influence
        % x.I = MOI(x); % x.I.(pos & fit & idx & size | weight)
        % [x.I.fit, idx] = sort(x.I.fit); % I.fit sort
        % x.I.pos = x.I.pos(idx,:); % I.pos sort
        % x.I.idx = x.I.idx(idx,:); % N.idx sort

        x.pm = PM(x, X(i,it-1).pm, gb);
        
        % if inertiaW1CS==4 || inertiaW1CS==5
        %     x.w1 = inertiaW1(X(i,it-1).w1 ,gb,x,bound,pop,X,saveIdx);
        % elseif inertiaW1CS==4 || inertiaW1CS==5
        %     x.w1 = 
        % end
        X(i,it) = x;
        x=[];
    end
    for i = Aidx % -------------- particle ------------------
        X(i,it).prtInfo = pertInf(pb_it.pos(i,:), X(i,it).pm);
        X(i,it).prtRnd = pertRnd(X(i,it).pos, pm);                          
        X(i,it).phi = AC(X(i,it), gb);
        X(i,it).w1 = inertiaW1(X(i,it-1).w1 ,gb,X(i,it), bound, pop, X, saveIdx); 
        [X(i,it).w2, X(i,it).w3] = param_W23(X(i,it).w1);
        X(i,it).dnpp = DNPP(X(i,it), pop, X(i,it).prtInfo, X(i,it).phi, saveIdx); 
        % update velocity
        X(i,it+1).v = X(i,it).w1 * X(i,it).v + X(i,it).w2 * X(i,it).dnpp + X(i,it).w3 * X(i,it).prtRnd; 
        % update position
        X(i,it+1).pos = X(i,it).pos + X(i,it+1).v;
    end
    pop.pos(Aidx,:,it+1) = X(Aidx,it+1).pos;    
        % biaim tebgh algoritm khodesh berim => akhar berim soragh update
        % pop na aval
    saveIdx(it,1:numel(Aidx)) = Aidx;
end