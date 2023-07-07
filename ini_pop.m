function pop=ini_pop(n,boundries)
ndim=size(boundries,1);
pop=zeros(n,ndim);
    for i=1:ndim
        dim=linspace(boundries(i,1),boundries(i,2),n*5);
        index=randperm(length(dim),n);
        pop(:,i)=dim(index);
    end