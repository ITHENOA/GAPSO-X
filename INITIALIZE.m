function [pop, X, gb, pb_it] = INITIALIZE(bound)

global popCS  
global it itMax finalPopSize deadidx Aidx newidx bornidx best d
global particles initialPopSize

deadidx = [];   % Dead indeces
bornidx = [];   % new born indeces
% Aidx :          Alive indeces =>  for it=1 equal to 1:popSize
% newidx :        maximum usage of index
%-----------------------------

% initialize pop ------------------------------
if popCS ~= 2   % for all 

    pop.pos(1:particles,:,1) = ini_pop(particles, bound);
    pop.fit(1:particles,1) = f(pop.pos(1:particles,:,1));
    [pop.fit(:,1),idx] = sort(pop.fit(:,1));
    pop.pos(:,:,1) = pop.pos(idx,:,1);
    Aidx = 1:particles;
    pop.size(1) = numel(Aidx);
    newidx = particles;
    pop.v(1:particles,:,1) = zeros(particles,d,1);                          

else  % for incrimental  % ??

    pop.pos(1:initialPopSize,:,1) = ini_pop(initialPopSize, bound);
    pop.fit(1:initialPopSize,1) = f(pop.pos(1:initialPopSize,:,1));     
    [pop.fit(:,1),idx] = sort(pop.fit(:,1));
    pop.pos(:,:,1) = pop.pos(idx,:,1);
    Aidx = 1:initialPopSize;
    pop.size(1) = numel(Aidx);
    newidx = initialPopSize;
    pop.v(1:initialPopSize,:,1) = zeros(initialPopSize,d,1);                

end

% personal best
pb_it.fit = pop.fit(:,1);
pb_it.pos = pop.pos(:,:,1);
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

    x.pb.fit = pb_it.fit(i);
    x.pb.pos = pb_it.pos(i,:,1);

    x.N = TOP(pop,x); % sorted in it == 1  % to hierical momkene N = [] bashe bara bazia   ??
    x.I = MOI(x); 

    x.lb.fit = x.N.fit(best);
    x.lb.pos = x.N.pos(best,:);
    x.lb.idx = x.N.idx(best);
    
    X(i) = x;
end