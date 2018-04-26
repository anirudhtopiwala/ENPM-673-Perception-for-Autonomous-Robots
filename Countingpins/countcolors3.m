function [reds, greens, blues,yellows,whites, transparents] = countcolors3(img)

% This function is similar to countcolors, but the differenc here is I have
% used edge detection to detect the pins and in doing so I am aslo able to
% detect the white and the transparent pins. I have used 

BW1 = edge(rgb2gray(img),'Sobel'); %using sobel approximation
se = strel('line',11,90);
BW2 = imdilate(BW1,se); % to dilate the edges and get a hole like figure
BW3 = bwareaopen(BW2, 171); % to remove small holes or noise
BW4 = imfill(BW3,'holes'); % to fill the holes if there are empty spaces by any chance

%% Calculating boundaries, similar to countcolors function
B = bwboundaries(BW4); % Calculating boundaries, similar to countcolors function
figure
imshow(img);
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 1)
    
end
hold off
numpin=k;
%% Calculating the centroids
s = regionprops(BW4,'centroid');
c = cat(1, s.Centroid);
figure
imshow(img)
hold on
plot(c(:,1),c(:,2), 'b*')
hold off

%% counting colors; similar to countcolors ; similar to countcolors

h = findobj(gcf,'type','image');
xdata = get(h, 'XData');
ydata = get(h, 'YData');
M = size(get(h,'CData'), 1);
N = size(get(h,'CData'), 2);


reds=0;greens=0;blues=0;yellows=0; whites=0; transparents=0;% Count for each color
for i=1:1:numpin
p = impixel(xdata,ydata,img,c(:,1),c(:,2)); % find the picel value at each centroid point

if(p(i,1)>100 && p(i,2)<100)
    color='red';
    reds=reds+1;
elseif(p(i,2)>60 && p(i,1)<30&& p(i,3)<100)
    color='green';
    greens=greens+1;
elseif(p(i,3)>100&&p(i,1)<70)
    color='blue';
    blues=blues+1;
elseif(p(i,3)<100&& (abs(p(i,1)-p(i,2))<50))
    color= 'yellow';
    yellows=yellows+1;
elseif((abs(p(i,1)-p(i,2)))<10 && abs(p(i,2)-p(i,3))>5 && abs(p(i,1)-p(i,3))<50)
    color= 'white';
    whites= whites+1;
elseif ( (abs(p(i,1)-p(i,2)))<5 && abs(p(i,2)-p(i,3))<5 && abs(p(i,1)-p(i,3))<5)
    color = 'transparent';
    transparents = transparents+1;
end
end
h = msgbox(sprintf('Reds= %d, Greens= %d,Blues= %d, Yellows= %d Whites = %d Transparents= %d', reds, greens, blues, yellows, whites,transparents ));
end