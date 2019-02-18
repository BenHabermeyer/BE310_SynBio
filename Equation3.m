function dTXGFP_dt = Equation3(t, TXGFP, R, n1, KR, aTXGFP, dTXGFP)
%{
Description:
Differential equation
Concentration of mRNA or transcript encoding for GFP (TXGFP), based on the 
transcriptional activation by R, and the degradation of TXGFP (after its synthesis)

Input(s):
t = time
TXGFP = concentration of GFP mRNA transcript
R = concentration of dimerized AHL-bound LuxR
n1 = Hill coefficient
KR = Transcriptional activation threshold of dimeric R binding to the pLux
        promoter
aTXGFP = synthesis rate constant of TXGFP
dTXGFP = degradation rate constant of TXGFP

Output(s): 
dTXGFP_dt is the change in concentration of GFP mRNA with respect to time
%}

dTXGFP_dt = ((aTXGFP*(R/KR)^n1) / (1 + (R/KR)^n1)) - dTXGFP*TXGFP;
end

