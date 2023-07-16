function output_p=mutation(input_p,muP)
flag=1;
while flag 
    output_p=input_p;
    mu_mtx=rand(size(input_p,1),size(input_p,2),size(input_p,3));
    l=find(mu_mtx<muP);
    for i=l
        if output_p(i)==1;output_p(i)=0;
        elseif output_p(i)==0;output_p(i)=1;end
    end
    flag=0;
    for i=1:size(input_p,3)
        for j=1:size(input_p,1)
            if sum(output_p(j,output_p(j,:,i)~=inf,i))==0 && sum(output_p(j,:,i)~=inf)>0
                flag=1;
            end
        end
    end
end


