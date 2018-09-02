%% Anirudh Topiwala
%% Project 4- Optical Flow
%% Part 1 - Using User Functions

clc;clear all; 
% close all;

%Directory Initialization
% inputdata='../Input/Wooden/frame';
% outputdircorner= '../Output/Wooden/Wooden_LK_HarrisCorner';
% outputdir= '../Output/Wooden/Wooden_LK';
% outputdirmatlab= '../Output/Wooden/framematlab';
% 
inputdata='../Input/Grove/frame';
outputdircorner= '../Output/Grove/Grove_LK_HarrisCorner';
outputdir= '../Output/Grove/Grove_LK';
outputdirmatlab= '../Output/Grove/framematlab';


opticflow = opticalFlowLK('NoiseThreshold',0.009);
figure('units','normalized','outerposition',[0 0 1 1])
for k=8:14
    
    %% Reading Images
    img1= imread(sprintf('%s%02d.png',inputdata,k-1));
    img2= imread(sprintf('%s%02d.png',inputdata,k));
    
%     img1 = imresize(img1, 0.5);
%     img2 = imresize(img2, 0.5);
    
    %% Optical Flow Using Harris Corner Detection
%     [C,u,v]=getopticalflowcorner(img1,img2);
%     % Quiver Plot
%     imshow(img2);
%     hold on
%     q=quiver(C(:,1), C(:,2), u,v,1,'r');
%     set(q, 'AutoScale', 'on', 'AutoScaleFactor',4  );
%    
%     q.LineWidth=5;
%     q.AutoScale= 'on';
%     q.AutoScaleFactor= 2;


%     Saving Figure
%     saveas(gcf,sprintf('%s%01d.jpg',outputdircorner,k));
    
    %% Optical Flow Using the Whole Image
     [x,y,u,v]=getopticalflow(img1,img2);
   % Quiver Plot
    imshow(img2);
    hold on
    q=quiver(x,y, u,v,'r');
    set(q, 'AutoScale', 'on', 'AutoScaleFactor',2 );
%     Saving Figure
     saveas(gcf,sprintf('%s%01d.jpg',outputdir,k));
   
    
    %% Optical Flow Using Matlab
%     flow = estimateFlow(opticflow,img1); 
%     imshow(img2) 
%     hold on
%     plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
%     saveas(gcf,sprintf('%s%01d.jpg',outputdirmatlab,k));
%        

    
end