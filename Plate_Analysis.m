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

%looks like 200 pixels will be my radius - ranged from 197-204

%find how many pixels represent each 30mm plate
pix_per_mm = 200 / 60;

%make the background 0 in all pixels that are in the background at all time

%find the maximum intensity of GFP and set threshold to this