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
%{
figure
imshow(sample)
viscircles(centers, radii, 'Color', 'r')
%viscircles(centers, [200; 200; 200], 'Color', 'b')
%}
%% Segment each plate to be an individual matrix based on the viscircles radius
%first round the centers and radii
centers = round(centers);
radii = round(radii);

%segment each plate to be an individual matrix - adjust the radius and
%center accordingly
%CONVENTION: make the edge of the inner well touch the outsides but make it
%still a circle so I can mask the other parts
radii(1) = radii(1) - 22;
plateR1 = data(centers(1,2) - radii(1) : centers(1,2) + radii(1),...
    centers(1,1) - radii(1) : centers(1,1) + radii(1),:);
%mask out any region which is not in the circle - UNNECESSARY WHEN ALREADY
%CROPPED AND TAKING LINE SEGMENT ACROSS ENTIRE LENGTH
%{
for i = 1:size(plateR1, 1)
    for j = 1:size(plateR1, 2)
        %use the distance formula on i and j indices
        if sqrt((i - size(plateR1,1)/2)^2 + (j- size(plateR1,2)/2)^2) > radii(1)
            plateR1(i,j,:) = 0;
        end
    end
end
%}
radii(2) = radii(2) - 17;
plateR3 = data(centers(2,2) - radii(2) : centers(2,2) + radii(2),...
    centers(2,1) - radii(2) : centers(2,1) + radii(2),:);
%{
for i = 1:size(plateR3, 1)
    for j = 1:size(plateR3, 2)
        %use the distance formula on i and j indices
        if sqrt((i - size(plateR3,1)/2)^2 + (j- size(plateR3,2)/2)^2) > radii(2)
            plateR3(i,j,:) = 0;
        end
    end
end
%}
radii(3) = radii(3) - 16;
plateR2 = data(centers(3,2) - radii(3) : centers(3,2) + radii(3),...
    centers(3,1) - radii(3) : centers(3,1) + radii(3),:);
%{
for i = 1:size(plateR2, 1)
    for j = 1:size(plateR2, 2)
        %use the distance formula on i and j indices
        if sqrt((i - size(plateR2,1)/2)^2 + (j- size(plateR2,2)/2)^2) > radii(3)
            plateR2(i,j,:) = 0;
        end
    end
end
%}

%plot the last frame of each to make sure the inside of the well is
%represented by the circle
close all
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

%first let's look at all of the frames of the video
close all
for i = 1:25
    figure
    imshow(plateR1(:,:,i));
end

%plot the line segments to see what they look like
%THIS MAKES 25 FIGURES GET READY
%{
close all
for i = 1:25
   figure
   plot(line1(1,:,i));
end
%}

%{
close all
for i = 1:25
   figure
   plot(line2(1,:,i));
end
%}
%{
close all
for i = 1:25
   figure
   plot(line3(1,:,i));
end
%}


%% pixel selection method of calculating edge distance
%How it works: user will be given 9 images on which they will select a
%pixel they think represents the edge of the GFP. The average of these
%pixel intensities will be taken as the absolute threshold for brightness.
%I will be using "normalized" images in which the first frame is subtracted
%from all the images

%Background subtraction - subtract the first frame from all frames keeping
%the values minimum 0
for i = 1:25
    plateR1_norm(:,:,i) = plateR1(:,:,i) - plateR1(:,:,1);
    plateR1_norm(plateR1_norm < 0) = 0; 
    plateR2_norm(:,:,i) = plateR2(:,:,i) - plateR2(:,:,1);
    plateR2_norm(plateR2_norm < 0) = 0;
    plateR3_norm(:,:,i) = plateR3(:,:,i) - plateR3(:,:,1);
    plateR3_norm(plateR3_norm < 0) = 0;
end

%lets look at it
%{
close all
for i = 1:25
    figure
    imshow(plateR2_norm(:,:,i));
end
%}


%plot 9 images, 3 from each normalized plate and select a pixel where you
%think the edge distance is
% for plate 1 i will use images 6, 9, and 12
%for plate 2 I will use 16, 20, 24
% for plate 3 I will use 16, 20, 24
pixvals = NaN(1,9);
for i = 1 : 9
    if i < 4
        f = figure;
        index = 3 + 3*i;
        imshow(plateR1_norm(:,:,index));
        [x,y]=ginput(1);
        close all
        pixel_x=round(x);
        pixel_y= round(y);
        pixvals(i) = plateR1_norm(pixel_y,pixel_x,index);
    elseif i > 3 && i < 7
        f = figure;
        index = 12 + 4*(i-3);
        imshow(plateR2_norm(:,:,index));
        [x,y]=ginput(1);
        close all
        pixel_x=round(x);
        pixel_y= round(y);
        pixvals(i) = plateR2_norm(pixel_y,pixel_x,index);
    else
        f = figure;
        index = 12 + 4*(i-6);
        imshow(plateR3_norm(:,:,index));
        [x,y]=ginput(1);
        close all
        pixel_x=round(x);
        pixel_y= round(y);
        pixvals(i) = plateR3_norm(pixel_y,pixel_x,index);
    end
end

%set the threshold
abs_thresh = mean(pixvals);
sd_thresh = std(pixvals);

%now create line segments across the centers of the normalized plates
line1_norm = permute(plateR1_norm(:, ceil(size(plateR1_norm,2)/2), :), [2,1,3]);
line2_norm = plateR2_norm(ceil(size(plateR2_norm,1)/2), :, :);
line3_norm = permute(plateR3_norm(:, ceil(size(plateR3_norm,2)/2), :), [2,1,3]);

