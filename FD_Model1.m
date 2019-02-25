%Group 1
%FD model of 2D diffusion and GFP expression

%% Create a 2D FD model of [AHL] Diffusion through square plate
clear
clc
close all

%Define the Physical parameters of the system
% Plate radius (mm, call it Radius_Plate)
Radius_Plate = 30;
% Disk radius (mm, call it Radius_Disk)
Radius_Disk = 2.5;
% Experiment duration (minutes, call it T)
T = 24*60;
% Diffusion rate (mm^2/min, call it D)
D = 0.15;
% Source concentration (uM, call it sourceconc)
sourceconc = 10;
% Degradation constant of AHL in min-1
dAHL = 4.8135E-4;

%Define the X-Y mesh
% number of mesh points in the X- and Y-coordinates (use 201 points each to start)
n = 201;
% define the x- and y-step sizes (call them dx and dy). Remember MATLAB indices start at one
dx = 2*Radius_Plate / (n-1);
dy = dx;
dp = dx;
xgrid = [-Radius_Plate:dx:Radius_Plate]; % centers the grid in x around zero
ygrid = [-Radius_Plate:dx:Radius_Plate]; % centers the grid in y around zero
[X,Y] = meshgrid(xgrid, ygrid); % creates the matrix that describes the mesh using meshgrid

%Discretize the time
% Modify your existing code so that r <= 0.25, the stability condition for 2D. Remember that code you
%were given determines ?t based on ?x, but you can write your own stability condition if you want to set ?t
%yourself. 
stability_factor = 0.25; % must be <= 0.25 for FTCS in 2D
dt = stability_factor*(dp^2)/D; % (min) time increment that fulfills the stability criterion
time = [0:dt:T]; % Time Vector incremented in steps of dt
r = D*dt/(dp^2); % r term in the Finite Difference Equation 

AHL_Initial = zeros(length(xgrid), length(ygrid));% Set initial AHL concentration to zero across the whole
%plate decribed by the matrix AHL_Initial
[Disk_Indices_Row, Disk_Indices_Col] = find(sqrt(X.^2+Y.^2)<=Radius_Disk); % the loop below sets the
%initial concentration of the disk
for i = 1:length(Disk_Indices_Row)
 AHL_Initial(Disk_Indices_Row(i), Disk_Indices_Col(i)) = sourceconc;
end
%mesh(X,Y,AHL_Initial) % Draws the mesh to visualize initial conditions as a quality control step.

%Initialize AHL on the plate at time t=0
% Create a 3D matrix called �AHL� to describe the AHL concentration profile (i.e. x, y, and time).
AHL = zeros(length(X), length(Y), length(time));
% Initialize AHL by making its first time step match AHL_Initial
AHL(:,:,1) = AHL_Initial;

%Plot Diffusion over the 24 hours � Assume no flux out of the plate and AHL does not degrade.
% Loop over all time steps (subtract 1 from time vector to end the iteration at correct time step)
% Loop over all of the interior points (but not the boundary points since they are fixed)
% Write conditionals to enforce no flux out of plate by setting boundaries equal to preceding points when
%radiating from center.
for t = 1 : length(time) - 1
    for x = 1 : length(X)
        for y = 1 : length(Y)
            %conditionals for each boundary condition - there will be 8, 4
            %for each corner and 4 for each edge
            if x == 1 && y == 1
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x+1,y,t)...
                    + AHL(x,y+1,t) - 2*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            elseif x == 1 && y == length(Y)
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x+1,y,t)...
                    + AHL(x,y-1,t) - 2*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            elseif x == length(X) && y == 1
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x-1,y,t) ...
                    + AHL(x,y+1,t) - 2*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            elseif x == length(X) && y == length(Y)
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x-1,y,t) ...
                    + AHL(x,y-1,t) - 2*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            elseif x == 1
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x+1,y,t)...
                    + AHL(x,y-1,t) + AHL(x,y+1,t) - 3*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));   
            elseif y == 1
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x-1,y,t) + AHL(x+1,y,t)...
                    + AHL(x,y+1,t) - 3*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            elseif x == length(X)
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x-1,y,t)...
                    + AHL(x,y-1,t) + AHL(x,y+1,t) - 3*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            elseif y == length(Y)
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x-1,y,t) + AHL(x+1,y,t)...
                    + AHL(x,y-1,t) - 3*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            else
                %interior point
                AHL(x,y,t+1) = AHL(x,y,t) + r*(AHL(x-1,y,t) + AHL(x+1,y,t)...
                    + AHL(x,y-1,t) + AHL(x,y+1,t) - 4*AHL(x,y,t)) - dt*(dAHL*AHL(x,y,t));
            end
        end
    end   
end

%% M1 plot edge distance vs time defining edge distance as point where [AHL] switches
%switching points are defined by the KR in uM
KR1 = 3.72E-4;
KR2 = 3.68E-2;
KR3 = 5.64E-3;

%Edge distances over each time
edge1 = NaN(1,length(time));
edge2 = NaN(1,length(time));
edge3 = NaN(1,length(time));

