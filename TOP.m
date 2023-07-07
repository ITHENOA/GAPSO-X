function N  = TOP(pop,x,d,N)    % ok
global it
global topCS 
global finalPopSize bd %(user defined)

% N = [];
popSize = pop.size(it);% popSize = size(pop,1);
% idxi = find(ismember(pop, xi, 'rows'));
switch topCS
    case 0 % ring   ok
        % N = zeros(3,d);%new
        if x.idx == 1
            N.pos = [pop.pos(2,:,it); pop.pos(popSize,:,it)];%[pop(2,:);pop(end,:)]; self?
            N.fit = [pop.fit(2,it); pop.fit(popSize,it)];%new
            N.idx = [2 popSize];
        elseif x.idx == popSize
            N.pos = [pop.pos(1,:,it); pop.pos(popSize-1,:,it)]; %[pop(1,:);pop(end-1,:)]; self?
            N.fit = [pop.fit(1,it); pop.fit(popSize-1,it)];%new
            N.idx = [1 popSize-1];%new
        else 
            N.pos = pop.pos(x.idx-1:x.idx+1,:,it);%pop(idxi-1:idxi+1);
            N.fit = pop.fit(x.idx-1:x.idx+1,it);%new
            N.idx = x.idx-1:x.idx+1;%new
        end

    case 1 % full   ok
        % N = zeros(popSize,d);%new
        N.pos = pop.pos(1:popSize,:,it);%new
        N.fit = pop.fit(1:popSize,it);%new
        N.idx = 1:popSize;%new

    case 2 % von    ok
        d = ceil(sqrt(popSize));
        mtx=zeros(d+2); 
        mtx(2:end-1,2:end-1) = sort(sort(magic(d)),2);
        mtx(mtx>size(pop,1)) = 0;
        [r,c]=find(mtx == x.idx);
        for i=[+1 -1]
           if mtx(r+i,c) ~= 0
               N.pos = [N.pos; pop.pos(mtx(r+i,c),:,it)];%[N;pop(mtx(r+i,c),:)];
               N.fit = [N.fit; pop.fit(mtx(r+i,c),it)];%new
               N.idx = [N.idx; mtx(r+i,c)];%new ??
           end
           if mtx(r,c+i) ~= 0
               N.pos = [N.pos; pop.pos(mtx(r,c+i),:,it)];%[N;pop(mtx(r,c+i),:)];
               N.fit = [N.fit; pop.fit(mtx(r,c+i),it)];%new
               N.idx = [N.idx; mtx(r,c+i)];%new  ??
           end
        end

    case 3 % rand   pick 2 random
        while true
            neighborIdx = randperm(popSize, 2);
            if ~sum(x.idx == neighborIdx); break; end 
        end
        N.pos = pop.pos(neighborIdx,:,it);%new
        N.fit = pop.fit(neighborIdx,it);%new
        N.idx = neighborIdx;%new
        % for i = 1:numel(neighborIdx)
        %     % N = [N; pop(neighborIdx(i), :)];
        % end

    case 4 % hierarchical       need previous N
        h = ceil(popSize / bd);
        remain = popSize - h * bd;
        tree = reshape([randperm(popSize), zeros(1,-remain)], bd, h);
        treeFit = zeros(bd,h);
        for i = 1:bd
            for j = 1:h
                if tree(i,j) == 0 ; continue; end
                treeFit(i,j) = pop.fit(tree(i,j),it);%fit(tree(i,j));
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
        N.pos = pop.pos(finalTreeIdx(r,c:end),:,it);%pop(finalTreeIdx(r,c:end),:);
        N.fit = pop.fit(finalTreeIdx(r,c:end),it);%new
        N.idx = finalTreeIdx(r,c:end);%new  ??

    case 5 % time - var     need previous N
        k = randi([1,10],1);
        if populationCS_idx == 2%??
            k = popSize * k;
            k = floor(k/(finalPopSize-3));    
        else
            k = finalPopSize * k;
            k = floor(k/(popSize-3));
		    % esteps = finalPopSize-3;
        end
        if rem(it,k) == 0   % every k iteration remove one random particle
            % N = [pop(1:randi(popSize,1)-1,:) ; pop(randi(popSize,1)+1:end,:)];
            removeIdx = randi(popSize,1);%new
            N.pos = [N.pos(1:removeIdx-1,:) ; N.pos(removeIdx+1:end,:)];%new
            N.fit = [N.fit(1:removeIdx-1,:) ; N.fit(removeIdx+1:end,:)];%new
            N.idx = [N.idx(1:removeIdx-1,:) ; N.idx(removeIdx+1:end,:)];%new    ??
        end
end