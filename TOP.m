function N  = TOP(pop,xi,it)    % ok
global topCS 
global finalPopSize bd %(user defined)

N = [];
popSize = size(pop,1);
idxi = find(ismember(pop, xi, 'rows'));
switch topCS
    case 0 % ring   ok
        if idxi==1
            N = [pop(2,:);pop(end,:)];
        elseif idxi==popSize
            N = [pop(1,:);pop(end-1,:)];
        else 
            N = pop(idxi-1:idxi+1);
        end

    case 1 % full   ok
        N = pop;

    case 2 % von    ok
        d = ceil(sqrt(popSize));
        mtx=zeros(d+2); 
        mtx(2:end-1,2:end-1) = sort(sort(magic(d)),2);
        mtx(mtx>size(pop,1)) = 0;
        [r,c]=find(mtx == idxi);
        for i=[+1 -1]
           if mtx(r+i,c) ~= 0
               N=[N;pop(mtx(r+i,c),:)];
           end
           if mtx(r,c+i) ~= 0
               N=[N;pop(mtx(r,c+i),:)];
           end
        end

    case 3 % rand   ok
        while true
            neighborIdx = randperm(popSize, 2);
            if ~sum(idxi == neighborIdx); break; end 
        end
        for i = 1:numel(neighborIdx)
            N = [N; pop(neighborIdx(i), :)];
        end

    case 4 % hierarchical       ok
        h = ceil(popSize / bd);
        remain = popSize - h * bd;
        tree = reshape([randperm(popSize) , zeros(1,-remain)], bd, h);
        treeFit=zeros(bd,h);
        for i=1:bd
            for j=1:h
                if tree(i,j) == 0 ; continue; end
                treeFit(i,j)=fit(tree(i,j));
            end
        end
        [~,idxTree] = sort(treeFit,2);
        finalTreeIdx=zeros(bd,h);
        for i=1:bd
            for j=1:h
                finalTreeIdx(i,j)=tree(i,idxTree(i,j));
            end
        end
        [r,c]=find(finalTreeIdx == idxi);
        N = pop(finalTreeIdx(r,c:end),:);

    case 5 % time - var     ok
        k = randi([1,10],1);
        if populationCS_idx == 2
            k = popSize * k;
            k = floor(k/(finalPopSize-3));    
        else
            k = finalPopSize*k;
            k = floor(k/(popSize-3));
		    % esteps = finalPopSize-3;
        end
        if rem(it,k) == 0   % every k iteration remove one random particle
            N = [pop(1:randi(popSize,1)-1,:) ; pop(randi(popSize,1)+1:end,:)];
        end
end