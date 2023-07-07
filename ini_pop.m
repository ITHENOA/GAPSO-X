function pop = ini_pop(n, bound)

ndim=size(bound,1);
pop=zeros(n,ndim);
for i=1:ndim
    dim=linspace(bound(i,1),bound(i,2),n*5);
    index=randperm(length(dim),n);
    pop(:,i)=dim(index);
end