%within AHL(101:end, 101, all T) at each t find greatest distance where
%the edge is and convert to mm
for tstep = 1:length(time)
    edge1(tstep) = xgrid(find(AHL(101:end, 101, tstep) > KR1, 1, 'last') + 100);
    edge2(tstep) = xgrid(find(AHL(101:end, 101, tstep) > KR2, 1, 'last') + 100);
    edge3(tstep) = xgrid(find(AHL(101:end, 101, tstep) > KR3, 1, 'last') + 100);
end

close all
figure
subplot(3,1,1)
plot(time(1:7*end/8) / 60, edge1(1:7*end/8))
xlim([0 21])
title("R1")
set(gca, 'FontSize', 14)
subplot(3,1,2)
plot(time(1:7*end/8) / 60, edge2(1:7*end/8))
xlim([0 21])
ylim([0 30])
title("R2")
set(gca, 'FontSize', 14)
ylabel("AHL edge distance from center (mm)")
subplot(3,1,3)
plot(time(1:7*end/8) / 60, edge3(1:7*end/8))
title("R3")
xlabel("Time (hr)")
set(gca, 'FontSize', 14)
xlim([0 21])

%NOTE: plot 2 does not reach 30cm. use figure; plot(time, squeeze(AHL(167, 101, :)))
%to see why - concentration increases then decreases below the "edge
%distance" threshold again

%% M2: convert all the differential equations into FD model for each strain

%% Strain R1
pR = 0.5; %uM^-3/min
dR = 0.0231; %1/min
KR = 3.72E-4; %uM
n1 = 1.31;
LuxR = 0.1; %uM
aGFP = 2; %1/min
dGFP = 4E-4; %1/min
aTXGFP = 0.05; %uM/min
dTXGFP = 0.2; %1/min

%Create a 3D matrix representing spatio-temporal cocnentrations of each of
%the variables
R1 = zeros(size(AHL));
TXGFP1 = zeros(size(AHL));
GFP1 = zeros(size(AHL));

%convert diffeqs into 2D FD
for t = 1 : length(time) - 1
    for x = 1 : length(X)
        for y = 1 : length(Y)    
            R1(x,y,t+1) = pR*(LuxR^2)*(AHL(x,y,t)^2) - dR*R1(x,y,t);
            TXGFP1(x,y,t+1) = (aTXGFP*(R1(x,y,t)/KR)^n1) / (1 + (R1(x,y,t)/KR)^n1) ...
                - dTXGFP*TXGFP1(x,y,t);
            GFP1(x,y,t+1) = aGFP*TXGFP1(x,y,t) - dGFP*GFP1(x,y,t);
        end
    end
end


%% Strain R2
pR = 0.5; %uM^-3/min
dR = 0.0231; %1/min
KR = 3.68E-2; %uM
n1 = 1.01;
LuxR = 0.1; %uM
aGFP = 2; %1/min
dGFP = 4E-4; %1/min
aTXGFP = 0.05; %uM/min
dTXGFP = 0.2; %1/min

%Create a 3D matrix representing spatio-temporal cocnentrations of each of
%the variables
R2 = zeros(size(AHL));
TXGFP2 = zeros(size(AHL));
GFP2 = zeros(size(AHL));

%convert diffeqs into 2D FD
for t = 1 : length(time) - 1
    for x = 1 : length(X)
        for y = 1 : length(Y)    
            R2(x,y,t+1) = pR*(LuxR^2)*(AHL(x,y,t)^2) - dR*R2(x,y,t);
            TXGFP2(x,y,t+1) = (aTXGFP*(R2(x,y,t)/KR)^n1) / (1 + (R2(x,y,t)/KR)^n1) ...
                - dTXGFP*TXGFP2(x,y,t);
            GFP2(x,y,t+1) = aGFP*TXGFP2(x,y,t) - dGFP*GFP2(x,y,t);
        end
    end
end
%% Strain R3
pR = 0.5; %uM^-3/min
dR = 0.0231; %1/min
KR = 5.64E-3; %uM
n1 = 0.93;
LuxR = 0.1; %uM
aGFP = 2; %1/min
dGFP = 4E-4; %1/min
aTXGFP = 0.05; %uM/min
dTXGFP = 0.2; %1/min

%Create a 3D matrix representing spatio-temporal cocnentrations of each of
%the variables
R3 = zeros(size(AHL));
TXGFP3 = zeros(size(AHL));
GFP3 = zeros(size(AHL));

%convert diffeqs into 2D FD
for t = 1 : length(time) - 1
    for x = 1 : length(X)
        for y = 1 : length(Y)    
            R3(x,y,t+1) = pR*(LuxR^2)*(AHL(x,y,t)^2) - dR*R3(x,y,t);
            TXGFP3(x,y,t+1) = (aTXGFP*(R3(x,y,t)/KR)^n1) / (1 + (R3(x,y,t)/KR)^n1) ...
                - dTXGFP*TXGFP3(x,y,t);
            GFP3(x,y,t+1) = aGFP*TXGFP3(x,y,t) - dGFP*GFP3(x,y,t);
        end
    end
end




