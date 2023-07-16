function p_select=select_ranking(p,y)
p_sort=zeros(size(p,1),size(p,2),size(p,3));
[~,index]=sort(y);
p_sort(:,:,:,1:size(p,4))=p(:,:,:,index);
pool=length(y)*(length(y)+1)/2;
s=randi(pool);
n=length(y);
sum=n;
for i=1:length(y)
    if s>sum
        sum=sum+(n-i);
    else 
        break;
    end
end
p_select=p_sort(:,:,:,i);
end