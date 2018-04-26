%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Extra Credit LAB
clc;clear all;close all;

%Directory Initialization
trainset='../../Images/TestSet/Frames/';
part0seg='../../Output/Extracredit/';

% Loading RGB values of Red Green and yellow Buoy
load ColorSamples.mat

%% Using Estimate Function to calculate mean and variance of Red color for Red Buoy; Green Color for Green Buoy and Red+Green color for yellow Buoy
[rmean,sigma_r]=estimate(redbuoy(:,1));
[gmean,sigma_g]=estimate(greenbuoy(:,2));
[ymean,sigma_y]=estimate((yellowbuoy(:,1)+yellowbuoy(:,2))/2);

%% Plotting the 1D gaussian for the main color for each buoy (Eg: Red color for red buoy)
% Red Color  
% plotgauss(redbuoy(:,1),'r');

% Green Color  
% plotgauss(greenbuoy(:,2),'g');

% Yellow Color  
% plotgauss((yellowbuoy(:,1)+yellowbuoy(:,2))/2,'y');

%% Loop to read all images in Test Set
for k=1:200
    
     pause(0.1)
    % Image Reading and Pre-Processing
     img1= imread(sprintf('%s%03d.jpg',trainset,k));
%     img = histeq(img); 
     img=imgaussfilt(img1,2);
     img=rgb2lab(img);
%     img=rgb2gray(img);
    
    % Extracting RGB Color Planes
    R= double(img(:,:,1));
    G= double(img(:,:,2));
    B= double(img(:,:,3));
    
    %Generating 2D Probability Map
    for i=1:size(img,1)
        for j=1:size(img,2)
            r=R(i,j);g=G(i,j);y=(r+g)/2;
            probR(i,j)= (1/sqrt(2*pi*sigma_r^2))*exp(-((r-rmean)^2)/(2*sigma_r));
            probG(i,j)= (1/sqrt(2*pi*sigma_g^2))*exp(-((g-gmean)^2)/(2*sigma_g));
            probY(i,j)= (1/sqrt(2*pi*sigma_y^2))*exp(-((y-ymean)^2)/(2*sigma_y));
        end
    end


    
%% Getting Red Green and Yellow Buoy Regions depending Upon the Threshold
     %Yellow Buoy
        yellow= probY> 2.7*std2(probY);

     %Red Buoy
        red= probR> 2.2*std2(probR);

    % Green Buoy
        green= probG> 2.6*std2(probG);

imshow(img1);
% hold on

%% Red and Yellow Buoy
try
       % Morphological Operations
        BW2 = bwmorph(red,'close',10);
        BW2 = bwmorph(BW2,'fill');
        BW2=imfill(BW2,'holes');
        BW2 = bwareafilt(BW2,[275,5500]);
%         imshow(BW2);

     % Extracting Centeroids 
     stats = regionprops('table',BW2,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
     centers= stats.Centroid;
     diffr=abs(stats.MajorAxisLength- stats.MinorAxisLength);
     if(k<50)
     index=diffr<8;
     else
        index=diffr<5;
     end
     plotcenters=centers(index,:);
     plotmajor=stats.MajorAxisLength(index);
     plotminor=stats.MajorAxisLength(index);
     r1=(plotmajor(1)+plotminor(1))/4;
         
   %Plotting Circles 
   viscircles([plotcenters(1,1),plotcenters(1,2)],r1,'EdgeColor','y','LineWidth',2);
   try
   if(~(abs(plotcenters(2,1)-size(img,2))<5) )
   r2=(plotmajor(2)+plotminor(2))/4;
   viscircles([plotcenters(2,1),plotcenters(2,2)], r2,'EdgeColor','r','LineWidth',2);
   end



 %% For Green Buoy
  
   if(k<43)
        % Morphological Operations
        BWg= bwmorph(green,'thicken',4);
        BWg = bwmorph(BWg,'close');
        BWg = bwmorph(BWg,'fill');
        BWg1=imfill(BWg,'holes');
        BWg = bwareafilt(BWg1,[400 1200]);
%         imshow(BWg)
     % Extracting Centroids 
     statsg = regionprops('table',BWg,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
     centersg= statsg.Centroid;
     diffg=abs(statsg.MajorAxisLength- statsg.MinorAxisLength);
     index=diffg<10;
     cg=centersg(index,:);
     major=stats.MajorAxisLength(index);
     minor=stats.MajorAxisLength(index);
     r1=(major(1)+minor(1))/4;
     %Plotting Circles
     viscircles([cg(1,1),cg(1,2)],r1,'EdgeColor','g','LineWidth',2);
   end
  catch
      continue
  end

   %% Saving Figure
%  saveas(gcf,sprintf('%sseg_%03d.jpg',part0seg,k));
  
end
end


 

