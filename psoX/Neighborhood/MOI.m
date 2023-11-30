function X = MOI(X) % PSOX => MOI
global moiCS Aidx it

switch moiCS
    case 0  % best of neighborhood ----------------------------------------
        % for i = Aidx
        parfor i = Aidx
            if ismember(i, X(i,it).N.idx) % i is in his own neighborhood
                id = find(i == X(i,it).N.idx);
                if i ~= X(i,it).N.idx(1)  % i isnt best of his own neighborhood
                    X(i,it).I.pos = [X(i,it).N.pos(1,:); X(i,it).N.pos(id,:)];
                    X(i,it).I.fit = [X(i,it).N.fit(1); X(i,it).N.fit(id)];
                    X(i,it).I.idx = [X(i,it).N.idx(1) i];
                    X(i,it).I.size = numel(X(i,it).I.idx);
                else % i is the best of his own neighborhood
                    X(i,it).I.pos = X(i,it).N.pos(1,:);
                    X(i,it).I.fit = X(i,it).N.fit(1);
                    X(i,it).I.idx = X(i,it).N.idx(1);
                    X(i,it).I.size = numel(X(i,it).I.idx);
                end
            else % just best
                X(i,it).I.pos = X(i,it).N.pos(1,:);
                X(i,it).I.fit = X(i,it).N.fit(1);
                X(i,it).I.idx = X(i,it).N.idx(1);
                X(i,it).I.size = numel(X(i,it).I.idx);
            end
        end


    case 1 % fully informed -----------------------------------------------
        [X(Aidx,it).I] = deal(X(Aidx,it).N); % I <== N.(pos & fit & idx & size)

    case 2 % Weighted Ranking ---------------------------------------------
        % for i = Aidx
        parfor i = Aidx
            lowerPart=2^(X(i,it).N.size)-1;
            upperPart=zeros(1,X(i,it).N.size);
            for j=0:X(i,it).N.size-1
                upperPart(j+1)=2^(X(i,it).N.size-1-j);
            end
            w = upperPart/lowerPart;
            X(i,it).I = X(i,it).N; % I <== N.(pos & fit & idx & size)
            X(i,it).I.weight = w;
        end
        

    case 3 % Random Informant ---------------------------------------------
        % for i = Aidx
        parfor i = Aidx
            n=2; % number of neighbor for i
            if X(i,it).N.size < 2; n=1; end
            idx = randperm(X(i,it).N.size,n);
            X(i,it).I.pos = X(i,it).N.pos(idx,:);
            X(i,it).I.fit = X(i,it).N.fit(idx);
            X(i,it).I.idx = X(i,it).N.idx(idx);
            X(i,it).I.size = numel(X(i,it).I.idx);
        end

       
end
