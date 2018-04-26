%% Project 1: Land Detectiona and Turn Prediciton
% Anirudh Topiwala UID: 115192386

clc; clear;close all;
% v = VideoReader('project_video.mp4');   % Reading Frames
v = VideoReader('challenge_video.mp4');

workingDir = 'F:\UMD SEM 2\ENPM 673 Perception\Projects\Project 1'; %Setting Working Directory to store video

outputVideo = VideoWriter(fullfile(workingDir,'challengevideo.avi'));
outputVideo.FrameRate = v.FrameRate;
open(outputVideo);mlprevious=0;mrprevious=0;xy_longlprevious=0;xy_longrprevious=0;xintersect=0;yintersect=0;

%% Frame Loop
ii=1;
while hasFrame(v)
img= readFrame(v);
%% Hough Transform
[imgshapetext, mlprevious,mrprevious,xy_longlprevious,xy_longrprevious,xintersect,yintersect]=houghtransform(img,mlprevious,mrprevious,xy_longlprevious,xy_longrprevious,ii,xintersect,yintersect);
% This function identidies the line and lane and predict the turns

%% Making a Video
writeVideo(outputVideo,imgshapetext); %% USed to make video
ii=ii+1;

end
 close(outputVideo);
shuttleAvi = VideoReader(fullfile(workingDir,'challengevideo.avi'));
ii = 1;
while hasFrame(shuttleAvi)
   mov(ii) = im2frame(readFrame(shuttleAvi));
   ii = ii+1;
end
figure
imshow(mov(1).cdata, 'Border', 'tight')
movie(mov,1,shuttleAvi.FrameRate)

