function [final,time] = PSOX(par,input)
% input = K2H(par,input);
bound = [-3 3;-4 4];
Configuration(par,input,bound)
% run('Configuration.m')

global inertiaW1CS prtRndCS prtInfCS inertia_cte d
global it itMax Aidx deadidx bornidx
global PMI_cte vmax PMR_cte pmICS pmRCS vClampCS
global eI mI ScI FcI eR mR ScR FcR
ini_vel = 0;
% Benchmark-Function
d = 2; % dimansion 
bound = [-3 3;-4 4];

logfile = fopen('PSOX_log.text','w');
try
    currentInfo(logfile)
    % Load initialize (pop, TOP, MOI)
    [pop, X, gb, tree, rc] = INITIALIZE(bound,ini_vel);
    saveIdx = cell(1,itMax);
    
    for it = 1:itMax
        saveIdx{it} = Aidx;
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%% update TOP MOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if it > 1  
            [X,tree,rc]  = TOP(pop,X,tree,rc);
            X = MOI(X);
    
            for i = Aidx
                x = X(i,it);
                % w1
                if ismember(x.idx,bornidx) && inertiaW1CS == 9
                    x.w1 = inertia_cte;
                else
                    x.w1 = W1(inertia_cte,gb,x,bound,pop,X,saveIdx);
                end
                % w2, w3
                [x.w2, x.w3] = W23(X,x);
                % phi
                x.phi = AC(x, X, gb);
                % pm & PrtRnd
                if prtRndCS ~= 0
                    if ismember(x.idx,bornidx) % it == 1 || 
                        x.pmR = PMR_cte;
                    else
                        x.pmR = PM(pmRCS,PMR_cte,eR,mR,ScR,FcR,x,X(i,it-1).pmR,gb);
                    end
                    x.prtRnd = pertRnd(x.pos, x.pmR);
                else
                    x.prtRnd = pertRnd(x.pos, []);
                end
                % Pert_Info
                if prtInfCS ~= 0 || prtInfCS ~= 4
                    if ismember(x.idx,bornidx) % it == 1 || 
                        x.pmI = PMI_cte;
                    else
                        x.pmI = PM(pmICS,PMI_cte,eI,mI,ScI,FcI,x,X(i,it-1).pmI,gb);
                    end
                    x.prtInfo = pertInf(pop.pb.pos(i,:), x.pmI);
                else
                    x.prtInfo = pertInf(pop.pb.pos(i,:), []);
                end
    
                X(i,it) = x;
                x=[];
            end
        end
        
        for i = Aidx
            % DNPP
            X(i,it).dnpp = DNPP(X, X(i,it), pop, saveIdx);
    
            %%%%%%%%%%%%%%%%%%%%% prepare next generation %%%%%%%%%%%%%%%%%%%%%
            % Update Velocity 
            X(i,it+1).v = X(i,it).w1 * X(i,it).v + X(i,it).w2 * X(i,it).dnpp + X(i,it).w3 * X(i,it).prtRnd;
            if vClampCS
                X(i,it+1).v = velClamp(X(i,it+1).v,vmax);
            end
            % Update Position 
            X(i,it+1).pos = X(i,it).pos + X(i,it+1).v; 
            % check bound
            X(i,it+1).pos = posClamp(X(i,it+1).pos,bound);
            % Update Fitness
            X(i,it+1).fit = f(X(i,it+1).pos);
            % Update pop
            pop.v(i,:,it+1) = X(i,it+1).v;
            pop.pos(i,:,it+1) = X(i,it+1).pos;
            pop.fit(i,it+1) = X(i,it+1).fit;
            pop.size(it+1) = pop.size(it);
        end % END i
        
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
       
        %%%%%%%%%%%%%%%%%%%%%%% unstuck & reinitial %%%%%%%%%%%%%%%%%%%%%%%%%%%
        [pop, X, gb] = stagnation_detection(pop, X, gb);
        [pop, X, gb] = particles_reinitialization(pop, X, gb, bound);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%% Update Population %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        pop = POP(pop,bound,gb);  % +1 | +1,-1 | -1 | +particlesToAdd
    
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
    
        % act = bench_func(pop.pos(Aidx,:,it+1),gb.fit,pop.size(it+1));
        % if gb.fit(end) < -6.5; break; end
    end % END it
    final = gb.fit(end);
    time=toc;
    fprintf(logfile,'\n--------------- SUCCESS --------------\n');
    fprintf(logfile,'Global-Best = %f \n f_counter = %d \n',gb.fit(end),f_counter);
catch err
    fprintf(logfile,'\n--------------- ERROR --------------\n');
    fprintf(logfile,'%s\n',err.message);
    fprintf(logfile, 'Stack trace:\n');
    for k = 1:length(err.stack)
        fprintf(logfile, 'File: %s\n', err.stack(k).file);
        fprintf(logfile, 'Function: %s\n', err.stack(k).name);
        fprintf(logfile, 'Line: %d\n\n', err.stack(k).line);
    end
    fprintf(logfile, '\n');
    final=inf;
    time=inf;
end
fclose(logfile);
% disp("END")
% disp("f_counter = "+num2str(f_counter))
% disp("Final gb = "+num2str(gb.fit(end)))
% disp("Actual : "+num2str(act))