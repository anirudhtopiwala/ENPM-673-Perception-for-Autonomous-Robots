function [numpinwt] = whitetransparent(img,numpin)

% In this function I am  calculating the total number of pins, including
% the white and the transparent pins. Here I am inverting the image and
% isolating the blue color so as to highlight the white and the transparent
% pins. After that I have counted the pins from the binary image formed.

% Inputs: img= original image ; numpin= total number of colored pins
%Outputs: Total number of white or transparent Pins


imgc = imadjust(img,stretchlim(img),[]); % To increase the Contrast
invtimg= imcomplement(imgc); % This will invert the image and highlight the white and the transparent pins
% imshow(invtimg);

img_b= imsubtract(img(:,:,3),rgb2gray(invtimg)); %isolating the blue color
% imshow(img_b);


%% This is use to blur the image
 intImage = integralImage(img_b);
 avgH = integralKernel([1 1 7 7], 1/49);
 J = integralFilter(intImage, avgH);
 blurimg= uint8(J);  
%  imshow(blurimg);

%% Calculating the Binary Image
level=0.09282;
bimg = imbinarize(blurimg, level); 
% imshow(bimg);
%% Calculating boundaries and centroid
B = bwboundaries(bimg);
% figure
% imshow(img);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
    
end
hold off

% NUMBER OF PINS
numpinwt=k;
whitetransparent= numpinwt-numpin;

h = msgbox(sprintf('Whites and Transparent = %d', whitetransparent));

end
