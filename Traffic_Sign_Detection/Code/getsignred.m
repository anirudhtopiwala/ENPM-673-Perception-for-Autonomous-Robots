%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
function [] = getsignred(img,bbox,classifier)
% Function used to classify images for red sign bounding boxes obtained.
img_grey= rgb2gray(img);
box_select= [];

for i=1: size(bbox,1)
   box_select = bbox(i,:);
   img_sign = imcrop(img_grey,box_select);
   img_sign = imresize(img_sign, [64,64]);    
   img_sign = imbinarize(img_sign);
   features= extractHOGFeatures(img_sign, 'CellSize', [4 4]);  
   [predictlabel, score,~] = predict(classifier, features);
   [~, index] = min(abs(score));
   scoremin= min(abs(score));
   if (index<5 )%&& scoremin<0.06)
   rectangle('Position', bbox(i,:),'EdgeColor','g','LineWidth',2 )
   labelimg= imread(strcat(char(predictlabel),'.jpg'));
   labelimg= im2single(imresize(labelimg,[bbox(i,4) bbox(i,3)]));
   image([int64(bbox(i,1)-bbox(i,3)) int64(bbox(i,1)-bbox(i,3)) ],[int64(bbox(i,2)) int64(bbox(i,2))],labelimg);
   end
end