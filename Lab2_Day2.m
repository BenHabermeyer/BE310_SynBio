%Lab2 Day2 M and A sections
clear; clc; close all
%% M1
%concentration of ligand we have, in molar
Signal = [0, 9.90E-05, 9.90E-06, 9.90E-07, 9.90E-08, 9.90E-09, 9.90E-10, ...
    9.90E-11, 9.90E-12, 9.90E-13];

KR = 0.01*10^-6; %M
%Vary the Hill coefficient from 1 to 4 to see how this effects the
%switchlike behavior of the genetic circuit
for n1 = 1:4
    
    percent_GFP = Equation1(KR, n1, Signal);
    semilogx(Signal,percent_GFP,'--*');
    hold on
    
end

hold off
title('Percent GFP expression as function of n1')
ylim([-0.2 1.2])
xlabel('Log(AHL Concentration (M))');
ylabel('Percent GFP Expression');
leg = legend('n1 = 1','n1 = 2','n1 = 3','n1 = 4');
set(leg,'location','northwest');
set(gca,'fontsize',16);

%Keep the Hill Coefficient equal to 1 and allow the value of KR to vary by
%orders of 10.

KR = logspace(-5,-10,6);
n1 = 1;

figure(2)

for jj = 1:length(KR)
    
    percent_GFP = Equation1(KR(jj), n1, Signal);
    semilogx(Signal,percent_GFP,'--*');
    hold on
    
end

title('Percent GFP expression as function of KR')
ylim([-0.2 1.2])
xlabel('Log(AHL Concentration (M))');
ylabel('Percent GFP Expression');
leg = legend('KR = 10^-^5','KR = 10^-^6','KR = 10^-^7','KR = 10^-^8','KR = 10^-^9','KR = 10^-^1^0');
set(leg,'location','northwest');
set(gca,'fontsize',16);


%% M2


% Matt was here