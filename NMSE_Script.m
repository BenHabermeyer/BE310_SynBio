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

%Average the edge distances for each strain between each of the two trials.
R1_edge = (edge_distanceR1_T1 + edge_distanceR1_T2)./2;
R2_edge = (edge_distanceR2_T1 + edge_distanceR2_T2)./2;
R3_edge = (edge_distanceR3_T1 + edge_distanceR3_T2)./2;

exp_Data = [R1_edge;R2_edge;R3_edge];

%%

%Define a value for KR as calculated from the simple Hill model. Select a
%range of values for pR centered at approximately 0.5 as suggested in the
%lab manual. 

KR1 = 3.4847E-4; %uM
KR2 = 3.6835E-2; %uM
KR3 = 5.6364E-3; %uM

KR = [KR1,KR2,KR3];
pR = 0.5;

for jj = 1:3    

nrmse(jj) = modelVerification(AHL,pR,KR(jj),exp_Data(jj,:));

end



