%% Project 2- Anirudh Topiwala
%% Visual odometry Using User Defined  Functions

%% Initializng Variables.
clc;clear all;close all;

% Setting Dataset Directory
D = '../Input/stereo/centre/';
models_dir= '../Input/model/';
S = dir(strcat(D,'*.png')); 

%Getting Intrinsic Parameters- Note here the intrinsic matrix is a upper triangular matrix as compared to lower triangular for matlab user defined functions
[fx, fy, cx, cy, G_camera_image, LUT] = ReadCameraModel(D, models_dir);
intrinsic=[fx 0 0;0 fy 0; cx cy 1]';
intrinsicmatlab=[fx 0 0;0 fy 0; cx cy 1];

% cameraParams = cameraParameters('IntrinsicMatrix',intrinsic);
cameraParams = cameraParameters('IntrinsicMatrix',intrinsic);
cameraParamsmatlab = cameraParameters('IntrinsicMatrix',intrinsicmatlab);


% Initializing Variables
xc(1)=0;yc(1)=0;zc(1)=0;c=2;H = repmat(eye(4),[1,1,length(S)]);h=eye(4);
xmatlab(1)=0;ymatlab(1)=0;zmatlab(1)=0;Hmatlab = repmat(eye(4),[1,1,length(S)]);hmatlab=eye(4); alpha=0;
% Generating Figure
figure('units','normalized','outerposition',[0 0 1 1])
% hold on

% Creating Video.jpg
workingDir = '../OutPut'; %Setting Working Directory to store video

vidObj = VideoWriter(fullfile(workingDir,'Run1.avi'));
vidObj.FrameRate = 30;
open(vidObj);


%% For loop for reading images and plotting camera centers.
for k = 20:numel(S)
    
    %% Reading First Image 
    img1 = UndistortImage(demosaic(imread(strcat(D,S(k-1).name)),'gbrg'),LUT);

    % Inserting a trapezium shape on the car bonnet as it will remain
    % unchanges with moving car and therefore should not be considered for
    % correspondance points.
    pos=[0 960 0 886 166 816 1132 816 1280 886 1280 960];
    img1shape = insertShape( img1,'FilledPolygon',pos,'Opacity',1,'Color','black');
    
    % Equalizing the image
    img1g=histeq(rgb2gray(img1shape));
    
    % Another method to set camera matrix
%     cameraParams = cameraIntrinsics([fx fy],[cx,cy],size(img1g));

    %% Reading Second image
    img2 = UndistortImage(demosaic(imread(strcat(D,S(k-0).name)),'gbrg'),LUT);
    img2shape = insertShape( img2,'FilledPolygon',pos,'Opacity',1,'Color','black');
    img2g=histeq(rgb2gray(img2shape));


    %% Extracting Correspondance points
    
    % Detecting Points Using SURF
    p1 = detectSURFFeatures(img1g);
    p2 = detectSURFFeatures(img2g);
    
%      Uniformly Distributing the Points
%     p1 = selectUniform(p1, 500, size(img1g));
%     p2= selectUniform(p2, 500, size(img2g));

    % Extracting Features to get Validated Points
    [f1,vpts1] = extractFeatures(img1g,p1);
    [f2,vpts2] = extractFeatures(img2g,p2);

    % Forming Index Pairs
    indexPairs = matchFeatures(f1,f2,'Unique', true) ;

    % Getting Matched Points.
    matchedPoints1 = vpts1(indexPairs(:,1));
    matchedPoints2 = vpts2(indexPairs(:,2));
    

    % [tform,inliers1,inliers2] = estimateGeometricTransform(matchedPoints1,matchedPoints2,'affine');
    
    %% Getting Fundamental Matrix
%     [F, inliers] = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC');  % Using Matlab Function
  
      [F,inliers]= Ransac(matchedPoints1.Location,matchedPoints2.Location,size(img1g)); % Using User Function
    %% Getting Essential Matrix
    E= single(intrinsic'*F*intrinsic);  % Using User Function
    
%   E= intrinsicmatlab*F*intrinsicmatlab';  % Using Matlab's getfundamental  matrix.

%  [E, Einliers] = estimateEssentialMatrix(matchedPoints1,matchedPoints2,cameraParams) ; % Using Matlab's Inbuilt Function
    %% Getting the Relative Roatation and Translation between Frames.
    % Get the pairs of rot and trans
    [rots, trans]= essentialmatrixbreakdown(E);
   
    % Multiplying the points with inv(intrinsic) to take care of intrisic
    % parameters and making it easy to eatimate 3D world point.
     [oldpoints, newpoints]= pointsafterinvk( matchedPoints1.Location(inliers,:), matchedPoints2.Location(inliers,:),intrinsic);
     

    % Selecting the Best Rotation and Translation pair
     [newR, newT,alpha]= getbestpair(rots,trans,oldpoints, newpoints,alpha);

%     [newR,newT] = relativeCameraPose(F,cameraParamsmatlab,matchedPoints1.Location,matchedPoints2.Location); % Using Matlab Function


    %% Continous Generation of H matrices and extracting the last column to get camera center.

        h= h*[newR newT ; 0 0 0 1];
        xc(c)=h(1,4); yc(c)=h(2,4); zc(c)=h(3,4);
        H(:,:,c-1)=h;     
    
    %% Get Matlab used functions plot
%     [xmatlab, ymatlab, zmatlab,Hmatlab,hmatlab]= getmatlabplot(matchedPoints1,matchedPoints2,intrinsic,hmatlab,xmatlab, ymatlab, zmatlab,c,Hmatlab);

    %% Generating Display
%     subplot(2,2,2) % Image frame
%     imshow(img1);
%     title('Camera Frame')
% 
%     subplot(2,2,4) % Image frame with features
%     imshow(img1);
%     hold on
%     plot(matchedPoints1.Location(:,1),matchedPoints1.Location(:,2),'gx');
%     hold off
%     title('Corresponding Points')
% 
%     subplot(2,2,[1,3]) % 2-D plot from vehicle view
%     hold on
%     plot(xc(c-1:c),zc(c-1:c),'r'); 
%     plot(xmatlab(c-1:c),zmatlab(c-1:c),'b');
%     daspect([1 1 1])
%     pbaspect([1 1 1])
%     hold off
%     legend('User Defined Functions','Matlab Functions')
%   
%     xlabel('Motion in x-direction')
%     ylabel('Motion in z-direction')
%     title('2-D Plot of Camera Centers')
%     
%     writeVideo(vidObj, getframe(gcf));
% 
%      
% pause(0.01)
c=c+1;
end
% close(vidObj);  
figure
hold on

for c=2:length(xc)
    
    plot(xc(c-1:c),zc(c-1:c),'r'); 
    plot(xmatlab(c-1:c),zmatlab(c-1:c),'b');
%    legend('User Defined Functions','Matlab Functions')

end

   
      
