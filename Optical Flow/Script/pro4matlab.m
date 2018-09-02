%% Anirudh Topiwala
%% Project 4- Optical Flow
%% Part 2 - Using Matlab Functions

clc;clear all; 
close all;

%Directory Initialization
inputdata='../Input/Grove/frame';
% outputdir= '../Output/Matlab/Wooden/Wooden_';
outputdir= '../Output/Matlab/Grove/Grove_';

opticflowLK = opticalFlowLK('NoiseThreshold',0.009);
opticflowfnb = opticalFlowFarneback;
opticflowhs = opticalFlowHS;
figure('units','normalized','outerposition',[0 0 1 1])

for k=7:14
    pause(0.1)
    img= imread(sprintf('%s%02d.png',inputdata,k));
    
    %% Optical Flow using Lucas Kandade Method
    flowLK = estimateFlow(opticflowLK,img); 
    subplot(2,2,1)
    imshow(img) 
    title ("Optical Flow Using Lucas Kanade Method");
    hold on
    plot(flowLK,'DecimationFactor',[5 5],'ScaleFactor',10)
    hold off
%     saveas(gcf,sprintf('%sLK%01d.jpg',outputdir,k));

    %% Optical Flow using Farneback Method

    flowfnb = estimateFlow(opticflowfnb,img); 
    subplot(2,2,2)
    imshow(img) 
    title ("Optical Flow Using Farne Back Method ");
    hold on
    plot(flowfnb,'DecimationFactor',[10 10],'ScaleFactor',2)
    hold off
%     saveas(gcf,sprintf('%sFNB%01d.jpg',outputdir,k));




    %% Optical Flow using Horn-Schnuk Method

    flowhs = estimateFlow(opticflowhs,img); 
    subplot(2,2,3)
    imshow(img) 
    title ("Optical Flow Using Horn-Schnuk Method ");
    hold on
    plot(flowhs,'DecimationFactor',[6 6],'ScaleFactor',75)
    hold off
%     saveas(gcf,sprintf('%sHS%01d.jpg',outputdir,k));

    saveas(gcf,sprintf('%sCompare_%01d.jpg',outputdir,k));

    
    
    
    
    
    
    
    
    
    
       
    
end