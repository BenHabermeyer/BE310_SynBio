function out = system(t, x, aGFP,dGFP, n1, KR, aTXGFP, dTXGFP, pR,dR, LuxR,Signal)

% Input(s):

% t = time

% TXGFP = concentration of GFP mRNA transcript

% R = concentration of dimerized AHL-bound LuxR

% n1 = Hill coefficient

% KR = Transcriptional activation threshold of dimeric R binding to the pLux
% promoter

% aTXGFP = synthesis rate constant of TXGFP

% dTXGFP = degradation rate constant of TXGFP

% pR = formation rate of dimeric R protein (LuxR + AHL)

% dR = degradation rate of dimeric R protein



dx2 = pR*(LuxR)^2*(Signal)^2 - dR*x(1);

dx3 = ((aTXGFP*(x(1)/KR)^n1) / (1 + (x(1)/KR)^n1)) - dTXGFP*x(2);

dx4 = aGFP*x(2) - dGFP*x(3);

out = [dx2; dx3; dx4];