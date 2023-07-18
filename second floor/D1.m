function cs=D1(index,nPar,nDecoder)
switch index
    case 0
<<<<<<< Updated upstream
        cs(1,1:9)=[2,200,199,5,7,6,3,1,1];  %particles  1
    case 1
        cs(1,1:9)=[2,200,199,5,7,6,3,1,1];  %particles  1
        cs(2,1:7)=[2,10,9,3,3,1,1];  %initialPopSize    2
        cs(3,1:9)=[2,200,199,5,7,6,3,1,1];  %finalPopSize   3
        cs(4,1:8)=[1,100,100,4,6,5,2,2];  %popTViterations  4
    case 20
        cs(2,1:7)=[2,10,9,3,3,1,1];  %initialPopSize    2
        cs(5,1:6)=[1,10,10,2,3,2];  %particlesToAdd     5
        cs(3,1:9)=[2,200,199,5,7,6,3,1,1];  %finalPopSize   3
    case 21
        cs(2,1:7)=[2,10,9,3,3,1,1];  %initialPopSize    2
        cs(5,1:6)=[1,10,10,2,3,2];  %particlesToAdd     5
        cs(3,1:9)=[2,200,199,5,7,6,3,1,1];  %finalPopSize   3
=======
        cs(1,1:9)=[2,200,199,5,7,6,3,1,1];  %particles
    case 1
        cs(1,1:9)=[2,200,199,5,7,6,3,1,1];  %particles
        cs(2,1:7)=[2,10,9,3,3,1,1];  %initialPopSize
        cs(3,1:9)=[2,200,199,5,7,6,3,1,1];  %finalPopSize
        cs(4,1:8)=[1,100,100,4,6,5,2,2];  %popTViterations
    case 20
        cs(1,1:7)=[2,10,9,3,3,1,1];  %initialPopSize
        cs(2,1:6)=[1,10,10,2,3,2];  %particlesToAdd
        cs(3,1:9)=[2,200,199,5,7,6,3,1,1];  %finalPopSize
    case 21
        cs(1,1:7)=[2,10,9,3,3,1,1];  %initialPopSize
        cs(2,1:6)=[1,10,10,2,3,2];  %particlesToAdd
        cs(3,1:9)=[2,200,199,5,7,6,3,1,1];  %finalPopSize
>>>>>>> Stashed changes
    otherwise
        cs=zeros(nPar,4+nDecoder);
end
