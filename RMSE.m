function rmse = RMSE(Y,Yhat)
%Function calculates the root mean square error of two vectors (1xn)
%
%INPUTS: two vectors Y, the actual data and Yhat, the predicted or modeled
%data
%
%OUTPUTS: output is the rmse value for the two vectors

n = length(Y);
rmse = sqrt((1/n)*sum((Yhat-Y).^2));
end

