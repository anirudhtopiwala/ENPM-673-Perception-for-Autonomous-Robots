%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
function [Cr,Cb] = processimage(img)
% Function to Preprocess the image such that, it will best identify the red
% color. The formula used here is taken from :
% (Samuele Salti, Alioscia Petrelli, Federico Tombari, Nicola Fioraio, and Luigi Di Stefano. A traffic sign detection pipeline based on interest region extraction. In Neural Networks (IJCNN), The 2013 International Joint Conference on, pages 1–7. IEEE, 2013.)

%% Image Pre Processing
% Denoising the Image using Median Filtering
% imgdenoise= imgaussfilt(img,2);
imgdenoiser= medfilt2(img(:,:,1));
imgdenoiseg= medfilt2(img(:,:,2));
imgdenoiseb= medfilt2(img(:,:,3));

% imgdenoiser= locallapfilt(imguidedfilter(imgdenoiser),0.2,5,'NumIntensityLevels',16);
% imgdenoiseg= locallapfilt(imguidedfilter(imgdenoiseg),0.2,5,'NumIntensityLevels',16);
% imgdenoiseb= locallapfilt(imguidedfilter(imgdenoiseb),0.2,5,'NumIntensityLevels',16);

% imshow(imgdenoise);

% Contrast Normalization over each channel 
imgconnormr = im2double(imadjust(imgdenoiser,stretchlim(imgdenoiser),[]));
imgconnormg = im2double(imadjust(imgdenoiseg,stretchlim(imgdenoiseg),[]));
imgconnormb = im2double(imadjust(imgdenoiseb,stretchlim(imgdenoiseb),[]));
% imshow(imgconnorm);

% Creating 'Cr' for RED signs
Cr = max(0, (min((imgconnormr-imgconnormb),(imgconnormr-imgconnormg)))./((imgconnormr+imgconnormg+imgconnormb)));
% Creating 'Cb' for BLUE signs
Cb = max(0, ((imgconnormb-imgconnormr))./(imgconnormr+imgconnormg+imgconnormb));


end