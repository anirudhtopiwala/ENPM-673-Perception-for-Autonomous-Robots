%% Make Video

clc;clear all;close all;

%% Define Input Directory

input='../../Output/Extracredit/LAB/';
S = dir(strcat(input,'*.jpg')); 

output='../../Output/Extracredit/LAB/';

%% Defining Video
v = VideoWriter(sprintf('%sLAB-ngauss=3',output));
v.FrameRate=5;
open(v)
% Loop to read all images in Input Set
for i=1:numel(S) 
    try
 writeVideo(v,imread(sprintf('%sseg_%03d.jpg',input,i)))
    catch
        continue
    end
end
close(v);