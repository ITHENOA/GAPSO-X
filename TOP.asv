function N  = TOP(pop,x,d,N)    % ok
global it
global topCS popCS
global finalPopSize bd %(user defined)

% N = [];
popSize = pop.size(it);
switch topCS
    case 0 % ring   ok
        N=[];
        if x.idx == 1
            N.pos = [pop.pos(2,:,it); pop.pos(popSize,:,it)];
            N.fit = [pop.fit(2,it); pop.fit(popSize,it)];
            N.idx = [2 popSize];
        elseif x.idx == popSize
            N.pos = [pop.pos(1,:,it); pop.pos(popSize-1,:,it)]; 
            N.fit = [pop.fit(1,it); pop.fit(popSize-1,it)];
            N.idx = [1 popSize-1];
        else 
            N.pos = pop.pos([x.idx-1, x.idx+1],:,it);
            N.fit = pop.fit([x.idx-1, x.idx+1],it);
            N.idx = [x.idx-1 x.idx+1];
        end

    case 1 % full   ok
        N=[];
        N.pos = pop.pos(1:popSize,:,it);
        N.fit = pop.fit(1:popSize,it);
        N.idx = 1:popSize;

    case 2 % von    ok
        d = ceil(sqrt(popSize));
        mtx=zeros(d+2); 
        mtx(2:end-1,2:end-1) = sort(sort(magic(d)),2);
        mtx(mtx>size(pop,1)) = 0;
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
               N.idx = [N.idx; mtx(r,c+i)];%new  ??
           end
        end

    case 3 % rand   pick 2 random
        N=[];
        while true
            neighborIdx = randperm(popSize, 2);
            if ~sum(x.idx == neighborIdx); break; end 
        end
        N.pos = pop.pos(neighborIdx,:,it);
        N.fit = pop.fit(neighborIdx,it);
        N.idx = neighborIdx;


    case 4 % hierarchical
        h = ceil(popSize / bd); % number of members in each branch
        remain = popSize - h * bd;  % remain members    (bd=5; 4*5 & 1*3 ;popSize=23)
        tree = reshape([randperm(popSize), zeros(1,-remain)], bd, h);
        treeFit = zeros(bd,h);
        for i = 1:bd
            for j = 1:h
                if tree(i,j) == 0 ; continue; end
                treeFit(i,j) = pop.fit(tree(i,j),it);
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
        N.pos = pop.pos(finalTreeIdx(r,c:end),:,it);
        N.fit = pop.fit(finalTreeIdx(r,c:end),it);
        N.idx = finalTreeIdx(r,c:end);

    case 5 % time - var     need previous N
        k = randi([1,10],1);
        if popCS == 2 % population => incrimental
            k = popSize * k;
            k = floor(k/(finalPopSize-3));    
        else
            k = finalPopSize * k;
            k = floor(k/(popSize-3));
        end
        if rem(it,k) == 0   % every k iteration remove one random particle
            removeIdx = randi(popSize,1);
            N.pos = [N.pos(1:removeIdx-1,:) ; N.pos(removeIdx+1:end,:)];
            N.fit = [N.fit(1:removeIdx-1,:) ; N.fit(removeIdx+1:end,:)];
            N.idx = [N.idx(1:removeIdx-1,:) ; N.idx(removeIdx+1:end,:)];
        end
end