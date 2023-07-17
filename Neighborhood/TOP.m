function [X,tree,rc]  = TOP(pop,X,tree,rc) 

global Aidx topTime_counter bornidx it deadidx
global topCS rcdelCS2
global k_top5 n_iniNei_top3 n_nei_born_top3 perc_top5_rcdel1 %(user defined)

popSize = pop.size(it);
switch topCS
    case 0 % ring  --------------------------------------------------------
        for i =Aidx
            X(i,it).N.idx = ringTop(i);
        end

    case 1 % full ---------------------------------------------------------
        shuffle = sort(Aidx);
        for i = Aidx
            X(i,it).N.idx = setdiff(shuffle,i);
        end

    case 2 % von newman  --------------------------------------------------
        shuffle = sort(Aidx); 
        d = ceil(sqrt(popSize));
        mtx=zeros(d+2); 
        k=0;
        for i=2:d+1
            for j = 2:d+1
                k=k+1;
                mtx(i,j) = shuffle(k);
                if k == numel(shuffle); break; end
            end
            if k == numel(shuffle); break; end
        end
        for i = Aidx
            X(i,it).N.idx = [];
            [r,c]=find(mtx == i);
            for j = [+1 -1]
               if mtx(r+j,c) ~= 0   % < >
                   X(i,it).N.idx = [X(i,it).N.idx, mtx(r+j,c)];
               end
               if mtx(r,c+j) ~= 0   % ^ v
                   X(i,it).N.idx = [X(i,it).N.idx, mtx(r,c+j)];
               end
            end
        end

    case 3 % random -------------------------------------------------------
        if it == 1
            for i = Aidx; X(i,it).N.idx=[]; end
            for i = Aidx
                exept_i = setdiff(Aidx,i);
                neighbor = exept_i(randperm(numel(Aidx)-1,n_iniNei_top3));
                for j = neighbor
                    if ~sum(X(j,it).N.idx == i) % dont exist i in this neighborhood
                        X(j,it).N.idx = [X(j,it).N.idx, i];   % append i to N(j)
                        X(i,it).N.idx = [X(i,it).N.idx, j];   % append j to N(i)
                    end
                end
            end

        else % it > 1
            repeat = setdiff(Aidx,bornidx);

            if numel(deadidx)==0 ; deadidx=0; end
            for i = repeat
                exept_i = setdiff(repeat,i);
                rnd_neighbor = exept_i(randperm(numel(exept_i),1));
                X(i,it).N.idx = [X(i,it-1).N.idx(X(i,it-1).N.idx ~= deadidx), rnd_neighbor];
            end
            if deadidx==0 ; deadidx=[]; end

            if numel(bornidx) ~= 0 % (+)
                for b = 1:numel(bornidx)
                    neighbor = repeat(randperm(numel(repeat), n_nei_born_top3));
                    X(bornidx(b),it).N.idx = neighbor;
                    for n = 1:n_nei_born_top3
                        X(neighbor(n),it).N.idx = [X(neighbor(n),it).N.idx, bornidx(b)];
                    end
                end
            end
        end

    case 4 % hierarchical  ------------------------------------------------
        if it == 1
            tree = Top_hierarchical_ini(pop.pb.fit);
        else
            if numel(bornidx) ~= 0
                tree = Top_hierarchical_to_add(tree);
            end
            tree = Top_hierarchical_update(tree,pop.pb.fit);
        end
        for i = Aidx
            X(i,it).N.idx = Top_hierarchical_neighborhood(tree,i);
        end

    case 5 % time - var  --------------------------------------------------
        if it == 1
            % TOP(full) 
            shuffle = sort(Aidx);
            for i = Aidx
                X(i,it).N.idx = setdiff(shuffle,i);
            end
            % rc = fix_ring_connection(Aidx);
            rc1=[];
            for i = Aidx
                rc1 = [rc1 ; ones(popSize,1)*i];
            end
            rc2=[];
            for i = 1:popSize
                rc2 = [rc2 ; Aidx'];
            end 
            rc = [rc1 rc2];
            rc = rcFixer(rc);
            
        else % it > 1

            for i=bornidx; X(i,it).N.idx=[]; end

            % if(-) : update rc
            if numel(deadidx)~=0
                rc(logical(sum(rc == deadidx,2)),:)=[]; % remove remainConnections include deadidx
                rc(logical(prod(rc == [deadidx+1 deadidx-1],2)),:)=[]; % remove [deadidx+1 deadidx-1] connection
                rc(logical(prod(rc == [deadidx-1 deadidx+1],2)),:)=[]; % because ring make them side by side 
            end

            % (if) dead exist remove and update (else) update
            if numel(deadidx)==0; deadidx=0; end
            for i = setdiff(Aidx,bornidx)
                X(i,it).N.idx = X(i,it-1).N.idx(X(i,it-1).N.idx ~= deadidx);
            end
            if deadidx==0 ; deadidx=[]; end
            
            if numel(bornidx) ~= 0 || numel(deadidx) ~= 0
                % ensure keep ring
                % if(-) ex) del=2: (1 <=> 3)
                % if(+) ex) born=21: (1 <!=> 20) => (1 <=> 21) & (21 <=> 20)
                for i = Aidx
                    trust_ring = ringTop(i);
                    X(i,it).N.idx = unique([X(i,it).N.idx, trust_ring]);
                end 
            end

            % if numel(bornidx) ~= 0 % (+)
            %     repeated_idx = setdiff(Aidx,bornidx);
            %     s=0;
            %     for i = repeated_idx
            %         s = s + numel(X(i,it).N.idx);
            %     end
            %     C = floor(s / numel(repeated_idx)); % number of adding neighbor
            %     for i = bornidx
            %         while true  % ensure random neighbors not side by i
            %             neighbors = repeated_idx(randperm(numel(repeated_idx),C));
            %             if ~sum(abs(i - neighbors) == 1); break; end
            %         end
            %         X(i,it).N.idx = unique([X(i,it).N.idx, neighbors]);
            %         for j = neighbors
            %             rc = [rc ; [i j]]; % rc = [rc ; [i j]]; % update rc
            %             X(j,it).N.idx = [X(j,it).N.idx i];
            %         end
            %     end
            % end 
                       
            if size(rc,1) ~= 0
                rc(find(prod(rc == [min(min(rc)) max(max(rc))] | rc == [max(max(rc)) min(min(rc))],2)),:) = [];
                % every k iteration remove one random particle
                if rem(it,k_top5) == 0
                    if rcdelCS2 == 0
                        topTime_counter = topTime_counter + 1;
                        n_del = popSize - topTime_counter;
                        if n_del > size(rc,1); n_del = size(rc,1); end
                    elseif rcdelCS2 == 1
                        n_del = floor(size(rc,1) * perc_top5_rcdel1);    % remove 40% of connections                     
                        if size(rc,1) == 1; n_del = 1; end                  
                    else
                        error("rcdelCS2 = {0,1}")
                    end
                    rndp = randperm(size(rc,1),n_del);
                    del_connection = rc(rndp,:);
                    rc = setdiff(rc,del_connection,'rows'); % rc ==> output
                    if size(rc,1) == 0; disp("no more allowed connection"); end
                    for i = 1:n_del
                        Nidx1 = X(del_connection(i,1),it).N.idx;
                        Nidx2 = X(del_connection(i,2),it).N.idx;
                        X(del_connection(i,1),it).N.idx = Nidx1(Nidx1 ~= del_connection(i,2)); % remove 2 from 1
                        X(del_connection(i,2),it).N.idx = Nidx2(Nidx2 ~= del_connection(i,1)); % remove 1 from 2
                    end
                end
            end

            if numel(bornidx) ~= 0 % (+)
                repeated_idx = setdiff(Aidx,bornidx);
                s=0;
                for i = repeated_idx
                    s = s + numel(X(i,it).N.idx);
                end
                C = floor(s / numel(repeated_idx)); % number of adding neighbor
                for i = bornidx
                    while true  % ensure random neighbors not side by i
                        neighbors = repeated_idx(randperm(numel(repeated_idx),C));
                        if ~sum(abs(i - neighbors) == 1); break; end
                    end
                    X(i,it).N.idx = unique([X(i,it).N.idx, neighbors]);
                    for j = neighbors
                        rc = [rc ; [i j]]; % rc = [rc ; [i j]]; % update rc
                        X(j,it).N.idx = [X(j,it).N.idx i];
                    end
                end
            end 
        end
end

for i = Aidx % ok for 0 1 2 3 4? 5
    X(i,it).N.pos = pop.pos(X(i,it).N.idx,:,it);
    X(i,it).N.fit = pop.fit(X(i,it).N.idx,it);
    X(i,it).N.size = numel(X(i,it).N.idx);

    % sort X.N
    [X(i,it).N.fit,id] = sort(X(i,it).N.fit);
    X(i,it).N.pos = X(i,it).N.pos(id,:);
    X(i,it).N.idx = X(i,it).N.idx(id);

    % local best
    X(i,it).lb.pos = X(i,it).N.pos(1,:);
    X(i,it).lb.fit = X(i,it).N.fit(1);
    X(i,it).lb.idx = X(i,it).N.idx(1);
end