%now save the first and last points where the intensity is greater than the
%threshold across each line segment
line1_hidist = NaN(1,25);
line1_lodist = NaN(1,25);
line2_hidist = NaN(1,25);
line2_lodist = NaN(1,25);
line3_hidist = NaN(1,25);
line3_lodist = NaN(1,25);

%create a matrix to index into relating distances from center to indices
%I'll just make these negative to positive but then take the abs() when I
%use
distances1 = linspace(-30, 30, length(line1_norm));
distances2 = linspace(-30, 30, length(line2_norm));
distances3 = linspace(-30, 30, length(line3_norm));

for i = 1:25
    %find where pixel is greater than threshold
    firstind = find(line1_norm(:,:,i) > abs_thresh, 1, 'first');
    lastind = find(line1_norm(:,:,i) > abs_thresh, 1, 'last');
    %check if they're empty
    if isempty(firstind)
        firstval = 0;
    else 
        firstval = abs(distances1(firstind));
    end
    if isempty(lastind)
        lastval = 0;
    else
        lastval = abs(distances1(lastind));
    end
    %now set the lower and upper values accordingly
    line1_hidist(i) = max([firstval, lastval]);
    line1_lodist(i) = min([firstval, lastval]);
    
    %rinse and repeat
    
    %find where pixel is greater than threshold
    firstind = find(line2_norm(:,:,i) > abs_thresh, 1, 'first');
    lastind = find(line2_norm(:,:,i) > abs_thresh, 1, 'last');
    %check if they're empty
    if isempty(firstind)
        firstval = 0;
    else 
        firstval = abs(distances2(firstind));
    end
    if isempty(lastind)
        lastval = 0;
    else
        lastval = abs(distances2(lastind));
    end
    %now set the lower and upper values accordingly
    line2_hidist(i) = max([firstval, lastval]);
    line2_lodist(i) = min([firstval, lastval]);
    
    %find where pixel is greater than threshold
    firstind = find(line3_norm(:,:,i) > abs_thresh, 1, 'first');
    lastind = find(line3_norm(:,:,i) > abs_thresh, 1, 'last');
    %check if they're empty
    if isempty(firstind)
        firstval = 0;
    else 
        firstval = abs(distances3(firstind));
    end
    if isempty(lastind)
        lastval = 0;
    else
        lastval = abs(distances3(lastind));
    end
    %now set the lower and upper values accordingly
    line3_hidist(i) = max([firstval, lastval]);
    line3_lodist(i) = min([firstval, lastval]); 
end

%plot to see what it looks like
close all
time = 0:24;
figure
subplot(3,1,1)
plot(time, line1_lodist)
hold on
plot(time, line1_hidist)
hold off
legend("low", "high", 'Location', 'northwest')
ylim([0 30])
title("R1")
set(gca, 'FontSize', 14)
subplot(3,1,2)
plot(time, line2_lodist)
hold on
plot(time, line2_hidist)
hold off
legend("low", "high", 'Location', 'northwest')
title("R2")
ylim([0 30])
ylabel("Distance (mm)")
set(gca, 'FontSize', 14)
subplot(3,1,3)
plot(time, line3_lodist)
hold on
plot(time, line3_hidist)
hold off
legend("low", "high", 'Location', 'northwest')
title("R3")
ylim([0 30])
xlabel("Time (hr)")
set(gca, 'FontSize', 14)

%lastly save the data

%% Multiple line segment selection - second way of doing it
%selects 4 line segments along each of the cardinal axes - then calculate 8
%edge distances based on these distances

%calculate the vertical and horixontal line segments, orienting them from
%left -> right center -> outwards. All matrices will start with the center
%point as the first element. %data will be represented as a vector of size
%1 x n x 25

%start with the vertical and horizontal lines - call these N,S,E,W
plateR1_n = flip(permute(plateR1(1:radii(1) + 1, radii(1) + 1, :), [2 1 3]), 2);
plateR1_s = permute(plateR1(radii(1) + 1:end, radii(1) + 1, :), [2 1 3]);
plateR1_e = plateR1(radii(1) + 1, radii(1) + 1:end, :);
plateR1_w = flip(plateR1(radii(1) + 1, 1:radii(1) + 1, :));
plateR2_n = flip(permute(plateR2(1:radii(3) + 1, radii(3) + 1, :), [2 1 3]), 2);
plateR2_s = permute(plateR2(radii(3) + 1:end, radii(3) + 1, :), [2 1 3]);
plateR2_e = plateR2(radii(3) + 1, radii(3) + 1:end, :);
plateR2_w = flip(plateR2(radii(3) + 1, 1:radii(3) + 1, :));
plateR3_n = flip(permute(plateR3(1:radii(2) + 1, radii(2) + 1, :), [2 1 3]), 2);
plateR3_s = permute(plateR3(radii(2) + 1:end, radii(2) + 1, :), [2 1 3]);
plateR3_e = plateR3(radii(2) + 1, radii(2) + 1:end, :);
plateR3_w = flip(plateR3(radii(2) + 1, 1:radii(2) + 1, :));

%create the xgrids to relate index to edge distance for each of the plates
xgrid1 = linspace(0, 30, size(plateR1_n,2));
xgrid2 = linspace(0, 30, size(plateR2_n,2));
xgrid3 = linspace(0, 30, size(plateR3_n,2));
