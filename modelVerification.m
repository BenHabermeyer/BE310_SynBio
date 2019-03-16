function [nrmse] = modelVerification(AHL,pR,KR,exp_Data)

%Function that takes in 2D profile of AHL, and finds the value of pR and KR
%such that the NRMSE between the GFP model and the edge distance dervied
%from the image analysis is minimized.

pR = pR; %uM^-3/min
dR = 0.0231; %1/min
KR = KR; %uM
n = 201;
n1 = 1.1727;
LuxR = 0.1; %uM
aGFP = 2; %1/min
dGFP = 4E-4; %1/min
aTXGFP = 0.05; %uM/min
dTXGFP = 0.2; %1/min

Radius_Plate = 30;
dx = 2*Radius_Plate / (n-1);
dp = dx;
% Diffusion rate (mm^2/min, call it D)
D = 0.15;
% Experiment duration (minutes, call it T)
T = 24*60;

%Discretize the time
% Modify your existing code so that r <= 0.25, the stability condition for 2D. Remember that code you
%were given determines ?t based on ?x, but you can write your own stability condition if you want to set ?t
%yourself. 
stability_factor = 0.25; % must be <= 0.25 for FTCS in 2D
dt = stability_factor*(dp^2)/D; % (min) time increment that fulfills the stability criterion
time = [0:dt:T]; % Time Vector incremented in steps of dt
r = D*dt/(dp^2); % r term in the Finite Difference Equation

%Create a 3D matrix representing spatio-temporal cocnentrations of each of
%the variables - to save memory have R1 and TXGFP be only size 2 - index 1
%is previous and index 2 is current
R1 = zeros(n, n, 2);
TXGFP1 = zeros(n, n, 2);
GFP1 = zeros(n, n, 2);

%get 2D GFP expression at only 25 times
time_indices(1:24) = 0;
time_indices(1) = 0.5;
for jj = 2:24
    time_indices(jj) = time_indices(jj-1) + 1;
end

%Convert time index in hours to minutes and then divide by the time step in
%order for the indices to span the range of 1:9601

time_indices = 60.*time_indices/0.15;
GFP_hour = zeros(n, n, 25);
GFP_index = 1;

%Vectorized FD model - saves memory
%I THINK THERE'S A BUG IN HERE IMA CHECK 
for t = 1 : length(time) - 1
    R1(:,:,2) = pR.*(LuxR^2).*(AHL(:,:,t).^2) - dR.*R1(:,:,1);
    TXGFP1(:,:,2) = ((aTXGFP.*((R1(:,:,1)./KR).^n1)) ./ (ones(n) + (R1(:,:,1)./KR).^n1)) ...
        - dTXGFP.*TXGFP1(:,:,1);
    GFP1(:,:,2) = aGFP.*TXGFP1(:,:,1) - dGFP.*GFP1(:,:,1);
    
    %if t is one of the 25 indices we want, save the old GFP matrix
    %given by the first z stack
    if any(time_indices == t)
        GFP_hour(:,:, GFP_index) = GFP1(:,:,1);
        GFP_index = GFP_index + 1;
    end
    
    %reset t index 1 for R1 and TXGFP by setting the first z stack
    %to be the second
     R1(:,:,1) = R1(:,:,2) + R1(:,:,1);
    TXGFP1(:,:,1) = TXGFP1(:,:,2) + TXGFP1(:,:,1);
    GFP1(:,:,1) = GFP1(:,:,2) + GFP1(:,:,1);
end
%set the final time point
GFP_hour(:,:,24) = GFP1(:,:,1);

%since diffusion will be symmetrical in all directions, do the same thing
%as in M1 - look in the positive X direction only along the middle of the
%plate to determine the edge distance at each time.
edge_distance = zeros(1, 24);

%first edge distance is 0
edge_distance(1) = 0;

for i = 2:24
    sec_deriv = gradient(gradient(GFP_hour(101:end, 101, i)));
    sec_deriv(1:5)=[];
    edge_distance(i)=find(sec_deriv == max(sec_deriv), 1);
end

edge_distance = 30*edge_distance/101;

nrmse = NRMSE(exp_Data, edge_distance);

