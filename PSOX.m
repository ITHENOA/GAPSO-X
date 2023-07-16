clear;clc;close all;tic
run('Configuration.m')

global alpha_mtxCS2 inertiaW1CS
global it itMax Aidx deadidx bornidx

% Load initialize (pop, TOP, MOI)
[pop, ini_X, gb, tree, rc] = INITIALIZE(bound,ini_vel);
saveIdx = cell(1,itMax);

for it = 1:itMax
    % it
    saveIdx{it} = Aidx;

    %%%%%%%%%%%%%%%%%%%%%%%%%%% update TOP MOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if it > 1  
        [X,tree,rc]  = TOP(pop,X,tree,rc);
        X = MOI(X);
    end
    
    %%%%%%%%%%%%%% w123,pm,phi,dnpp,prtInfo,prtRnd,next(pop) %%%%%%%%%%%%%%
    for i = Aidx   
        if it == 1
            x = ini_X(i,it);
        else
            x = X(i,it);
        end
        % w1
        if it==3 && i==21
            i
        end
        if it == 1
            if inertiaW1CS == 8 || inertiaW1CS == 9 % need previos iteration
                x.w1 = ini_w1_45;
            else
                x.w1 = inertiaW1(ini_w1_45,gb,x,bound,pop,[],[]);
            end
        elseif ismember(x.idx,bornidx) && inertiaW1CS == 9
            x.w1 = ini_w1_9born;
        else
            x.w1 = inertiaW1(ini_w1_45,gb,x,bound,pop,X,saveIdx);
        end
        % w2, w3
        [x.w2, x.w3] = param_W23(x.w1);
        % Perturbation Magnitud (PM)

        if it == 1 || ismember(x.idx,bornidx)
            x.pm = ini_pm_234born;
        else
            x.pm = PM(x, X(i,it-1).pm, gb);
        end

        % Pert_Info
        x.prtInfo = pertInf(pop.pb.pos(i,:), x.pm);
        % phi
        x.phi = AC(x, gb);
        % Pert_Rand
        x.prtRnd = pertRnd(x.pos, x.pm);

        % ----- save -----
        X(i,it) = x;
        x=[];
    end
    for i = Aidx
        % DNPP
        if it == 1 && alpha_mtxCS2 == 2 % adaptive alpha Need previous iteration
            alpha_mtxCS2 = 0; % use cte alpha
        	X(i,it).dnpp = DNPP(X, X(i,it), pop, saveIdx); 
            alpha_mtxCS2 = 2; % back to adaptive alpha
        else
            X(i,it).dnpp = DNPP(X, X(i,it), pop, saveIdx);
        end
        
        %%%%%%%%%%%%%%%%%%%%% prepare next generation %%%%%%%%%%%%%%%%%%%%%
        % Update Velocity 
        X(i,it+1).v = X(i,it).w1 * X(i,it).v + X(i,it).w2 * X(i,it).dnpp + X(i,it).w3 * X(i,it).prtRnd;
        % Update Position 
        X(i,it+1).pos = X(i,it).pos + X(i,it+1).v; 
        % check bound
        X(i,it+1).pos = boundCheck(X(i,it+1).pos,bound);
        % Update Fitness
        X(i,it+1).fit = f(X(i,it+1).pos);
        % Update pop
        pop.v(i,:,it+1) = X(i,it+1).v;
        pop.pos(i,:,it+1) = X(i,it+1).pos;
        pop.fit(i,it+1) = X(i,it+1).fit;
        pop.size(it+1) = pop.size(it);
    end % END i
    clear ini_X 
    
    [X(:,it+1).idx] = deal(X(:,it).idx);    

    %%%%%%%%%%%%%%%%%%%%%%%%% update pb and gb %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = Aidx    
        if X(i,it+1).fit < X(i,it).pb.fit
            X(i,it+1).pb.pos = X(i,it+1).pos;
            X(i,it+1).pb.fit = X(i,it+1).fit;
            X(i,it+1).pb.it = it+1;
        else
            X(i,it+1).pb = X(i,it).pb;
        end
        pop.pb.pos(i,:) = X(i,it+1).pb.pos;
        pop.pb.fit(i) = X(i,it+1).pb.fit;
    end % END i (update pb)
    [gb.fit(it+1), id] = min(pop.pb.fit);
    gb.pos(it+1,:) = pop.pb.pos(id,:);
   

    % apply stagnation detection, particles reinitialization %optional
    
    %%%%%%%%%%%%%%%%%%%%%%%%%% Update Population %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    pop = populationCS(pop,bound,gb);  % +1 | +1,-1 | -1 | +particlesToAdd

    if numel(deadidx) ~= 0 || numel(bornidx) ~= 0  % have (+ | -)
        % sort idxs
        [~, idx] = sort(pop.fit(Aidx,it));
        Aidx = Aidx(idx);
        % update personal best
        if numel(deadidx) ~= 0  % have (-)
            pop.pb.pos(deadidx,:) = inf;
            pop.pb.fit(deadidx) = inf;
        end
        if numel(bornidx) ~= 0  % have (+)
            pop.pb.pos(bornidx,:) = pop.pos(bornidx,:,it+1);
            pop.pb.fit(bornidx) = pop.fit(bornidx,it+1);
            pop.v(bornidx,:,it+1) = ini_vel;    % be sorate it haye ghbl 0 ezaf mikone
        end
        % update global best
        [gb.fit(it+1), idx] = min(pop.pb.fit(Aidx));
        gb.pos(it+1,:) = pop.pb.pos(Aidx(idx),:);
        gb.idx(it+1) = Aidx(idx);
        
        % update X
        for i = Aidx
            X(i,it+1).idx = i;
            X(i,it+1).pos = pop.pos(i,:,it+1);
            X(i,it+1).fit = pop.fit(i,it+1);
            X(i,it+1).v = pop.v(i,:,it+1);
            X(i,it+1).pb.pos = pop.pb.pos(i,:);
            X(i,it+1).pb.fit = pop.pb.fit(i);
        end
    end

    % bench_func(pop.pos(Aidx,:,it+1),gb.fit,pop.size(it+1))
    % n=floor(numel(Aidx) * .2);
    % m=floor(numel(Aidx) * .7);
    % for i = Aidx(1:n)
    %     m=m+1;
    %     scatter(X(Aidx(m),it+1).pos(1,1),X(Aidx(m),it+1).pos(1,2))
    %     [X(Aidx(m),it+1).pos, X(Aidx(m),it+1).fit] = RS(X(i,it+1).pos,bound);
    %     scatter(X(Aidx(m),it+1).pos(1,1),X(Aidx(m),it+1).pos(1,2),'r')
    % end


    bench_func(pop.pos(Aidx,:,it+1),gb.fit,pop.size(it+1))
    if gb.fit(end) < -6.5; break; end
end % END it
toc
disp("END")
disp("f_counter = "+num2str(f_counter))
disp("Final gb = "+num2str(gb.fit(end)))
disp("Actual : -6.5367")