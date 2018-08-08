%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
clc;clear all;close all;

%Directory Initialization
input='../Input/image.';
output='../Output/image.';
framecount= 32639;
% figure('units','normalized','outerposition',[0 0 1 1])
%% Some Required Parameter defintiions for Thresholding
blob_minarea = 300; % for considering any region worthy enough to predict a traffic sign
numblobs = 10; % Consider this much blobs at any given frame prediction will be done for all these blobs
min_aspect_ratio = 0.6; % Min Aspect Ratio
max_aspect_ratio = 1.2; % Max Aspect Ratio

%% Training and Building Classifier
trafficsignclassifier();
% load('classifier.mat');
for k=85:1:2860
  % Image Reading and Pre-Processing
  pause(0.001)
  img= imread(sprintf('%s%06d.jpg',input,k+framecount));
  imshow(img);
  hold on
  %% Following MSER
   [BMred, BMblue]  =MSER(img);
  %% Getting the Bounding Boxes
  [bboxr]=getboundingbox(BMred,numblobs,blob_minarea,min_aspect_ratio,max_aspect_ratio);
  [bboxb]=getboundingbox(BMblue,numblobs,blob_minarea,min_aspect_ratio,max_aspect_ratio); 
  %% Using Classifier to get signs
   getsignblue(img,bboxb,classifier);
   getsignred(img,bboxr,classifier);
%    frame = getframe(gca);
%    imwrite(frame.cdata, sprintf('%s%06d.jpg',output,k));
end