function tree=Top_hierarchical_ini(p_best)
global Aidx bd
[~,index]=sort(p_best);
size_m=1;
while true
    sum=1;
    for i=1:size_m
        sum=sum+bd^i;
    end
    if sum>length(index)
        break;
    end
    size_m=size_m+1;
end
tree=zeros(size_m+1,bd^size_m);
counter=0;
for i=1:size_m+1
    if i<=2
        for j=1:bd^(i-1)
            counter=counter+1;
            if counter>length(index);break;end
            tree(i,j)=Aidx(index(counter));
        end
    else
        for j=1:bd
            for k=0:bd^(i-2)-1
                counter=counter+1;
                if counter>length(index);break;end
                tree(i,j+bd*k)=Aidx(index(counter));
            end
        end
    end
end