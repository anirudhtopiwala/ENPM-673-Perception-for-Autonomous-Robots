%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Part 0
function [mu,sigma]=estimate(data)
% This function is used to calculate the mean and variance of the input Data
mu=mean(double(data))';
sigma=var(double(data))';
end

