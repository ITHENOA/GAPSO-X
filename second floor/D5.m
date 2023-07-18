function cs=D5(index,nPar,nDecoder)
switch index
    case 0
        cs(1,:)=[0.1,2.4,31,1,5];   %phi1   1
        cs(2,:)=[0.1,2.4,31,1,5];   %phi2   2
    case {1,3}
        cs(3,:)=[0.1,2.4,31,1,5];   %phi1min    3
        cs(4,:)=[0.1,2.4,31,1,5];   %phi1max    4
        cs(5,:)=[0.1,2.4,31,1,5];   %phi2min    5
        cs(6,:)=[0.1,2.4,31,1,5];   %phi2max    6
    otherwise
        cs=zeros(nPar,4+nDecoder);
end