function [bimg , numpin]= gettotalpins(img,imgfused,o)
% This function is used to calcuate the total number of pins in the
% image. The way I am doing this is, I am calculating the boundaries from
% the binary images.

% Input: img = original image; imgfused= the image on which binary
% operations will be carried out, o= not relevant to this function, in
% association to the function countcolors2.

%% Noise.. Blurring
 intImage = integralImage(imgfused);
 avgH = integralKernel([1 1 7 7], 1/49);
 J = integralFilter(intImage, avgH);
 blurimg= uint8(J);
% imshowpair(img,blurimg,'montage'), title('blur');

%%  Clearing Borders and FILLing holes
blurimg=imfill(blurimg,'holes');
blurimg= imclearborder(blurimg);


%% Binary Conversion
if o==0
level=0.117;
elseif o==1
    level=0.01455;
end
bimg = imbinarize(blurimg, level); 
% figure
% imshowpair(img,bimg,'montage'), title('bimg');
%%  Clearing Borders and FILLing holes
bimg=imfill(bimg,'holes');
bimg= imclearborder(bimg);
% imshow(bimg);
%% Boundary
B = bwboundaries(bimg);
figure
imshow(img);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
    
end
hold off

% NUMBER OF PINS
numpin=k;
end