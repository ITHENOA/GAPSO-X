function [pop, X, gb, rc] = INITIALIZE(bound,ini_vel)

global popCS  
global it itMax finalPopSize deadidx Aidx newidx bornidx best d
global particles initialPopSize

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

X = struct('idx',[],'pos',[],'fit',[],'v',[],'pb',[],'N',[],'I',[],'lb',[]);
% initial Neighborhood
it = 1;
for i = Aidx
    x = struct('idx',[],'pos',[],'fit',[],'v',[],'pb',[],'N',[],'I',[],'lb',[]);
    x.idx = i;
    x.pos = pop.pos(i,:);
    x.fit = pop.fit(i);
    x.v = pop.v(i,:,1); 

    x.pb.fit = pop.pb.fit(i);
    x.pb.pos = pop.pb.pos(i,:);
    x.pb.it = 1;
    
    X(i,it) = x;
end
[X,rc] = TOP(pop,X,[]); % rnd ok 
X = MOI(X);

