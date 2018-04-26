%% Project 2- Anirudh Topiwala

function [newpoints, T] = normalizepoints(points)

% This function normalizes the points such that they are centered around
% the mean and and at a distance of sqrt(2)  

% calculating Centroid
neworigin= [(mean(points(:,1))), (mean(points(:,2))),1];
% Subtracting from all points, to move the points around the new origin
shiftpoints= points-neworigin;
% Calculating dist of all points from new origin
dist = sqrt(shiftpoints(:,1).^2 + shiftpoints(:,2).^2);
% Divide and scale to sqrt(2) distance
meandist = mean(dist(:));  
scale = sqrt(2)/meandist;
% scale = 1/meandist;       % Use this, if dist not required to be sqrt(2)


% Transformation matrix
    T = double([scale   0   -scale*neworigin(1)
         0     scale -scale*neworigin(2)
         0       0      1      ]);
  
% points= horzcat(points,ones(size(points,1),1));
    
newpoints= T*points';
newpoints=newpoints';
a= newpoints(:,1);
b= newpoints(:,2);
newpoints= horzcat(a,b);

end
