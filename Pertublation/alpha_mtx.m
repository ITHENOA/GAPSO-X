function alpha = alpha_mtx(pop, saveIdx)
global d it Aidx 
global alpha_mtxCS2 
global ini_alpha_mtx sigma_alpha z_alpha ro_alpha

switch alpha_mtxCS2
    case 0 % cte ----------------------------------------------------------
        alpha = ini_alpha_mtx;

    case 1 % gauss --------------------------------------------------------
        alpha = normrnd(0, sigma_alpha);

    case 2 % adaptive -----------------------------------------------------
        % ir: is the number of improved particles in the last iteration divided by the population size.
        repeat_idx = intersect(Aidx,saveIdx{it-1});
        ir = sum([pop.fit(repeat_idx,it)] < [pop.fit(repeat_idx,it-1)]) / numel(repeat_idx);
        sigma_alpha2 = z_alpha * ir/sqrt(d) + ro_alpha;
        alpha = normrnd(0, sigma_alpha2);
end