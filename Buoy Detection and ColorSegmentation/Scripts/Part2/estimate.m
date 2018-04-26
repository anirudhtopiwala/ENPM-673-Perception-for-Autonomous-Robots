%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Part2: Color Model Learning
function [mu,sigma]=estimate(data)
mu=mean(double(data))';
sigma=var(double(data))';
end

