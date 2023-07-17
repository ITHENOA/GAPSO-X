function vnew = velClamp(v,vmax)
vnew = zeros(1,numel(v));
for j = 1:d
    if v(j) > vmax(j)
        vnew(j) = vmax(j);
    elseif v(j) < -vmax(j)
        vnew(j) = -vmax(j);
    else
        vnew(j) = v(j);
    end
end