%% Extra Code
    %%  Clearing Borders and FILLing holes
blurimg=imfill(img,'holes');
blurimg= imclearborder(blurimg);
level=0.117;

bimg = imbinarize(blurimg, level); 
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


%% Stuff






    %Split into RGB Channels
    Red = image(:,:,1);
    Green = image(:,:,2);
    Blue = image(:,:,3);

    %Get histValues for each channel
    [yRed, x] = imhist(Red);
    [yGreen, x] = imhist(Green);
    [yBlue, x] = imhist(Blue);

    %Plot them together in one plot
    plot(x, yRed, 'Red', x, yGreen, 'Green', x, yBlue, 'Blue');


%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
clc;clear all;close all;

% Setting Up Directories
croppedimages='../../Images/TrainingSet/CroppedBuoys/';
trainset='../../Images/TrainingSet/Frames/';
storehist= '../../Output/Part0/';

% Initializing Arrays
Rr=[];Gr=[];Br=[];
Rg=[];Gg=[];Bg=[];
Ry=[];Gy=[];By=[];

% Loop to read all images in Training Set
for i=1:42
   
    img= imread(sprintf('%s%03d.jpg',trainset,i));
    
    R= img(:,:,1);
    G=img(:,:,2);
    B=img(:,:,3);
    
    %% For Red Buoy
    
    % Get Region of Red buoy 
    r_buoy= imread(sprintf('%sR_%03d.jpg',croppedimages,i));
    % Find where value is not zero or where actual buoy is present
    r_region= find(r_buoy);
    % Get values of RGB in that region of buoy
    Rr(:,i)= R(r_region);
    Gr(:,i)= G(r_region);
    Br(:,i)= B(r_region);
      
%     Rr= R(r_region);
%     Gr=G(r_region);
%     Br=B(r_region);  

    
    %% For Green Buoy
    
    % Get Region of Green buoy 
    g_buoy= imread(sprintf('%sG_%03d.jpg',croppedimages,i));
    % Find where value is not zero or where actual buoy is present
    g_region= find(g_buoy);
    % Get values of RGB in that region of buoy
    Rg= [Rg;R(g_region)];
    Gg=[Gg;G(g_region)];
    Bg=[Bg;B(g_region)];
    
    %% For Yellow Buoy
    
    % Get Region of Yellow buoy 
    y_buoy= imread(sprintf('%sY_%03d.jpg',croppedimages,i));
    % Find where value is not zero or where actual buoy is present
    y_region= find(y_buoy);
    % Get values of RGB in that region of buoy
    Ry= [Ry;R(y_region)];
    Gy=[Gy;G(y_region)];
    By=[By;B(y_region)];
    
    
    
end
    
    %% Plotting all points to form colored Histogram
    hold on
    s=10;cr=[1 0 0];cg=[0 1 0];cy=[1 1 0];
    cr=[0 0 1];cg= [ 0 0 1];cy=[0 0 1];
    
    % For Red Buoy
    figure
    scatter3(Rr,Gr,Br,s,cr,'.');    
    title('Color Distribubtion for Red Buoy');
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');
    saveas(gcf,sprintf('%sR1_hist.jpg',storehist));
    
    % For Green Buoy
    figure
    scatter3(Rg,Gg,Bg,s,cg,'.');  
    title('Color Distribubtion for Green Buoy');
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');
    saveas(gcf,sprintf('%sG1_hist.jpg',storehist));     
    
    % For Yellow Buoy
    figure
    scatter3(Ry,Gy,By,s,cy,'.');  
    title('Color Distribubtion for Yellow Buoy');
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');
    saveas(gcf,sprintf('%sY1_hist.jpg',storehist));

    
    
    
    
    
