clear; clc; close all

A = cell(1,25);

A0 = imread('Initial_1.0s_Exposure.png');
A{1} = rgb2gray(A0);

A1 = imread('2019_02_25_133613_1.0s_Exposure.png');
A{2} = rgb2gray(A1);

A2 = imread('2019_02_25_140020_1.0s_Exposure.png');
A{3} = rgb2gray(A2);

A3 = imread('2019_02_25_150021_1.0s_Exposure.png');
A{4} = rgb2gray(A3);

A4 = imread('2019_02_25_160021_1.0s_Exposure.png');
A{5} = rgb2gray(A4);

A5 = imread('2019_02_25_170021_1.0s_Exposure.png');
A{6} = rgb2gray(A5);

A6 = imread('2019_02_25_180021_1.0s_Exposure.png');
A{7} = rgb2gray(A6);

A7 = imread('2019_02_25_190021_1.0s_Exposure.png');
A{8} = rgb2gray(A7);

A8 = imread('2019_02_25_200021_1.0s_Exposure.png');
A{9} = rgb2gray(A8);

A9 = imread('2019_02_25_210021_1.0s_Exposure.png');
A{10} = rgb2gray(A9);

A10 = imread('2019_02_25_220021_1.0s_Exposure.png');
A{11} = rgb2gray(A10);

A11 = imread('2019_02_25_230021_1.0s_Exposure.png');
A{12} = rgb2gray(A11);

A12 = imread('2019_02_26_000021_1.0s_Exposure.png');
A{13} = rgb2gray(A12);

A13 = imread('2019_02_26_010021_1.0s_Exposure.png');
A{14} = rgb2gray(A13);

A14 = imread('2019_02_26_020021_1.0s_Exposure.png');
A{15} = rgb2gray(A14);

A15 = imread('2019_02_26_030021_1.0s_Exposure.png');
A{16} = rgb2gray(A15);

A16 = imread('2019_02_26_030021_1.0s_Exposure.png');
A{17} = rgb2gray(A16);

A17 = imread('2019_02_26_040021_1.0s_Exposure.png');
A{18} = rgb2gray(A17);

A18 = imread('2019_02_26_050021_1.0s_Exposure.png');
A{19} = rgb2gray(A18);

A19 = imread('2019_02_26_060021_1.0s_Exposure.png');
A{20} = rgb2gray(A19);

A20 = imread('2019_02_26_070021_1.0s_Exposure.png');
A{21} = rgb2gray(A20);

A21 = imread('2019_02_26_080021_1.0s_Exposure.png');
A{22} = rgb2gray(A21);

A22 = imread('2019_02_26_090021_1.0s_Exposure.png');
A{23} = rgb2gray(A22);

A23 = imread('2019_02_26_100021_1.0s_Exposure.png');
A{24} = rgb2gray(A23);

A24 = imread('2019_02_26_110021_1.0s_Exposure.png');
A{25} = rgb2gray(A24);

A25 = imread('2019_02_26_120021_1.0s_Exposure.png');
A{26} = rgb2gray(A25);

PlateData_1s(1:1944,1:2592,1:25) = 0;

for jj = 1:25
    
    PlateData_1s(:,:,jj) = A{jj};
    
end









