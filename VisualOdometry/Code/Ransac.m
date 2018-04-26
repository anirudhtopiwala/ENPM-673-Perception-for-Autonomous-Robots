%% Project 2- Anirudh Topiwala
% Reference taken by Dr. Mubarak Shah’s Lecture
function [F, inliers] = Ransac(oldPoints, newPoints, imgSize)

%% This function is used to divide the points in 8x8 grid and then select 8 random points for estimating fundamental matrix.
  
% Convert image points to homogeneous coordinates by adding 1.
    oldPoints = [oldPoints, ones(length(oldPoints),1)];
    newPoints = [newPoints, ones(length(newPoints),1)];

    % Making an 8x8 grid 
    grid = cell(8,8);
    gridlength = zeros(8); resolution = imgSize/8;
    % Dividing points into the 64 grids depending upon their position.
    for i = 1:8
        for j = 1:8
            grid{i,j} = find((oldPoints(:,2)>((i-1)*resolution(1)))&(oldPoints(:,2)<=(i*resolution(1)))&(oldPoints(:,1)>((j-1)*resolution(2)))&(oldPoints(:,1)<=(j*resolution(2))));
            gridlength(i,j) = numel(grid{i,j});
        end
    end
    filledgrid = find(gridlength~=0); % indexing the grids which have atleast some length or which are not empty.
    
    % Randomly selecting which index will be used. 
    k = 0; gridcheck = zeros(1000,8);
    indexcheck = zeros(1000,8);
    while k < 1000
        k = k+1;
        gridcheck(k,:) = filledgrid(randperm(length(filledgrid),8)); % Getting 8 random indices
        for index = 1:8
            i = rem(gridcheck(k,index),8);
            if i == 0
                i = 8;
            end
            j = ceil(gridcheck(k,index)/8);
            indexcheck(k,index) = randi(gridlength(i,j));
        end
        % Checking if there is a repetition in grid index selected. If yes, then rerun the loop. 
        if k~=1   
            samegrid = find(all(gridcheck(1:k-1,:)==gridcheck(k,:),2));  
            if ~isempty(samegrid)
                if any(all(indexcheck(samegrid,:)==indexcheck(k,:),2))
                    k = k - 1;
                end
            end
        end
    end
    i = rem(gridcheck,8);
    i(i==0) = 8;
    j = ceil(gridcheck/8);
    
    %% Once we have the the points sorted into the grid, we now find the best fundamental matrix
    points1 = zeros(8,3); points2 = zeros(8,3);
    maxinliers = 0; inliers = [];
    for k = 1:1000
        % Get the 8 points to calculate fundamental matrix.
        for index = 1:8
            points1(index,:) = oldPoints(grid{i(k,index),j(k,index)}(indexcheck(k,index)),:);
            points2(index,:) = newPoints(grid{i(k,index),j(k,index)}(indexcheck(k,index)),:);
        end
        
        % Estimate the fundamental matrix
        F = getfundamentalmatrix(points1, points2);
        
        % Calculate error
        ep1 = F*oldPoints'; ep2 = F'*newPoints';
        e = sum(newPoints*F.*oldPoints,2).^2./(sum(ep1(1:2,:).^2)'+sum(ep2(1:2,:).^2)');
        % Storing the maximum number of inliers
        totinliers = e <= 0.01;
        if maxinliers < sum(totinliers)
            maxinliers = sum(totinliers);
            inliers = totinliers;
        end
    end
    
    %% Estimate the fundamental matrix using max inliers
    F = getfundamentalmatrix(oldPoints(inliers,:), newPoints(inliers,:)); % Calculating fundamental with max inliers.

end