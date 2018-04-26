% Anirudh Topiwala
% Main function to count colors.
% 3 methods have been used to count the number of pins. The most accurate
% method is method 3 ; as edge detection is better than calculating
% boundaries.

clc; clear;close all;
img = imread('TestImgResized.jpg');
% img = imread('test2.jpeg'); % Tested on other images

% % Increasing Contrast
% img = imadjust(img,stretchlim(img),[]);
o=0;

%% This section of code is for function countcolor1
%Separating out color planes and then fusing them to remove transparent and white pins
% For Red
img_r= imsubtract(img(:,:,1),rgb2gray(img));
% For Green
img_g= imsubtract(img(:,:,2),rgb2gray(img));
%  For Blue
img_b(:,:,3)= imsubtract(img(:,:,3),rgb2gray(img));
% Mixing images
mixofrg= imfuse(img_r,img_g);
imgfused= imfuse(mixofrg, img_b);
imgfused=rgb2gray(imgfused);

%% Using the Function Gettotalpins to get the number of pins
[bimg, numpin]= gettotalpins(img, imgfused,o);
%%  Using the function countcolors to get the count of each color
% [reds, greens,blues,yellows]= countcolors(img,imgfused);

%comment out the above line if want to try out other methods.

%% Using the function count colors 2 to get a count

% countcolors2(img);

%comment out the above line if want to try out other methods.

%% Calculating white and transparent pins

% whitetransparent(img,numpin);

%comment out the above line if using countcolors3


%% Counting ALL colors using countcolor3

countcolors3(img); 
% USe this method as this is the most reliable method; also tested on other
% examples




    


