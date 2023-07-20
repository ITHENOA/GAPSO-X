function [best_fit,best_pos,best_fc]=second_floor(par)
global logfile success fail rndAgain itMax_floor2
% rng(0)
% clc;clear;close all;
% par=[1     0    50     0     3    14    22    41     8     1     0     0     0     1];
%% parameters
nPar=7;  %maximum number of parameter for each component
nDecoder=6;  %maximum number of decoder for each parameter
nPop=20;    %number of population
muP=0.02;   %mutation probability
crP=0.5;    %cross over probability
maxIt=itMax_floor2;  %maximum number of iterarion
mcl=20;      %maximum choromosom length
nCom=length(par); %number of component
%% initialize
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
c=zeros(nPar,mcl,nCom,nPop,maxIt+1);
input=inf(nCom,nPar,nPop,maxIt+1);
fits=zeros(nPop,maxIt+1);
fc=zeros(nPop,maxIt+1);
%%%%%%%%%% HOJJAT
fprintf(logfile,'Initialize Floor(2)');
fprintf(logfile,'\n******************\n');
%%%%%%%%%% HOJJAT
for k=1:nPop
    for i=1:nCom
        for j=1:nPar
            vec=[];
            c_size=sum(cs(j,5:4+cs(j,4,i),i));
            while c_size>0
                vec=randi([0,1],1,c_size);  %binary coding
                if sum(vec)>0
                    input(i,j,k,1)=decoder_C(cs(j,:,i),vec);    %binary to real
                    break;
                end
            end
            c(j,:,i,k,1)=[vec inf(1,mcl-c_size)];
        end
    end
    %%%%%%%%%%%%% HOJJAT
    % [fits(k,1),fc(k,1)]=PSOX(par,input(:,:,k,1));
    results = PSOX(par,input(:,:,k,1));
    if results.status==1; success=success+1; end
    if results.status==0; fail=fail+1; end
    if results.status==2; rndAgain=rndAgain+1; end
    fc(k,1) = results.fCount;
    fits(k,1) = results.eval;
    % results.time = ??
    %%%%%%%%%% HOJJAT
end
pop_in_this_it=c(:,:,:,:,1);
%% main
for it=1:maxIt
    it2=it
    next_pop=zeros(nPar,mcl,nCom,ceil(nPop/2)*2);
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
        %%%%%%%%%%%%% HOJJAT
        fprintf(logfile,'Floor(2) => it = %d, particle = %d/%d',it,2*i-1,nPop);
        fprintf(logfile,'\n******************\n');
        % [fits(2*i-1,it+1),fc(2*i-1,it+1)]=PSOX(par,input(:,:,2*i-1,it+1));
        results = PSOX(par,input(:,:,2*i-1,it+1));
        if results.status==1; success=success+1; end
        if results.status==0; fail=fail+1; end
        if results.status==2; rndAgain=rndAgain+1; end
        fc(2*i-1,it+1) = results.fCount;
        fits(2*i-1,it+1) = results.eval;
        % results.time = ??

        fprintf(logfile,'Floor(2) => it = %d, particle = %d/%d',it,2*i,nPop);
        fprintf(logfile,'\n******************\n');
        % [fits(2*i,it+1),fc(2*i,it+1)]=PSOX(par,input(:,:,2*i,it+1));
        results = PSOX(par,input(:,:,2*i,it+1));
        if results.status==1; success=success+1; end
        if results.status==0; fail=fail+1; end
        if results.status==2; rndAgain=rndAgain+1; end
        fits(2*i,it+1) = results.fCount;
        fc(2*i,it+1) = results.eval;
        % results.time = ??
        %%%%%%%%%% HOJJAT
    end
    if rem(nPop,2)
        next_pop=next_pop(:,:,:,1:end-1);
    end
    %update population
    c(:,:,:,:,it+1)=next_pop;
    pop_in_this_it=next_pop;
end
best_fit=min(min(fits));
if best_fit==inf
    r=1;
    c=1;
else
[r,c]=find(fits==best_fit);
end
best_pos=input(:,:,r,c);
best_fc=fc(r,c);
% end
        




