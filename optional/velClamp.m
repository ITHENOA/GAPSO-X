function vnew = velClamp(v,vmax)
global d vClampCS2

switch vClampCS2
    case 0 
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
    case 1
        vnew = zeros(1,numel(v));
        for j = 1:d
            if v(j) > vmax(j)
                vnew(j) = rand * (vmax(j) + vmax(j)) - vmax(j) ;
            elseif v(j) < -vmax(j)
                vnew(j) = rand * (vmax(j) + vmax(j)) - vmax(j) ;
            else
                vnew(j) = v(j);
            end
        end
end