%% Anirudh Topiwala
%% Project 4- Optical Flow
%% Part 1 - Using User Functions

function [C]= harriscornerdetect(img)
% To detect Harris Corner
% Calculating Gradient for apllying differentiation
kx= [1 0 -1; 1 0 -1 ; 1 0 -1];
ky=kx';
Ix= conv2(double(img), double(kx));
Iy= conv2(double(img), double(ky));

% Using Matlabs Inbuilt Function 
% [Ix,Iy]=imgradientxy(img);

% Smoothening the derivatives obtained by applying gaussian filter
sigma=2;
gauss= fspecial('gaussian',fix(6*sigma),sigma);
Ix2=conv2(Ix.^2,gauss);
Iy2=conv2(Iy.^2,gauss);
Ixy=conv2(Ix.*Iy,gauss);

%Calculating R Value
R= (Ix2.*Iy2 -Ixy.^2)./(Ix2+Iy2+eps);

% To reduce redundancy, applying filter to return the max value in a predetermined window
window=5;
maxvalue= ordfilt2(R,window^2,ones(window));

% Thresholding to get corners
threshold=0.001;

[r,c]= find(R>threshold & R==maxvalue);

C= [c r];

% imshow(img)
% hold on
% plot(c,r,'*') 












end
