%Third  day's analysis

%read in the raw data from the excel file
raw_absorbance = xlsread('Correct Data.xlsx', 1);
raw_fluorescence = xlsread('Correct Data.xlsx', 2);

%just get the averaged data
absorbance = raw_absorbance(1,1:60);
fluorescence = raw_fluorescence(1,1:60);

%sort it and take the mean of the 2 reps
R1a = reshape(absorbance(1:20), [10, 2]);
R1f = reshape(fluorescence(1:20), [10, 2]);
R2a = reshape(absorbance(21:40), [10, 2]);
R2f = reshape(fluorescence(21:40), [10, 2]);
R3a = reshape(absorbance(41:60), [10, 2]);
R3f = reshape(fluorescence(41:60), [10, 2]);

%normalize for optical density by dividing by absorbance
R1 = R1f ./ R1a;
R2 = R2f ./ R2a;
R3 = R3f ./ R3a;

%now take the mean of each sample
R1 = mean(R1, 2);
R2 = mean(R2, 2);
R3 = mean(R3, 2);

%no subtract the 0 value from each sample
R1 = R1 - R1(end);
R2 = R2 - R2(end);
R3 = R3 - R3(end);

R1 = R1(1:end-1);
R2 = R2(1:end-1);
R3 = R3(1:end-1);

%% plot dat boi
%concentrations of AHL in the bacteria
conc = [9.9E-5; 9.9E-6; 9.9E-7; 9.9E-8; 9.9E-9; 9.9E-10; 9.9E-11; 9.9E-12;...
    9.9E-13];

close all
figure
semilogx(conc, R1, 'o--')
xlim([1E-13, 1E-3])
hold on
semilogx(conc, R2, 'o--')
semilogx(conc, R3, 'o--')
xlabel('[AHL] in bacteria (M)')
ylabel('Average fluorescence per OD (N=2)')
legend('R1', 'R2', 'R3')

%% find the RMSE
clc
%vary n1 and KR using Equation 1 and calculate minimum RMSE

%define KR and n1 to vary across
howmany = 250;
KRs = logspace(-13, -6, howmany);
n1s = linspace(0.8, 4, howmany);

%kr will be row, n1 will be col
rmse1 = NaN(howmany);
rmse2 = NaN(howmany);
rmse3 = NaN(howmany);

%fill in the RMSE matrix NORMALIZE
for k = 1:length(KRs)
    for n = 1:length(n1s)
        Yhat = Equation1(KRs(k), n1s(n), conc);
        rmse1(k, n) = RMSE(Yhat./max(Yhat), R1./max(R1));
        rmse2(k, n) = RMSE(Yhat./max(Yhat), R2./max(R2));
        rmse3(k, n) = RMSE(Yhat./max(Yhat), R3./max(R2));
    end
end

%find the minimum values for each
[row1, col1] = find(rmse1 == min(rmse1, [], 'all'));
[row2, col2] = find(rmse2 == min(rmse2, [], 'all'));
[row3, col3] = find(rmse3 == min(rmse3, [], 'all'));

str1 = strcat('The minimum RMSE for R1 occurred with parameters KR = ', ...
    num2str(KRs(row1)), ' and n1 = ', num2str(n1s(col1)));
str2 = strcat('The minimum RMSE for R2 occurred with parameters KR = ', ...
    num2str(KRs(row2)), ' and n1 = ', num2str(n1s(col2)));
str3 = strcat('The minimum RMSE for R3 occurred with parameters KR = ', ...
    num2str(KRs(row3)), ' and n1 = ', num2str(n1s(col3)));
disp(str1)
disp(str2)
disp(str3)

%Overlay plots of RMSE curves and experimental data
close all
figure
subplot(3,1,1)
r1 = strcat('Model 1 RMSE = ', num2str(min(rmse1, [], 'all')));
semilogx(conc, R1./max(R1), '.--', 'MarkerSize', 20, 'LineWidth', 1.5)
xlim([1E-13, 1E-3])
hold on
semilogx(conc, Equation1(KRs(row1), n1s(col1), conc), 'LineWidth', 1.5);
%xlabel('[AHL](M)')
%ylabel('Normalized fluorescence per OD')
legend('Experimental data (N=2)', r1, 'Location', 'northwest')
set(gca, 'FontSize', 14)
subplot(3,1,2)
r2 = strcat('Model 2 RMSE = ', num2str(min(rmse2, [], 'all')));
semilogx(conc, R2./max(R2), '.--', 'MarkerSize', 20, 'LineWidth', 1.5)
xlim([1E-13, 1E-3])
hold on
semilogx(conc, Equation1(KRs(row2), n1s(col2), conc), 'LineWidth', 1.5);
%xlabel('[AHL](M)')
ylabel('Normalized fluorescence per OD')
legend('Experimental data (N=2)', r2, 'Location', 'northwest')
set(gca, 'FontSize', 14)
subplot(3,1,3)
r3 = strcat('Model 3 RMSE = ', num2str(min(rmse3, [], 'all')));
semilogx(conc, R3./max(R3), '.--', 'MarkerSize', 20, 'LineWidth', 1.5)
xlim([1E-13, 1E-3])
hold on
semilogx(conc, Equation1(KRs(row3), n1s(col3), conc), 'LineWidth', 1.5);
xlabel('[AHL](M)')
%ylabel('Normalized fluorescence per OD')
legend('Experimental data (N=2)', r3, 'Location', 'northwest')
set(gca, 'FontSize', 14)



function rmse = RMSE(Yhat, Y)
n = length(Y);
rmse = sqrt((1/n)*sum((Yhat-Y).^2));
end

