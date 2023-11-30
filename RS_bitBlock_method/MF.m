function m = MF(type,x,param) 
% v2
% param = [a,b,c,d]
% Gaussian --> param = [c sigma]
% Triangle --> param = [a b c]
% Generalized Bell --> param = [a b c]
% Trapzoidal --> param = [a b c d]
% sigmoidal --> param = [a c]
% Left-Right --> param = [c alpha beta]


    if strcmpi(type,'gauss')
        m = exp(-((x-param(1))/param(2)).^2); % param(1) = c or center, param(2) = sqrt(2)*sigma
    elseif strcmpi(type,'tri')%triangle
        m = max( min( (x-param(1))/(param(2)-param(1)) , (param(3)-x)/(param(3)-param(2))) ,0 );
    elseif strcmpi(type,'gbell')
        m = 1/(1+abs((x-param(3))/param(1)).^(2*param(2)));
    elseif strcmpi(type,'trap')%trapzoid
        m = max(min(min((x-param(1))/(param(2)-param(1)), 1), (param(4)-x)/(param(4)-param(3))),0);
    elseif strcmpi(type,'sig') % sigmoidal
        m = 1/1+exp(-param(1)*(x-param(2)));
    elseif strcmpi(type,'lr') % Left-Right
        if x >= param(1)
            m = max(0,sqrt(1-((param(1)-x)/param(2))^2));
        else
            m = exp(-abs((x-param(1))/param(3))^3);
        end
    end    
end