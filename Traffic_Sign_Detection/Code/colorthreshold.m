%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
function [redmask,bluemask]= colorthreshold(img)

% This is used to generate red and blue mask, which are obatined by
% thresholding saturation and value plane in HSV. Values are obtained by
% experimentation.
imghsv = rgb2hsv(img);
s = imghsv(:,:,2);
v = imghsv(:,:,3);
%imtool(im_v)
%imtool(im_s)
%% FOR RED
sthresr = s >= 0.5 &  s <=0.9;
vthresr = v >= 0.20 & v <=0.75 ; %0.65
redmask = sthresr & vthresr;
% subplot(2,1,1)
% imshowpair(img,red_mask,'Montage');

%% FOR BLUE
sthresb = s >= 0.45 & s <= 0.8;
vthresb = v >= 0.35 & v <= 1; 
bluemask = sthresb & vthresb;
% subplot(2,1,2)
% imshowpair(img,blue_mask,'Montage');



end