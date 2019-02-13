function percent_GFP = Equation1(KR, n1, Signal)
%{
Description:
Gives [GFP] in % expression using the hill function
Plot over ranges of [Signal] that we have, varying KR and n1

Input(s):
KR = R-plux activation
n1 = hill constant
Signal = [AHL] ligand concentration

Output(s): 
percent_GFP is percent expression
%}

percent_GFP = 1 / (1 + (KR / Signal)^n1);
end