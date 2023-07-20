%%%%%%%%%% HOJJAT
global logfile success fail rndAgain itMax_floor1
logfile = fopen('GAPSOX_log.text','w');
fprintf(logfile,'\n ======================== %s ======================== \n\n',datetime);
[success,fail,rndAgain]=deal(0);
%%%%%%%%%% HOJJAT
%% prameters
%components
component=inf(14,14);
component(1,1:4)=[0 1 20 21];  %Pop
component(2,1:6)=[0 1 2 3 4 5];    %DNPP
component(3,1:7)=[0 1 2 3 4 50 51];  %Top
component(4,1:4)=[0 1 2 3];  %MoI
component(5,1:4)=[0 1 2 3];    %AC
component(6,1:9)=[0 11 12 13 14 21 22 23 24];   %PertRand
component(7,1:14)=[0 11 12 13 14 21 22 23 24 31 32 33 34 4];  %PertInfo
component(8,1:13)=[0 1 2 30 31 32 40 41 42 50 51 52 6]; %Mtx
component(9,1:10)=[0 1 2 3 4 5 6 7 8 9];  %W1
component(10,1:3)=[0 1 2];  %W2
component(11,1:3)=[0 1 2];  %W3
component(12,1:3)=[0 10 11];  %vClampCS
component(13,1:2)=[0 1];  %unstuckCS
component(14,1:2)=[0 1];  %reInitial

npop=size(component,1);    %number of particels
max_it=itMax_floor1;
%% initialzation
par.pos=zeros(npop,size(component,1),max_it+1);
par.fit=zeros(npop,max_it+1);
par.pos2=zeros(14,7,npop,max_it+1);
par.fc=zeros(npop,max_it+1);
component_size=sum(component~=inf,2);
%%%%%%%%%% HOJJAT
fprintf(logfile,'Initialize Floor(1)');
fprintf(logfile,'\n******************\n');
%%%%%%%%%% HOJJAT
for i=1:npop
    flag=1;
    while true
        for j=1:size(component,1)
            par.pos(i,j,1)=component(j,randi(component_size(j)));
        end
        flag=answer_check(par.pos(i,:,1));
        if flag;    break;  end
    end
%     [par.fit(i,1),par.pos2(:,:,i,1),par.fc(i,1)]=second_floor(par.pos(i,:,1));
    [as1,as2,as3]=second_floor(par.pos(i,:,1)); 
    par.fit(i,1)=as1;
    par.pos2(:,:,i,1)=as2;
    par.fc(i,1)=as3;

    % par.fit(i,1)=rand;
end
best.fit=zeros(1,max_it+1);
best.index=zeros(1,max_it+1);
best.pos=zeros(max_it,size(component,1));
[best.fit(1,1),best.index(1,1)]=min(par.fit(:,1));
best.pos(1,:)=par.pos(best.index(1),:,1);

for it=1:max_it
    it1=it
    for i=1:npop
        flag=1;
        par.pos(i,i,it+1)=best.pos(it,i);
        while true
            for j=setdiff(1:size(component,1),i)
                par.pos(i,j,it+1)=component(j,randi(component_size(j)));
            end
            flag=answer_check(par.pos(i,:,it+1));
            if flag;    break;  end
        end
        %%%%%%%%%% HOJJAT
        fprintf(logfile,'Floor(2) => it = %d',it);
        fprintf(logfile,'\n******************\n');
        %%%%%%%%%% HOJJAT
%         [par.fit(i,it+1),par.pos2(:,:,i,it+1),par.fc(i,it+1)]=second_floor(par.pos(i,:,it+1));
        [as1,as2,as3]=second_floor(par.pos(i,:,it+1)); 
        par.fit(i,1)=as1;
        par.pos2(:,:,i,1)=as2;
        par.fc(i,1)=as3;
        % par.fit(i,it+1)=rand;

    end

    if min(par.fit(:,it+1))< best.fit(it)
        [best.fit(it+1),best.index(it+1)]=min(par.fit(:,it+1));
        best.pos(it+1,:)=par.pos(best.index(it+1),:,it+1);
    else
        best.fit(it+1)=best.fit(it);
        best.index(it+1)=best.index(it);
        best.pos(it+1,:)=best.pos(it,:);
    end
end
%%%%%%%%%% HOJJAT
fprintf(logfile,"\n**********************************");
fprintf(logfile,"\n**********************************");
fprintf(logfile,"\n************** END ***************");
fprintf(logfile,"\n**********************************");
fprintf(logfile,"\n**********************************");
fprintf(logfile,"\n n_success = %d \n n_fail = %d \n n_rndAgain = %d",success,fail,rndAgain);
fclose(logfile);
%%%%%%%%%% HOJJAT