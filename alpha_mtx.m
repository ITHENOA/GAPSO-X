function alpha = alpha_mtx(pop, saveIdx)
global d it Aidx 
global alpha_mtxCS2 
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha

switch alpha_mtxCS2
    case 0 % cte ----------------------------------------------------------
        % disp("alpha_mtx ==> cte")
        alpha = ini_alpha_mtx;

    case 1 % gauss --------------------------------------------------------
        % disp("alpha_mtx ==> gauss")
        alpha = normrnd(0, sigma_alpha);

    case 2 % adaptive -----------------------------------------------------
        % disp("alpha_mtx ==> adaptive")
        % ir: is the number of improved particles in the last iteration divided by the population size.
        repeat_idx = intersect(Aidx,saveIdx{it-1});
        ir = sum([pop.fit(repeat_idx,it)] < [pop.fit(repeat_idx,it-1)]) / numel(repeat_idx); % pop.size or numel(repeat_idx)
        % ir = sum(pop.fit(:,it) < pop.fit(:,it-1)) / pop.size;
        sigma_alpha = z_alpha * ir/sqrt(d) + ro_alpha;
end