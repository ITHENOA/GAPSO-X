function [X,rc]  = TOP(pop,X,rc) 

global Aidx topTime_counter bornidx it deadidx
global topCS 
global bd k_topTime n_iniNei_top3 n_nei_born_top3%(user defined)

popSize = pop.size(it);
switch topCS
    case 0 % ring  --------------------------------------------------------
        disp("Topology ==> ring")
        for i =Aidx
            X(i,it).N.idx = ringTop(i);
        end

    case 1 % full ---------------------------------------------------------
        disp("Topology ==> fully")
        shuffle = sort(Aidx);
        for i = Aidx
            X(i,it).N.idx = setdiff(shuffle,i);
        end

    case 2 % von newman  --------------------------------------------------
        disp("Topology ==> Von Newman")
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
                   X(i,it).N.idx = [X(i,it).N.idx; mtx(r+j,c)];
               end
               if mtx(r,c+j) ~= 0   % ^ v
                   X(i,it).N.idx = [X(i,it).N.idx; mtx(r,c+j)];
               end
            end
        end

    case 3 % rand   pick 2 random  ----------------------------------------
        disp("Topology ==> rnadom")

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
                if numel(repeat) < numel(bornidx) * n_rnd_top3 + 1
                    error("reduce 'n_rnd_top3' or change born TOPrnd structure")
                end
                neighbor = repeat(randperm(numel(repeat), numel(bornidx) * n_nei_born_top3)); % (+1) check 
                neighbor = reshape(neighbor,numel(bornidx),n_nei_born_top3);
                for b = 1:numel(bornidx)
                    X(bornidx(b),it).N.idx = neighbor(b,:);
                    for n = 1:n_nei_born_top3
                        X(neighbor(b,n),it).N.idx = [X(neighbor(b,n),it).N.idx, bornidx(b)];
                    end
                end
            end
        end

    case 4 % hierarchical  ------------------------------------------------
        disp("Topology ==> Hierarchical")
        h = ceil(popSize / bd); % number of members in each branch
        remain = popSize - h * bd;  % remain members    (bd=5; 4*5 & 1*3 ;popSize=23)
        rnd_idx = randperm(popSize);
        tree = reshape([Aidx(rnd_idx), ones(1,-remain)*inf], bd, h);
        treeFit = ones(bd,h)*inf;
        for i = 1:bd
            for j = 1:h
                if tree(i,j) == inf ; continue; end
                treeFit(i,j) = pop.fit(tree(i,j),it);%%%%%%%pb
            end
        end
        [~,idxTree] = sort(treeFit,2);
        finalTreeIdx = zeros(bd,h);
        for i = 1:bd
            for j = 1:h
                finalTreeIdx(i,j) = tree(i,idxTree(i,j));
            end
        end
        [r,c] = find(finalTreeIdx == x.idx);
        for i = 1:size(finalTreeIdx,2)
            if c+i > size(finalTreeIdx,2); break; end
            if finalTreeIdx(r,c+i) == inf; break; end
            N.pos(i,:) = pop.pos(finalTreeIdx(r,c+i),:,it);
            N.fit(i) = pop.fit(finalTreeIdx(r,c+i),it);
            N.idx(i) = finalTreeIdx(r,c+i);
        end

    case 5 % time - var  --------------------------------------------------
        disp("Topology ==> Time Varing")
        if it == 1

            % TOP(full) 
            shuffle = sort(Aidx);
            for i = Aidx
                X(i,it).N.idx = setdiff(shuffle,i);
            end
            rc = fix_ring_connection(Aidx);
            
        else % it = 2:itMax

            for i=bornidx; X(i,it).N.idx=[]; end

            % if(-) : update rc
            if numel(deadidx)~=0
                rc(logical(sum(rc == deadidx,2)),:)=[]; % remove remainConnections include deadidx
                rc(logical(prod(rc == [deadidx+1 deadidx-1],2)),:)=[]; % remove [deadidx+1 deadidx-1] connection
                rc(logical(prod(rc == [deadidx-1 deadidx+1],2)),:)=[]; % because ring make them side by side 
            end

            % (if) dead exist remove and update (else) update
            if numel(deadidx)==0; deadidx=0; end
            for i = Aidx
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
                end %  momkene connectioni ro ezaf koni ke ghablan hazf shode ??
                % connectioni ke ring dorost mikone lazzem nist to rc bere hata 
                % age + dashte bashim
            end

            if numel(bornidx) ~= 0 % (+)
                repeated_idx = setdiff(Aidx,bornidx);
                s=0;
                for i = repeated_idx
                    s = s + X(i,it).N.size;
                end
                C = s / numel(repeated_idx); % number of adding neighbor
                for i = bornidx
                    while true  % ensure random neighbors not nearby i
                        neighbors = repeated_idx(randperm(numel(repeated_idx),C));
                        if ~sum(abs(i - neighbors) == 1); break; end
                    end
                    X(i,it).N.idx = unique([X(i,it).N.idx, neighbors]);
                    for j = neighbors
                        rc = [rc ; [i j]]; % update rc  momkene hamina paiin haz beshe az beineshoon ??
                        X(j,it).N.idx = [X(j,it).N.idx i];
                    end
                end
            end
                

            % input <== rc
            if rem(it,k_topTime) == 0   % every k iteration remove one random particle
                topTime_counter = topTime_counter + 1;
                n_del = popSize - topTime_counter;
                % if number of delete > remain connection => remove all
                % connection which allowed to delete
                if n_del > size(rc,1); n_del = size(rc,1); end
                rndp = randperm(size(rc,1),n_del);
                del_connection = rc(rndp,:);
                rc = rc(setdiff(rc,del_connection,'rows'),:); % rc ==> output
                if size(rc,1) == 0; disp("no more allowed connection"); end
              
                for i = 1:n_del
                    Nidx1 = X(del_connection(i,1),it).N.idx;
                    Nidx2 = X(del_connection(i,2),it).N.idx;
                    X(del_connection(i,1),it).N.idx = Nidx1(Nidx1 ~= del_connection(i,2)); % remove 2 from 1
                    X(del_connection(i,2),it).N.idx = Nidx2(Nidx2 ~= del_connection(i,1)); % remove 1 from 2
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


