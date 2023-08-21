function eval=f_rs(x,input,par)
global success fail rndAgain

    input_edited=inf(size(input,1),size(input,2));
    counter=0;
    for i=1:size(input,1)
        for j=1:size(input,2)
            if input(i,j)~=inf
                counter=counter+1;
                input_edited(i,j)=x(counter);
            end
        end
    end
    results = PSOX(par,input_edited);
    if results.status==1; success=success+1; end
    if results.status==0; fail=fail+1; end
    if results.status==2; rndAgain=rndAgain+1; end
    % fc(k,1) = results.fCount; ??
    eval = results.eval;
    % results.time = ??
end

