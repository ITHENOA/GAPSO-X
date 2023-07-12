function [N,rc]  = TOP(pop,x,N,rc)

global it Aidx
global topCS popCS
global finalPopSize bd %(user defined)

% if nargin < 4; t=it; end

popSize = pop.size(it);
switch topCS
    case 0 % ring  
        disp("Topology ==> ring")
        N=[];
        shuffle = sort(Aidx);
        if x.idx == shuffle(1)
            N.pos = [pop.pos(shuffle(2),:,it); pop.pos(shuffle(end),:,it)];
            N.fit = [pop.fit(shuffle(2),it); pop.fit(shuffle(end),it)];
            N.idx = [shuffle(2) shuffle(end)];
        elseif x.idx == shuffle(end)
            N.pos = [pop.pos(shuffle(1),:,it); pop.pos(shuffle(end-1),:,it)]; 
            N.fit = [pop.fit(shuffle(1),it); pop.fit(shuffle(end-1),it)];
            N.idx = [shuffle(1) shuffle(end-1)];
        else 
            id = find(shuffle == x.idx);
            N.pos = pop.pos([shuffle(id-1), shuffle(id+1)],:,it);
            N.fit = pop.fit([shuffle(id-1), shuffle(id+1)],it);
            N.idx = [shuffle(id-1) shuffle(id+1)];
        end

    case 1 % full   
        shuffle = sort(Aidx);
        exept_i = setdiff(shuffle,x.idx);
        disp("Topology ==> fully")
        N=[];
        N.pos = pop.pos(exept_i,:,it);
        N.fit = pop.fit(exept_i,it);
        N.idx = exept_i;

    case 2 % von newman
        shuffle = sort(Aidx); 
        disp("Topology ==> Von Newman")
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

        [r,c]=find(mtx == x.idx);
        N.pos = [];
        N.fit = [];
        N.idx = [];
        for i=[+1 -1]
           if mtx(r+i,c) ~= 0   % < >
               N.pos = [N.pos; pop.pos(mtx(r+i,c),:,it)];
               N.fit = [N.fit; pop.fit(mtx(r+i,c),it)];
               N.idx = [N.idx; mtx(r+i,c)];
           end
           if mtx(r,c+i) ~= 0   % ^ v
               N.pos = [N.pos; pop.pos(mtx(r,c+i),:,it)];
               N.fit = [N.fit; pop.fit(mtx(r,c+i),it)];
               N.idx = [N.idx; mtx(r,c+i)];
           end
        end

    case 3 % rand   pick 2 random
        disp("Topology ==> rnadom")
        N=[];
        while true
            neighborIdx = randperm(popSize, 2);
            neighborIdx = Aidx(neighborIdx);
            if ~sum(x.idx == neighborIdx); break; end 
        end
        N.pos = pop.pos(neighborIdx,:,it);
        N.fit = pop.fit(neighborIdx,it);
        N.idx = neighborIdx;

    case 4 % hierarchical
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

    case 5 % time - var     need previous N
        disp("Topology ==> Time Varing")
        if it == 1
            shuffle = sort(Aidx);
            for i = Aidx
                exept_i = setdiff(shuffle,X(i,it?).idx);
                disp("Topology ==> fully")
                N=[];
                N.pos = pop.pos(exept_i,:,it);
                N.fit = pop.fit(exept_i,it);
                N.idx = exept_i;
            end
            % remain_connection (rc)
            rc = [Aidx(randperm(numel(Aidx)));Aidx(randperm(numel(Aidx)))];
            rc = connectionsFixer(rc);
        else  
            % input <== rc
            % rc -1 shod?
            % rc + shod?
            if rem(it,k) == 0   % every k iteration remove one random particle
                % k : user define ?
                rndp = randperm(size(rc,2),del);
                del_connection = rc(:,rndp);
                rc = rc(:,setdiff(1:size(rand_idx,2),rndp)); % rc ==> output
                for i = 1:del
                    Nidx1 = X(rand_idx(1,i),it?).N.idx;
                    Nidx2 = X(rand_idx(2,i),it?).N.idx;
                    X(del_connection(1,i)).N.idx = Nidx1(Nidx1 ~= del_connection(2,i)); % remove 2 from 1
                    X(del_connection(2,i)).N.idx = Nidx2(Nidx2 ~= del_connection(1,i)); % remove 1 from 2
                end
                for i = Aidx
                    X(i,it?).N.pos = pop.pos(X(i,it?).N.idx,:,it?);
                    X(i,it?).N.fit = pop.fit(X(i,it?).N.idx,it?);
                    X(i,it?).N.size = numel(X(i,it?).N.idx);
                end
            end
        end
end
N.size = numel(N.idx);