%% Make Video

clc;clear all;close all;

%% Define Input Directory

outputdir= '../Output/Grove/Grove_LK';
% S = dir(strcat(input,'*.jpg')); 


%% Defining Video
v = VideoWriter(sprintf('%s',outputdir));
v.FrameRate=0.9;
open(v)
% Loop to read all images in Input Set
for i=8:14

 writeVideo(v,imread(sprintf('%s%01d.jpg',outputdir,i)));
% pause(1)
end
close(v);