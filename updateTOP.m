function X = updateTOP(pop,X,saveIdx,rc)
% if + | -
% 
%     if -1          
%         if top{Hierarchical}
%             N(it+1) = updateTree(tree);
%         else
%             N(it+1) <== (remove this -1 from all neighborhood)
%         end
%     end
% 
%     if top{time-var}                                                      {time-var} : remove some random connections
%         if -1
%             N(it+1) <== updateTOP(N(it+1))                                N updated in above IF
%         else
%             N(it+1) <== updateTOP(N(it))                                  N didnt update yet
%         end
%     end
% 
%     if +
%         if top{time-var}
%             C = average number of neighbor for all particles
%             N(it+1) <== (+ <==> C random neighborhood)
%         elseif top{Hierarchical}
%             tree = addToTree(+,tree)
%             N(it+1) = updateTree(tree);
%         end
%     end
% 
%     if top{ring|full|von}
%         N(it+1) <== TOP()
%     end
% 
% else
%     if top{time-var}
%         N(it+1) <== updateTOP(N(it))
%     else
%         N(it+1) <== N(it)
%     end
% end

global popCS topCS
global deadidx it Aidx bornidx

if topCS == 5 % TV
elseif topCS == 4 % H
elseif topCS == 0 || topCS == 1 || topCS == 2 % ring|full|von
else
    error("Topology option : 0=ring, 1=full, 2=VonNewman, 3=rand, 4=Hierarchy, 5=TimeVar")
end




if popCS ~= 0     % top(time-var) or pop(~cte)

    if numel(deadidx) ~= 0 %%%% dead %%%% 
        if numel(bornidx) == 0 && (topCS == 0 || topCS == 1 || topCS == 2) % (dont have born) & TOP(ring|full|von)
            % update topology for all
            for i = Aidx
                x.idx = i;
                X(i,it+1).N = TOP(pop,x);
            end
        else
            for i = setdiff(Aidx,bornidx) % repeated
                x = X(i,it);
                if sum(x.N.idx == deadidx) % dead blong i 
                    id = find(x.N.idx == deadidx);
                    X(i,it+1).N.idx = [x.N.idx(1:id-1) x.N.idx(id+1:end)];
                    X(i,it+1).N.pos = pop.pos(X(i,it+1).N.idx,:,it+1);
                    X(i,it+1).N.fit = pop.fit(X(i,it+1).N.idx,it+1);
                    X(i,it+1).N.size = numel(X(i,it+1).N.idx);
                end
            end
        end
    end % END -
    
    % koli shod ; az if biar biron                                          ??
    if topCS == 5 % Time-Varing
        if numel(deadidx) ~= 0  % (-)
            rc(rc == deadidx,:)=[];
        end
        [] = TOP(it+1,pop,x,N,rc)
        % dont remove some connection from newborns                         ??
        if numel(bornidx) ~= 0  % (+)
            repeated_idx = setdiff(Aidx,saveIdx{it});
            s=0;
            for i = repeated_idx
                s = s + X(i,it).N.size;
            end
            C = s / numel(repeated_idx); % number of adding neighbor
            neighbors = repeated_idx(randperm(numel(repeated_idx),C));
            for i = bornidx
                X(i,it+1).N.idx = neighbors;
                for j = neighbors
                    rc = [rc ; [i j]];
                    X(j,it+1).N.idx = [X(j,it).N.idx i];
                end
            end
            update_idx = [bornidx, neighbors];  % N neighbors nabayed avaz she bayad update she chon momkene ghablan update shode bashe
            X(update_idx,it+1).N.pos = pop.pos(X(update_idx,it+1).N.idx,:,it+1);              % test
            % [X(update_idx,it+1).N.pos] = deal[pop.pos([X(update_idx,it+1).N.idx],:,it+1)]; 
            X(update_idx,it+1).N.fit = pop.fit(X(update_idx,it+1).N.idx,it+1);               % test
            % [X(update_idx,it+1).N.fit] = deal[pop.fit([X(update_idx,it+1).N.idx],it+1)]; 
            X(update_idx,it+1).N.size = numel(X(update_idx,it+1).N.idx);                     % test
            % X(update_idx,it+1).N.size = numel([X(update_idx,it+1).N.idx]);
            % for i = update_idx                                                            % trust way
            %     X(i,it+1).N.pos = pop.pos(X(i,it+1).N.idx,:,it+1); 
            %     X(i,it+1).N.fit = pop.fit(X(i,it+1).N.idx,it+1);
            %     X(i,it+1).N.size = numel(X(i,it+1).N.idx);
            % end
        end
    end



        for i = Aidx
            x.idx = i;
            if numel(deadidx) ~= 0
                X(i,it+1).N = TOP(pop,x,X(i,it+1).N);
            else
                X(i,it+1).N = TOP(pop,x,X(i,it).N);
            end
        end
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
    end % END +


else
    % it => it+1    (Aidx(it+1) == Aidx(it))
    X(Aidx,it+1).N = X(Aidx,it).N;
end
