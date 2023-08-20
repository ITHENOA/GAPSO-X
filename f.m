function eval=f(x,input,par)
    input_edited=inf(size(input,1),size(input,2));
    counter=0;
    for i=size(input,1)
        for j=size(input,2)
            if input(i,j)~=inf
                counter=counter+1;
                input_edited(i,j)=x(counter);
            end
        end
    end
    results=PSOX(par,input_edited);
    eval=results.eval;
end

