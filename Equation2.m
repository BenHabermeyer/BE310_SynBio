function dR_dt = Equation2(t, R, AHL, LuxR, pR, dR)
%{
Description:
Differential equation
Gives dR/dt Activation of LuxR by AHL to create the pLux-binding activated dimer ‘R’

Input(s):
t = time
R = concentration of dimerized AHL-bound LuxR
AHL = concentration of AHL ligand
LuxR = concentration of LuxR protein
pR = formation rate constant of dimeric R protein from LuxR protein binding
to AHL
gR = Degradation rate constant of dimeric R protein

Output(s): 
dR_dt is the change in dimerized R with respect to time

%}

dR_dt = pR*(LuxR)^2*(AHL)^2 - dR*R;
end

