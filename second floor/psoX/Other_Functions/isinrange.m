function out = isinrange(x,range)
    out = ones(1,numel(x));
    for i = 1:length(x)
        if x(i) >= range(i,1) && x(i) <= range(i,2)
            out(i) = true;
        else
            out(i) = false;
        end
        out = prod(out);
    end