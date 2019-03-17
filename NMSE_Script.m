clc; close all
%Script to run error analysis for the model.

%Load in AHL matrx such that it does not need to be generated each time.
load AHL.mat

%Load in experimentally determined edge distances for each trial for each
%strain as calculated in Plate_Analysis.

load R1_T1.mat
load R2_T1.mat
load R3_T1.mat

load R1_T2.mat
load R2_T2.mat
load R3_T2.mat

%Average the edge distances for each strain between the two trials
%and store edge distances in a 3 x 24 array.
R1_edge = (edge_distanceR1_T1 + edge_distanceR1_T2)./2;
R2_edge = (edge_distanceR2_T1 + edge_distanceR2_T2)./2;
R3_edge = (edge_distanceR3_T1 + edge_distanceR3_T2)./2;

exp_Data = [R1_edge;R2_edge;R3_edge];


%%

%Define a value for KR as calculated from the simple Hill model. Select a
%range of values for pR centered at approximately 0.5 as suggested in the
%lab manual, amd a range of values for LuxR centered at 0.1. 

%R2 and R3 should have lower LuxR concentrations than R1
%R1 and R2 should have lower pR rates than R3

KR1 = 3.4847E-4; %uM
KR2 = 3.6835E-2; %uM
KR3 = 5.6364E-3; %uM

KR = [KR1,KR2,KR3];
pR = 0.5;
dR = 0.0231; %min^-1;
LuxR = logspace(-10,-2,10); %uM
aGFP = 2; %min^-1
dGFP = 4E-4; %min^-1
aTXGFP = 0.05; %uM/min
dTXGFP = 0.2; %min^-1

tic
for jj = 1:3    
    for kk = 1:length(LuxR)
        
        jj
        kk

nrmse(kk,jj) = modelVerification(AHL,pR,dR,KR(jj),LuxR(kk),aGFP,dGFP,aTXGFP,dTXGFP,exp_Data(jj,:));

    end
end

toc

%%

%Define a value for KR as calculated from the simple Hill model. Select a
%range of values for pR centered at approximately 0.5 as suggested in the
%lab manual. 

%R2 and R3 should have lower LuxR concentrations than R1
%R1 and R2 should have lower pR rates than R3

% KR1 = 3.4847E-4; %uM
% KR2 = 3.6835E-2; %uM
% KR3 = 5.6364E-3; %uM
% 
% KR = [KR1,KR2,KR3];
% pR = 0.5;
% dR = linspace(0.05,0.5,3);
% LuxR = 0.1; %uM
% aGFP = linspace(0.05,0.5,3);
% dGFP = linspace(2E-4,6E-4,3);
% aTXGFP = linspace(0.025,0.25,3);
% dTXGFP = linspace(0.05,0.5,3);
% 
% global_parameters = cartprod(dR,aGFP,dGFP,aTXGFP,dTXGFP);
% 
% nrmse(1:243,1:3) = 0;
% 
% for jj = 1:3    
%     for kk = 1:length(global_parameters)
% 
% nrmse(kk,jj) = modelVerification(AHL,pR,dR,KR(jj),LuxR,aGFP,dGFP,aTXGFP,dTXGFP,exp_Data);
% 
%     end
% end



