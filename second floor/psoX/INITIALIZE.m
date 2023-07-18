function [pop, X, gb, tree, rc] = INITIALIZE(bound,ini_vel)

global popCS  
global it deadidx Aidx newidx bornidx best d
global particles initialPopSize inertiaW1CS inertia_cte prtRndCS prtInfCS PMI_cte PMR_cte

deadidx = [];   % Dead indeces
bornidx = [];   % new born indeces
% Aidx :          Alive indeces =>  for it=1 equal to 1:popSize
% newidx :        maximum usage of index
%-----------------------------
if popCS ~= 2
    popSize = particles;
else
    popSize = initialPopSize;
end
% initialize pop ------------------------------
pop.pos(1:popSize,:,1) = ini_pop(popSize, bound);
pop.fit(1:popSize,1) = f(pop.pos(1:popSize,:,1));
[pop.fit(:,1),idx] = sort(pop.fit(:,1));
pop.pos(:,:,1) = pop.pos(idx,:,1);
Aidx = 1:popSize;
pop.size(1) = numel(Aidx);
newidx = popSize;
pop.v(1:popSize,:,1) = ones(popSize,d,1) * ini_vel;                          


% personal best
pop.pb.fit = pop.fit(:,1);
pop.pb.pos = pop.pos(:,:,1);
% global best
gb.fit(1) = pop.fit(best,1);
gb.pos(1,:) = pop.pos(best,:,1);
gb.idx(1) = best;

% X = struct('idx',[],'pos',[],'fit',[],'v',[],'pb',[],'N',[],'I',[],'lb',...
%     [],'w1',[],'w2',[],'w3',[],'phi',[],'pmR',[],'pmI',[],'prtInfo',[],'prtRnd',[]);
% initial Neighborhood
it = 1;
for i = Aidx
    x.idx = i;
    x.pos = pop.pos(i,:);
    x.fit = pop.fit(i);
    x.v = pop.v(i,:,1); 
    % pb
    x.pb.fit = pop.pb.fit(i);
    x.pb.pos = pop.pb.pos(i,:);
    x.pb.it = 1;
    
    X(i,it) = x;
    x=[];
end
[X,tree,rc] = TOP(pop,X,[],[]);
X = MOI(X);
for i = Aidx
    % w1
    if inertiaW1CS == 8 || inertiaW1CS == 9 % need previos iteration
        X(i,it).w1 = inertia_cte;
    else
        X(i,it).w1 = W1(inertia_cte,gb,X(i,it),bound,pop,[]);
    end
    % w2, w3
    [X(i,it).w2, X(i,it).w3] = W23([],X(i,it));
    % phi
    X(i,it).phi = AC(X(i,it), gb);
    % pm & prt-R
    if prtRndCS ~= 0
        X(i,it).pmR = PMR_cte;
        X(i,it).prtRnd = pertRnd(X(i,it).pos, X(i,it).pmR);
    else
        X(i,it).prtRnd = pertRnd(X(i,it).pos, []);
    end
    % pm & prt-I
    if prtInfCS ~= 0 || prtInfCS ~= 4
        X(i,it).pmI = PMI_cte;
        X(i,it).prtInfo = pertInf(pop.pb.pos(i,:), X(i,it).pmI);
    else
        X(i,it).prtInfo = pertInf(pop.pb.pos(i,:), []);
    end
end


