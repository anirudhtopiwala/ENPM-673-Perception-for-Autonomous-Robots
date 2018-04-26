%% Project 2- Anirudh Topiwala

function [points1, points2]= pointsafterinvk( p1, p2,k)

% This function is used to multiply inverse of intrinsic params to the
% points. This is part of the process of locating the 3D world point.
 
points1new= horzcat(p1,ones(size(p1,1),1));
points2new= horzcat(p2,ones(size(p2,1),1));
points1k= inv(k)*points1new';
points1= points1k';
points2k= inv(k)*points2new';
points2= points2k';

end