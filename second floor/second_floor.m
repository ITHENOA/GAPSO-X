<<<<<<< Updated upstream
function fit=second_floor(par)
% clc;clear;close all;
% par=[1     0    50     0     3    14    22    41     8     1     0     0     0     1];
%% parameters
nPar=7;  %maximum number of parameter for each component
=======
% function fit=second_floor(par)
clc;clear;close all;
%% parameters
nPar=4;  %maximum number of parameter for each component
>>>>>>> Stashed changes
nDecoder=6;  %maximum number of decoder for each parameter
nPop=20;    %number of population
muP=0.02;   %mutation probability
crP=0.5;    %cross over probability
maxIt=100;  %maximum number of iterarion
<<<<<<< Updated upstream
mcl=20;      %maximum choromosom length
nCom=length(par); %number of component
%% initialize
=======
%% initialize
par=[1     0    50     0     3    14    22    41     8     1     0     0     0     1];
>>>>>>> Stashed changes
cs=zeros(nPar,4+nDecoder,size(par,2));  % [boundries,number of options,number of encoder,size of encoders];
vec=D1(par(1),nPar,nDecoder);   % D1 charectristic
cs(1:size(vec,1),1:size(vec,2),1)=vec;
vec=D2(par(2),nPar,nDecoder);   % D2 charectristic
cs(1:size(vec,1),1:size(vec,2),2)=vec;
vec=D3(par(3),nPar,nDecoder);   % D3 charectristic
cs(1:size(vec,1),1:size(vec,2),3)=vec; 
vec=D5(par(5),nPar,nDecoder);   % D5 charectristic
cs(1:size(vec,1),1:size(vec,2),5)=vec;
vec=D6(par(6),nPar,nDecoder);   % D6 charectristic
cs(1:size(vec,1),1:size(vec,2),6)=vec;
vec=D7(par(7),nPar,nDecoder);   % D7 charectristic
cs(1:size(vec,1),1:size(vec,2),7)=vec; 
vec=D8(par(8),nPar,nDecoder);   % D8 charectristic
cs(1:size(vec,1),1:size(vec,2),8)=vec;  
vec=D9(par(9),nPar,nDecoder);   % D9 charectristic
cs(1:size(vec,1),1:size(vec,2),9)=vec; 
vec=D10(par(10),nPar,nDecoder);   % D10 charectristic
cs(1:size(vec,1),1:size(vec,2),10)=vec; 
vec=D11(par(11),nPar,nDecoder);   % D11 charectristic
cs(1:size(vec,1),1:size(vec,2),11)=vec;
<<<<<<< Updated upstream
c=zeros(nPar,mcl,nCom,nPop,maxIt+1);
=======
nCom=10;
c=zeros(nPar,5*nPar,nCom,nPop,maxIt+1);
>>>>>>> Stashed changes
input=inf(nCom,nPar,nPop,maxIt+1);
fits=zeros(nPop,maxIt+1);
for k=1:nPop
    for i=1:nCom
        for j=1:nPar
            vec=[];
            c_size=sum(cs(j,5:4+cs(j,4,i),i));
            while c_size>0
                vec=randi([0,1],1,c_size);  %binary coding
                if sum(vec)>0
<<<<<<< Updated upstream
=======
                    if k==1 && j==4 && i==1
                        i
                    end
>>>>>>> Stashed changes
                    input(i,j,k,1)=decoder_C(cs(j,:,i),vec);    %binary to real
                    break;
                end
            end
<<<<<<< Updated upstream
            c(j,:,i,k,1)=[vec inf(1,mcl-c_size)];
=======
            c(j,:,i,k,1)=[vec inf(1,20-c_size)];
>>>>>>> Stashed changes
        end
    end
    fits(k,1)=PSOX(par,input(:,:,k,1));
%     fits(k,1)=rand;
end
pop_in_this_it=c(:,:,:,:,1);
%% main
for it=1:maxIt
<<<<<<< Updated upstream
    next_pop=zeros(nPar,mcl,nCom,ceil(nPop/2)*2);
=======
    next_pop=zeros(nPar,5*nPar,nCom,ceil(nPop/2)*2);
>>>>>>> Stashed changes
    for i=1:ceil(nPop/2)
        %selection
        while true
            p1=select_ranking(pop_in_this_it,fits(:,it));
            p2=select_ranking(pop_in_this_it,fits(:,it));
            if ~prod(prod(prod(p1==p2)));break;end
        end
        %cross over
        [next_pop(:,:,:,2*i-1),next_pop(:,:,:,2*i)]=cross_over(p1,p2,cs,crP);
        %mutation
        next_pop(:,:,:,2*i-1)=mutation(next_pop(:,:,:,2*i-1),muP);
        next_pop(:,:,:,2*i)=mutation(next_pop(:,:,:,2*i),muP);
        %decoding
        input(:,:,2*i-1,it+1)=decoder(cs,next_pop(:,:,:,2*i-1));
        input(:,:,2*i,it+1)=decoder(cs,next_pop(:,:,:,2*i));
        %function evaluation
%         fits(2*i-1,it+1)=Pso_fitness(par,input(:,:,2*i-1,it+1));
        fits(2*i-1,it+1)=rand;
%         fits(2*i,it+1)=Pso_fitness(par,input(:,:,2*i,it+1));
        fits(2*i,it+1)=rand;
    end
    if rem(nPop,2)
        next_pop=next_pop(:,:,:,1:end-1);
    end
    %update population
    c(:,:,:,:,it+1)=next_pop;
    pop_in_this_it=next_pop;
end
best.fit=min(min(fits));
[r,c]=find(fits==best.fit);
best.pos=input(:,:,r,c);
fit=best.fit;
% end
        




