%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
function [BMred, BMblue]= MSER(img)
% This function is used for trafic sign Detection using MSER Features.
%% Get Red and Blue Processed Channels
[Cr, Cb]= processimage(img);
[rows,cols]=size(img(:,:,1));
%% Making mask to remove bottom half of image, as probability of finding signs in lower hald is very less
mask= poly2mask([0, cols,cols,0],[0,0, rows*0.6,rows*0.6],rows,cols);
Cr= im2uint8(Cr.*mask);
Cb=im2uint8(Cb.*mask);
% imshow(Cr);
% imshow(Cb);
%% Detecting MSER Features for both red and blue channels
[r,~]=detectMSERFeatures(Cr,'ThresholdDelta',2,'RegionAreaRange',[100,10000]);
[b,~]=detectMSERFeatures(Cb,'ThresholdDelta',2,'RegionAreaRange',[100,10000]);
%% For Red
BMred=(zeros(rows,cols));
if ( ~isempty(r))
    for i=1:size(r,1)
        temp=double(r(i).PixelList);
        for j=1:size(temp,1)
             BMred(temp(j,2),temp(j,1))= 1;
        end
    end
end
% imshowpair(img,BMred,'Montage');
% imshow(img);hold on;
% plot(b,'showPixelList',true,'showEllipses',false);
% % plot(r,'showPixelList',true,'showEllipses',false);

%% FOR Blue
BMblue= (zeros(rows,cols));
if ( ~isempty(b))
    for i=1:size(b,1)
        temp=double(b(i).PixelList);
        for j=1:size(temp,1)
             BMblue(temp(j,2),temp(j,1))= 1;
        end
    end
end       

BMred= logical(BMred);
BMblue= logical(BMblue);
%% Color Thresholded Mask
[redmask,bluemask]= colorthreshold(img);
% imshow(bluemask);
%% Combining Image
BMred= BMred & redmask;
BMblue= BMblue & bluemask;
% BMred= BMred-BMblue;

% final= finalred | finalblue;
% final= logical(BMred | BMblue);
% final= morphclean(final);

% se = strel('disk',2);
% BMblue = imopen(BMblue,se);
% BMred = imopen(BMred,se);

% imshow(BMblue)
% final = imfill(final, 'holes');
BMred= imfill(BMred, 'holes');
BMblue=imfill(BMblue, 'holes');

%% Plotting
% % % subplot(2,2,3:4)
% % % imshowpair(BMblue1,BMred1,'Montage');
% % % % subplot(2,2,1:2)
% imshowpair(BMred,redmask,'Montage');
% % % subplot(2,2,1:2)
% imshowpair(BMblue,BMred,'Montage');
% subplot(2,2,4)
% imshow(finalblue);
% return        
end



