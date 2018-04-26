%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Part 0

function [] = plotgauss(xtot,color)
% This function is used to plot the 
% color='r';

% Setting Directory
part0seg='../../Output/Part0/gauss1D/';

% Plotting Histogram and Gaussian
figure
hold on
xtot= sort(xtot);
[heights,locations] = hist(xtot);
width = locations(2)-locations(1);
heights = heights / (size(xtot,1)*width);
bar(locations,heights,'hist')
 
 
options = statset('MaxIter',500);
t=fitgmdist(xtot,1,'Options',options,'CovarianceType','full'); 
ynew = pdf(t,xtot);
plot(xtot,ynew,color,'LineWidth',4);
hold off

saveas(gcf,sprintf('%s%s_gauss1D.jpg',part0seg,color));

end