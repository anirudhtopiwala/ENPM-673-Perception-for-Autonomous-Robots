function [bimgr,numpinr,bimgb,numpinb,bimgg,numping,numpiny] = countcolors2(img)

o=0; % This is a constant which is used as the thresholding level for green color conversion to binary image is different.

%In this second attempt I decided to separate out each color and get a
%count. While doing this we see that that red color is also found in yellow
%pins,similarly green is also found in the yellow pins. Therefore, I have
%individually counted the pins of the binary image formed after indivudal
%color separation, add them together and subtract from total number of pins
%to get the number of yellow pins. 

%% Separating Colors
% Seperating RED
img_r= imsubtract(img(:,:,1),rgb2gray(img));
[bimgr, numpinr]= gettotalpins(img, img_r,o);
% Seperating Green
img_g= imsubtract(img(:,:,2),rgb2gray(img));
o=1; % The Constant is set as 1; because thresholding level is different
% figure
% imshowpair(img,img_g,'montage'), title('green');
[bimgg, numping]= gettotalpins(img, img_g,o);
o=0;

% Seperating Blue
img_b= imsubtract(img(:,:,3),rgb2gray(img));
[bimgb, numpinb]= gettotalpins(img, img_b,o);
%% Getting total pins from the method of individual separating out colors and fusing their greyscale.
mixofrg= imfuse(img_r,img_g);
imgfused= imfuse(mixofrg, img_b);
imgfused=rgb2gray(imgfused);

%% Using the Function Gettotalpins to get the number of pins
mixofrg= imfuse(img_r,img_g);
imgfused= imfuse(mixofrg, img_b);
imgfused=rgb2gray(imgfused);

[bimg, numpin]= gettotalpins(img, imgfused,o);

%%
numgreenyellow= numping-numpinb;
numpiny= numpinr+numgreenyellow+numpinb- numpin;
numpinr=numpinr-numpiny;
numping=numgreenyellow-numpiny;

h = msgbox(sprintf('Reds= %d, Greens= %d,Blues= %d, Yellows= %d', numpinr, numping, numpinb, numpiny));


end



