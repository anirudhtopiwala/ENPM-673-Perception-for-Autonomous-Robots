%% Project 2- Anirudh Topiwala

function  [xc, yc, zc,H,h]= getmatlabplot(matchedPoints1,matchedPoints2,intrinsic,h,xc,yc,zc,c,H)
 
%% Generating Fundamental Matrix
    cameraParams = cameraParameters('IntrinsicMatrix',intrinsic');


    [F, inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,'Method','RANSAC');
    % [E,inliers] = estimateEssentialMatrix(inliers1.Location, inliers2.Location,cameraParams);

    %% A debugging tool to see how many inliers are generated with respect to the total number of matched points.
    % h=msgbox( sprintf('inliers for c #%d is %d with tot points %d', c,sum(inliers), size(inliers1.Location,1)));
    % pause(1);
    % delete(h);
    
    %% Getting Relative Pose
    [newR,newT] = relativeCameraPose(F,cameraParams,matchedPoints1.Location(inliers,:), matchedPoints2.Location(inliers,:));
    Fstore(:,:,c-1)=F;    %  Storing Fundamental matrices generated  

    %% Continous Generation of H matrices and extracting the last column to get camera center.
    h= h*[newR' newT' ; 0 0 0 1];
    xc(c)=h(1,4); yc(c)=h(2,4); zc(c)=h(3,4);
    H(:,:,c-1)=h; 



end
