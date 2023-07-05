function perted = pertInf(vector,x,fit,N,pm,gb) % ok +2
global pertInfCS
global lambda bt %(user defined)

switch  pertInfCS
    case 0 % None   ok
        perted = vector;

    case 1 % gauss  ok
        perted = zeros(size(vector,2),1);
        pm = PM(x,fit,N,pm,gb);
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',2,'beta',0,'gam',...
                pm(end)/sqrt(2),'delta',vector(i)));           
        end

    case 2 % levy ok
        perted = zeros(size(vector,2),1);
        pm = PM(x,fit,N,pm,gb);
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',lambda,'beta',0,'gam',pm(end),'delta',pm(end)+vector(i)));
            % 1<landa<2
        end

    case 3 % cauchy     +1
        perted = zeros(size(vector,2),1);
        pm = PM(x,fit,N,pm,gb);
        for i = 1:size(vector,2)
            perted(i) = random(makedist('Stable','alpha',1,'beta',0,'gam',pm(end),'delta',vector(i)));
        end

    case 4 % uniform +1
        s = rand(size(vector)) * (2*bt) - bt;
        perted = vector + s .* vector;
 

end