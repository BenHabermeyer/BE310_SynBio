%Analysis file for getting edge distance from the plate data
%% Load in the plate data
clear
clc
close all

%raw data is in a x by y by 25 matrix format - 1 grayscale 2D matrix for
%each of the pictures, spaced 1 hour apart from t=0 to t=24 hours
load PlateData_1s

%divide by 255 to convert between pixels intensity between 0 and 1
data = PlateData_1s / 255;
clear PlateData_1s

%first find the circles representing the plate borders
%do some processing to increase brigtness of plates by changing sensitivity
sample = data(:,:,25);
[centers, radii] = imfindcircles(sample, [175 225], ...
    'ObjectPolarity','bright', 'Sensitivity', 0.97);
figure
imshow(sample)
viscircles(centers, radii, 'Color', 'r')
viscircles(centers, [200; 200; 200], 'Color', 'b')

%% Segment each plate to be an individual matrix based on the viscircles radius
%first round the centers and radii
centers = round(centers);
radii = round(radii);

%segment each plate to be an individual matrix - adjust the radius and
%center accordingly
%CONVENTION: make the edge of the inner well touch the outsides but make it
%still a circle so I can mask the other parts
radii(1) = radii(1) - 3;
plateR1 = data(centers(1,2) - radii(1) : centers(1,2) + radii(1),...
    centers(1,1) - radii(1) : centers(1,1) + radii(1),:);
%mask out any region which is not in the circle
for i = 1:size(plateR1, 1)
    for j = 1:size(plateR1, 2)
        %use the distance formula on i and j indices
        if sqrt((i - size(plateR1,1)/2)^2 + (j- size(plateR1,2)/2)^2) > radii(1)
            plateR1(i,j,:) = 0;
        end
    end
end
plateR3 = data(centers(2,2) - radii(2) : centers(2,2) + radii(2),...
    centers(2,1) - radii(2) : centers(2,1) + radii(2),:);
for i = 1:size(plateR3, 1)
    for j = 1:size(plateR3, 2)
        %use the distance formula on i and j indices
        if sqrt((i - size(plateR3,1)/2)^2 + (j- size(plateR3,2)/2)^2) > radii(3)
            plateR3(i,j,:) = 0;
        end
    end
end
radii(3) = radii(3) - 4;
plateR2 = data(centers(3,2) - radii(3) : centers(3,2) + radii(3),...
    centers(3,1) - radii(3) : centers(3,1) + radii(3),:);
for i = 1:size(plateR2, 1)
    for j = 1:size(plateR2, 2)
        %use the distance formula on i and j indices
        if sqrt((i - size(plateR2,1)/2)^2 + (j- size(plateR2,2)/2)^2) > radii(2)
            plateR2(i,j,:) = 0;
        end
    end
end

%plot the last frame of each to make sure the inside of the well is
%represented by the circle
figure
imshow(plateR1(:,:,end))
figure
imshow(plateR2(:,:,end))
figure
imshow(plateR3(:,:,end))

%find how many pixels represent each 30mm plate
pix_per_mm1 = 2*radii(1) / 60;
pix_per_mm2 = 2*radii(2) / 60;
pix_per_mm3 = 2*radii(3) / 60;

%find the maximum intensity of GFP and set threshold to this
max1 = max(plateR1, [], 'all');
max2 = max(plateR2, [], 'all');
max3 = max(plateR3, [], 'all');

%% finding edge distance for each plate
%HOW TO DO THIS: I just made each plate matrix centered on each plate, so
%just take a line section with pizels horiz, vertical, or diagonal across
%the center. how many = 2x radius + 1

%CHOICE OF AXIS - upon inspection I will take R1 vertically, R2
%horizontally, and R3 vertically for trial 1
%these will be lines, so 1 x width x 25 matrices just to keep time on 3rd
%axis
line1 = permute(plateR1(:, ceil(size(plateR1,2)/2), :), [2,1,3]);
line2 = plateR2(ceil(size(plateR2,1)/2), :, :);
line3 = permute(plateR3(:, ceil(size(plateR3,2)/2), :), [2,1,3]);




