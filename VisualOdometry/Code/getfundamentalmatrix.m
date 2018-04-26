%% Project 2- Anirudh Topiwala

function [F] = getfundamentalmatrix(points1, points2)
% This function is used to generate the Fundamental Matrix using the given  points


%% Normalized 8 point method

    % Normalizing the Points
    [points1, t1]= normalizepoints(points1);
    [points2, t2]= normalizepoints(points2);

% Generating A matrix using 8 Point Algorithm
    for i=1:size(points1,1)
        A(i,:)= [points2(i,1)*points1(i,1), points2(i,1)*points1(i,2), points2(i,1), points2(i,2)*points1(i,1), points2(i,2)*points1(i,2), points2(i,2), points1(i,1), points1(i,2),1];
    end
    % Finding Out SVD
    [~,~,V] = svd(A);
    % Forming Fundamental matrix
    F= double(reshape(V(:,size(V,2)),[3,3])');
    % Regenrating Fundamental Matrix such that rank=2.
    [U, S,VF] = svd(F);
    S = diag([(S(1,1)+S(2,2))/2 (S(1,1)+S(2,2))/2 0]);% to make rank=2
%     S(3,:)=0; 
    % Reconstructing Fundamental Matrix
    F= U*S*VF';
    % Retransforming back to original coordinates.
     F=t2'*F*t1;
    % Normalizing it
     F= F/ norm(F);
    % Constraint to get correct output
    if F(3,3) < 0
        F = -F;
    end
    % Rescaling the fundamental matrix
%    F(abs(F)<1e-4)=0; 

   % returning F


end