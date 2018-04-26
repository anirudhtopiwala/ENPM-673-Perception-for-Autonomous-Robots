function [reds, greens, blues,yellows] = countcolors(img,imgfused)
o=0; % This is irrelevant to the current code; it is a constant carried from countcolor2 function
% In this function I will count the number of pins of identical color. The
% white and the transparent pins are not considere here. For that check
% method countcolors3

% Inputs: img= original Image ; imgfused: binary image on which count is to
% be performed
%Outputs: 
%%  Getting the binary image and total number of pins from function gettotalpins
[bimg, numpin]= gettotalpins(img, imgfused,o);

%% Calculating the centroids of each pin and plotting
s = regionprops(bimg,'centroid');
c = cat(1, s.Centroid);
figure
imshow(img)
hold on
plot(c(:,1),c(:,2), 'b*')
hold off

%% Counting  colored Objects
h = findobj(gcf,'type','image');
xdata = get(h, 'XData');
ydata = get(h, 'YData');
M = size(get(h,'CData'), 1);
N = size(get(h,'CData'), 2);


reds=0;greens=0;blues=0;yellows=0; % Count for each color
for i=1:1:numpin
 
% p = img(round(c(i,1)),round(c(i,2)),:);
p = impixel(xdata,ydata,img,c(:,1),c(:,2));


if(p(i,1)>100 && p(i,2)<100)
    color='red';
    reds=reds+1;
elseif(p(i,2)>70 && p(i,1)<30&& p(i,3)<100)
    color='green';
    greens=greens+1;
elseif(p(i,3)>100&&p(i,1)<70)
    color='blue';
    blues=blues+1;
elseif(p(i,3)<100&& (abs(p(i,1)-p(i,2))<50))
    color= 'yellow';
    yellows=yellows+1;
end
end
h = msgbox(sprintf('Reds= %d, Greens= %d,Blues= %d, Yellows= %d', reds, greens, blues, yellows));

end

