function [closeBW]= processimg(img)
%% Implementing ROI

pos_poly=[ 175 715 0 715 0 0 1280 0 1280 715 1210 715 705 429 553 430 ];
imgshape= insertShape(img,'FilledPolygon', pos_poly,'Opacity',0.8,'Color',{'black'});
% imgshape1= insertShape(imgshape,'FilledPolygon', pos_poly1,'Opacity',0.7,'Color',{'black'});
% imshow(imgshape);
% imshowpair(imgshape,img,'montage'), title('Blur image');

%%   Blurring Image
B = imgaussfilt(imgshape,3);
% imshowpair(img,B,'montage'), title('Blur image');
B=rgb2gray(B);

%% Edge Detection
% B=rgb2gray(B);
BW= edge(B ,'Sobel',0.014,'vertical');
% imshowpair(img,BW,'montage'), title('SObel');

%% Line Joining
se= strel('disk',7);
SE= strel('disk',2);

closeBW = imclose(BW,se); 
% imshowpair(img,closeBW,'montage'), title('Joining lines');

closeBW = imerode(closeBW,SE);
% imshowpair(img,closeBW,'montage'), title('Joining lines');
% pause(0.5);

end




 
