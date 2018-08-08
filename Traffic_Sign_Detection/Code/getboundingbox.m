%% Project 4- Anirudh Topiwala
%% Traffic Sign Detection
function [bbox] = getboundingbox(img,numblobs,blob_minarea,min_aspect_ratio,max_aspect_ratio)
% Once the Features are detected, using some constraints bounding boxes are
% made over the signs
%% Getting Bounding Boxes using Region Props for Blue
region = regionprops(logical(img), 'Area', 'BoundingBox','centroid');
areas = [region.Area];
bbox = [];
if (isempty(areas))
   return;
end
[~,ind] = sort(areas, 'descend'); 
for j = 1:min(size(areas,2), numblobs)
   center= region(ind(j)).Centroid;
   if (areas(ind(j)) < blob_minarea)
       continue;
   end
   if (areas(ind(j)) < 1500 && center(2)>size(img,2)*0.23)
        continue
   end
curr_bbox = region(ind(j)).BoundingBox;
%% Filter by aspect ratio
    if (curr_bbox(4)<20 ||curr_bbox(3) / curr_bbox(4) > max_aspect_ratio || curr_bbox(3) / curr_bbox(4) < min_aspect_ratio)
        continue;
    else
        bbox = [bbox;curr_bbox];
    end
end

end
