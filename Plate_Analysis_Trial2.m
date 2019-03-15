%plate analysis for the second dataset

%% Load in the plate data
clear
clc
close all

%raw data is in a x by y by 25 matrix format - 1 grayscale 2D matrix for
%each of the pictures, spaced 1 hour apart from t=0 to t=24 hours
load PlateData_Trial2_1s

%divide by 255 to convert between pixels intensity between 0 and 1
data = PlateData_Trial2_1s / 255;
clear PlateData_Trial2_1s

%first find the circles representing the plate borders
%do some processing to increase brigtness of plates by changing sensitivity
sample = data(:,:,24);
[centers, radii] = imfindcircles(sample, [235 260], ...
    'ObjectPolarity','bright', 'Sensitivity', 0.97);

%{
figure
imshow(sample)
viscircles(centers, radii, 'Color', 'r')
 %}
    
%% Segment each plate to be an individual matrix based on the viscircles radius
%first round the centers and radii
centers = round(centers);
radii = round(radii);

%segment each plate to be an individual matrix - adjust the radius and
%center accordingly
%CONVENTION: make the edge of the inner well touch the outsides but make it
%still a circle so I can mask the other parts

%for trial 2, plate R1 is radius 3, plate R2 is radius 2, and plate R3 is
%radius 1

radii(1) = radii(1) - 22;
plateR3 = data(centers(1,2) - radii(1) : centers(1,2) + radii(1),...
    centers(1,1) - radii(1) : centers(1,1) + radii(1),:);

radii(2) = radii(2) - 26;
plateR2 = data(centers(2,2) - radii(2) : centers(2,2) + radii(2),...
    centers(2,1) - radii(2) : centers(2,1) + radii(2),:);

radii(3) = radii(3) - 24;
plateR1 = data(centers(3,2) - radii(3) : centers(3,2) + radii(3),...
    centers(3,1) - radii(3) : centers(3,1) + radii(3),:);

%plot the last frame of each to make sure the inside of the well is
%represented by the circle
close all
figure
imshow(plateR1(:,:,end))
figure
imshow(plateR2(:,:,end))
figure
imshow(plateR3(:,:,end))

%% Multiple line segment selection - second way of doing it
%selects 4 line segments along each of the cardinal axes - then calculate 8
%edge distances based on these distances

%calculate the vertical and horixontal line segments, orienting them from
%left -> right center -> outwards. All matrices will start with the center
%point as the first element. %data will be represented as a vector of size
%1 x n x 25

%start with the vertical and horizontal lines - call these N,S,E,W
plateR1_n = flip(permute(plateR1(1:radii(3) + 1, radii(3) + 1, :), [2 1 3]), 2);
plateR1_s = permute(plateR1(radii(3) + 1:end, radii(3) + 1, :), [2 1 3]);
plateR1_e = plateR1(radii(3) + 1, radii(3) + 1:end, :);
plateR1_w = flip(plateR1(radii(3) + 1, 1:radii(3) + 1, :));
plateR2_n = flip(permute(plateR2(1:radii(2) + 1, radii(2) + 1, :), [2 1 3]), 2);
plateR2_s = permute(plateR2(radii(2) + 1:end, radii(2) + 1, :), [2 1 3]);
plateR2_e = plateR2(radii(2) + 1, radii(2) + 1:end, :);
plateR2_w = flip(plateR2(radii(2) + 1, 1:radii(2) + 1, :));
plateR3_n = flip(permute(plateR3(1:radii(1) + 1, radii(1) + 1, :), [2 1 3]), 2);
plateR3_s = permute(plateR3(radii(1) + 1:end, radii(1) + 1, :), [2 1 3]);
plateR3_e = plateR3(radii(1) + 1, radii(1) + 1:end, :);
plateR3_w = flip(plateR3(radii(1) + 1, 1:radii(1) + 1, :));

%create the xgrids to relate index to edge distance for each of the plates
xgrid1 = linspace(0, 30, size(plateR1_n,2));
xgrid2 = linspace(0, 30, size(plateR2_n,2));
xgrid3 = linspace(0, 30, size(plateR3_n,2));




