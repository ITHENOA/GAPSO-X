close all
pd_norm = makedist('Stable','alpha',2,'beta',0,'gam',1/sqrt(2),'delta',0);
pd_cauchy = makedist('Stable','alpha',1,'beta',0,'gam',1,'delta',0);
pd_levy = makedist('Stable','alpha',0.5,'beta',1,'gam',1,'delta',0);

x = -5:.1:5;
pdf_norm = pdf(pd_norm,x);
pdf_cauchy = pdf(pd_cauchy,x);
pdf_levy = pdf(pd_levy,x);

figure

plot(x,pdf_norm,'b-');
hold on

plot(x,pdf_cauchy,'r.');
plot(x,pdf_levy,'k--');
title('Compare Stable Distributions pdf Plots')
legend('Normal','Cauchy','Levy','Location','northwest')
grid on
hold off