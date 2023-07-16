function [nc1,nc2]=cross_over(p1,p2,cs,crP)
nc1=p1;
nc2=p2;
if rand<crP
    flag=1;
    while flag 
        cr_percent=rand;
        nc1=zeros(size(p1,1),size(p1,2),size(p1,3));
        nc2=zeros(size(p1,1),size(p1,2),size(p1,3));
        for i=1:size(p1,3)
            for j=1:size(p1,1)
                s=sum(cs(j,5:4+cs(j,4,i),i));
                crN=1+floor(s*cr_percent);
                c11=p1(j,1:crN,i);
                c12=p2(j,crN+1:end,i);
                nc1(j,:,i)=[c11 c12];
                c21=p2(j,1:crN,i);
                c22=p1(j,crN+1:end,i);
                nc2(j,:,i)=[c21 c22];
            end
        end
        flag=0;
        for i=1:size(p1,3)
            for j=1:size(p1,1)
                if sum(nc1(j,nc1(j,:,i)~=inf,i))==0 && sum(nc1(j,:,i)~=inf)>0
                    flag=1;
                end
                if sum(nc2(j,nc2(j,:,i)~=inf,i))==0 && sum(nc2(j,:,i)~=inf)>0
                    flag=1;
                end
            end
        end
    end
end


