function nrmse = NRMSE(Y, Yhat)
%Function calculates the NORMALIZED root mean square error of two vectors 
%(1xn)
%
%INPUTS: two vectors Y, the actual data and Yhat, the predicted or modeled
%data
%
%OUTPUTS: output is the nrmse value for the two vectors

n = length(Y);
rmse = sqrt((1/n)*sum((Yhat-Y).^2));
nrmse = rmse / (max(Y) - min(Y));
end
