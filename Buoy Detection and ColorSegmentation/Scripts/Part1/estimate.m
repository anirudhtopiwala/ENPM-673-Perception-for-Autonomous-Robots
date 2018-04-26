%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Part1: Expectation and maximization
function [mu,sigma]=estimate(data)
mu=mean(double(data))';
sigma=var(double(data))';
end

