function input=decoder(cs,p)
input=zeros(size(p,3),size(p,1));
    for i=1:size(p,3)
        for j=1:size(p,1)
            vec=[];
            c_size=sum(cs(j,5:4+cs(j,4,i),i));
            while c_size>0
                vec=p(j,1:c_size,i);
                if sum(vec)>0
                    input(i,j)=decoder_C(cs(j,:,i),vec);    %binary to real
                    break;
                end
            end
        end
    end
end