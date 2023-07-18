function point = hipersphericalDist(c,r,d)

mu = [1 zeros(1,d-1)];
k=1;    % sprit
N=1;    % number of output point
RandVMF = randVMF(N, mu, k);
point=r*RandVMF+c;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [RandVMF] = randVMF(N, mu, k)
% This function generates the random samples from VMF distribution. The
% formula and algorithm of the generation process is descrbed in
% SphereDistributionRand.pdf.
%
% Usage:
%   [RandVMF] = randVMF(N, mu, k);
%
% Inputs:
%   N: The number of samples one wants to generate.
%
%   mu: The mean direction of the VMF distribution. Notice that the norm of
%       mu must be 1.
%
%   k: The kappa parameter of the VMF distribution.
%
% Outputs:
%   RandVMF: A N x p matrix which contains the generated random samples
%       from VMF distribution. p the same dimension as mean direction.
%
% Function is written by Yu-Hui Chen, University of Michigan
% Contact E-mail: yuhuic@umich.edu
%

mu = mu(:)';
if(norm(mu,2)<1-0.0001 || norm(mu,2)>1+0.0001)
    error('Mu should be unit vector');
end
p = size(mu,2);
tmpMu = [1 zeros(1,p-1)];
t = randVMFMeanDir(N, k, p);
RandSphere = randUniformSphere(N, p-1);

RandVMF = repmat(t, [1 p]).*repmat(tmpMu, [N 1]) + repmat((1-t.^2).^(1/2), [1 p]).*[zeros(N,1) RandSphere];
% Rotate the distribution to the right direction
Otho = null(mu);
Rot = [mu' Otho];
RandVMF = (Rot*RandVMF')';
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [t] = randVMFMeanDir(N, k, p)

% This function generate random samples from the tangent direction of von
% Mises-Fisher distribution using rejection sampling. The density of is
% described in VMFMeanDirDensity function. See the
% SphereDistributionsRand.pdf file for detail description and formulas.
%
% Usage:
%   [t] = randVMFMeanDir(N, k, p);
%
% Inputs:
%   N: The number of samples one wants to generate.
%
%   k: The kappa parameter of the VMF distribution.
%
%   p: The dimension of the VMF distribution.
%
% Outputs:
%   t : A N x 1 vector which are the random samples from the VMF's tangent
%   distribution.
%
% Function is written by Yu-Hui Chen, University of Michigan
% Contact E-mail: yuhuic@umich.edu
%

min_thresh = 1/(5*N);

xx = -1:0.000001:1;
yy = VMFMeanDirDensity(xx, k, p);
cumyy = cumsum(yy)*(xx(2)-xx(1));

leftBound = xx(find(cumyy>min_thresh,1));

%%% Fin the left bound
xx = linspace(leftBound, 1, 1000);
yy = VMFMeanDirDensity(xx, k, p);

[~,id] = sort(yy);
ll=0;
while true
    
    if yy(id(end-ll)) ~= inf
        M = yy(id(ll));
        break
    end
    ll=ll+1;
end
    
% M = max(yy);

t = zeros(N,1);
for i=1:N
    while(1)
        x = rand*(1-leftBound)+leftBound;
        h = VMFMeanDirDensity(x, k, p);
        draw = rand*M;
        if(draw<=h)
            break;
        end
    end
    t(i) = x;
end

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [y]=VMFMeanDirDensity(x, k, p)

% This is the tangent direction density of VMF distribution. See the
% SphereDistributionsRand.pdf file for detail description and formulas.
%
% Usage:
%   [y]=VMFMeanDirDensity(x, k, p);
%
% Inputs:
%   x: The tangent direction value. should be in [-1 1].
%
%   k: The kappa parameter of the VMF distribution.
%
%   p: The dimension of the VMF distribution.
%
% Outputs:
%   y : The density value of the VMF tangent density.
%
% Function is written by Yu-Hui Chen, University of Michigan
% Contact E-mail: yuhuic@umich.edu
%
if(any((x<-1) | (x>1)))
    error('Input of x should be within -1~1');
end
Coeff = (k/2)^(p/2-1) * (gamma((p-1)/2)*gamma(1/2)*besseli(p/2-1,k))^(-1);
y = Coeff * exp(k*x).*(1-x.^2).^((p-3)/2);

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [RandSphere] = randUniformSphere(N, p)

% This function generate the random samples uniformly on a dim-dimensional
% sphere.
%
% Usage:
%   [RandSphere] = randUniformSphere(N, p);
%
% Inputs:
%   N: The number of samples one wants to generate.
%
%   p : The dimension of the generated samples. 
%       p==2 => samples are on a unit circle.
%       p==3 => samples are on a unit sphere.
%
% Outputs:
%   RandSphere : A N x dim matrix which are the N random samples generated
%       on the unit p-dimensional sphere. Each sample has unit length,
%       eq: norm(RandSphere(x,:))==1 for any 1<=x<=N.
%
% Function is written by Yu-Hui Chen, University of Michigan
% Contact E-mail: yuhuic@umich.edu
%

randNorm = normrnd(zeros(N,p), 1, [N, p]);
RandSphere = zeros(N,p);
for r=1:N
    RandSphere(r,:) = randNorm(r,:)./norm(randNorm(r,:));
end

end