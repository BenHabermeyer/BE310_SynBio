function dGFP_dt = Equation4(t, GFP, TXGFP, aGFP, dGFP)
%{
Description:
Differential equation
GFP protein concentration based on the translation of TXGFP and the degradation
rate of GFP protein (after its synthesis)

Input(s):
t = time
GFP = concentration of GFP protein
TXGFP = concentration of GRP mRNA transcript
aGFP = synthesis rate constant of GFP protein (translation)
dGFP = degradation rate constant of GFRP protein

Output(s): 
dGFP_dt is the change in concentration of GFP protein with time
%}

dGFP_dt = aGFP*TXGFP - dGFP*GFP;
end