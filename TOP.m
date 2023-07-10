function N  = TOP(pop,x,N)   
if nargin < 2;end

global it Aidx
global topCS popCS
global finalPopSize bd %(user defined)

popSize = pop.size(it);
switch topCS
    case 0 % ring  
        disp("Topology ==> ring")
        N=[];
        % shuffle = sort(Aidx); ???????????? badesh sort konim
        if x.idx == Aidx(1)
            N.pos = [pop.pos(Aidx(2),:,it); pop.pos(Aidx(end),:,it)];
            N.fit = [pop.fit(Aidx(2),it); pop.fit(Aidx(end),it)];
            N.idx = [Aidx(2) Aidx(end)];
        elseif x.idx == Aidx(end)
            N.pos = [pop.pos(Aidx(1),:,it); pop.pos(Aidx(end-1),:,it)]; 
            N.fit = [pop.fit(Aidx(1),it); pop.fit(Aidx(end-1),it)];
            N.idx = [Aidx(1) Aidx(end-1)];
        else 
            id = find(Aidx == x.idx);
            N.pos = pop.pos([Aidx(id-1), Aidx(id+1)],:,it);
            N.fit = pop.fit([Aidx(id-1), Aidx(id+1)],it);
            N.idx = [Aidx(id-1) Aidx(id+1)];
        end

    case 1 % full   
        % shuffle = sort(Aidx); ????????????
        disp("Topology ==> fully")
        N=[];
        N.pos = pop.pos(Aidx,:,it);
        N.fit = pop.fit(Aidx,it);
        N.idx = Aidx;

    case 2 % von newman
        % shuffle = sort(Aidx); ????????????
        disp("Topology ==> Von Newman")
        d = ceil(sqrt(popSize));
        mtx=zeros(d+2); 
        k=0;
        for i=2:d+1
            for j = 2:d+1
                k=k+1;
                mtx(i,j) = Aidx(k);
                if k == numel(Aidx); break; end
            end
            if k == numel(Aidx); break; end
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
            N=[];
            N.pos = pop.pos(Aidx,:,it);
            N.fit = pop.fit(Aidx,it);
            N.idx = Aidx;
        else
            k = randi([1,10],1);
            if popCS == 2 % population => incrimental
                k = popSize * k;
                k = floor(k/(finalPopSize-3));    
            else
                k = finalPopSize * k;
                k = floor(k/(popSize-3));
            end
    
            if rem(it,k) == 0   % every k iteration remove one random particle
                removeIdx = randi(numel(N.idx),1);
                N.pos = [N.pos(1:removeIdx-1,:) ; N.pos(removeIdx+1:end,:)];
                N.fit = [N.fit(1:removeIdx-1,:) ; N.fit(removeIdx+1:end,:)];
                N.idx = [N.idx(1:removeIdx-1,:) ; N.idx(removeIdx+1:end,:)];
            end
        end
end
N.size = numel(N.idx);