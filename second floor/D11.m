function cs=D11(index,nPar,nDecoder)
switch index
    case 2
<<<<<<< Updated upstream
        cs(1,:)=[0.01,0.99,97,3,6,5,2];    %w3_0    1
=======
        cs(1,:)=[0.01,0.99,97,3,6,5,2];    %w3_0
>>>>>>> Stashed changes
    otherwise
        cs=zeros(nPar,4+nDecoder);
end