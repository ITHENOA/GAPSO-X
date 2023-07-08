function outVector = Mtx(vector,d,pop)
global it itMax
global MtxCS

switch MtxCS
    case 0 % None  ok
        outVector = vector;
        
    case 1 % rnd diagonal    ok
        mtx = rand(d,1).*eye(d);
        outVector = vector * mtx;?   % vec*mtx ?? 1*3 * 3*3 = 1*3 ok mishe

    case 2 % rnd linear      ok
        mtx = rand(1,1).*eye(d);
        outVector = vector * mtx;

    case 3 % exp map        ok
        alpha = alpha_mtx(d,pop,it);
        A = rand(d)-0.5;
        mtx = eye(d) + (alpha * pi / 180 * (A - A'));
        outVector = vector * mtx;

    case 4 % Eul rot
        alpha = alpha_mtx(d,pop,it);
        plain = randperm(d,2);
        vector(plain(1)) = vector(plain(1)) * cosd(alpha) - vector(plain(2)) * sind(alpha);
        vector(plain(2)) = vector(plain(2)) * cosd(alpha) + vector(plain(1)) * sind(alpha);
        outVector = vector;

    case 5 % Eul rot_all
        alpha = alpha_mtx(d,pop,it);
        for i=1:d-1
            for j = i+1:d
                vector(i) = vector(i) * cosd(alpha) - vector(j) * sind(alpha);
                vector(j) = vector(j) * cosd(alpha) + vector(i) * sind(alpha);
            end
        end
        outVector = vector;

    case 6 % increasing group based
        gt = round((d-1)/(itMax - 1) * (it-1) +1);
        rand_group = rand(gt,1);
        rnd_idx = randperm(d);
        n_group = ceil(d/gt);
        n_member=ceil(d/n_group);
        mtx = eye(d);
        for i = 1:n_group
            if i == n_group
                vec=rnd_idx((i-1)*n_group+1:end);
                for j=1:length(vec)
                mtx(vec(j),vec(j))=rand_group(i);
                end
            else
                vec=rnd_idx((i-1)*n_group+1:n_group*i);
                for j=1:n_member
                mtx(vec(j),vec(j))=rand_group(i);
                end
            end
        end
        outVector = vector * mtx; 
end