%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Part 3- Buoy Detection
clc;clear all;close all;

%Directory Initialization
trainset='../../Images/TestSet/Frames/';
part0seg='../../Output/Part3/ColorSegmentation/';

% Loading RGB values of Red Green and yellow Buoy
load ColorSamples.mat

% Using Estimate Function to calculate mean and variance of Red color for Red Buoy; Green Color for Green Buoy and Red+Green color for yellow Buoy
% [rmean,sigma_r]=estimate(redbuoy(:,1));
% [gmean,sigma_g]=estimate(greenbuoy(:,2));
% [ymean,sigma_y]=estimate((yellowbuoy(:,1)+yellowbuoy(:,2))/2);

options = statset('MaxIter',300);
% Get GM models using Matlab Function
ngauss=4;
rb=fitgmdist(redbuoy(:,1),ngauss,'Options',options,'CovarianceType','full');
gb=fitgmdist(greenbuoy(:,2),ngauss,'Options',options,'CovarianceType','full');
yb=fitgmdist((yellowbuoy(:,1)+yellowbuoy(:,2))/2,ngauss,'Options',options,'CovarianceType','full');

% Get GM models using User Function
% rb=fitdata(redbuoy(:,1),3,50);
% gb=fitdata(greenbuoy(:,2),3,50);
% yb=fitdata((yellowbuoy(:,1)+yellowbuoy(:,2))/2,3,50);

% Get Means, Variance and Pi(Mixture Composition)
rmix=rb.ComponentProportion;
gmix=gb.ComponentProportion;
ymix=yb.ComponentProportion;
rbmean=rb.mu;gbmean=gb.mu;ybmean=yb.mu;
rbsigma=rb.Sigma;gbsigma=gb.Sigma;ybsigma=yb.Sigma;
store=zeros(200,3);
% figure('units','normalized','outerposition',[0 0 1 1])

% Loop to read all images in Test Set
for k=10:200
     pause(0.01)
    % Image Reading and Pre-Processing
     img= imread(sprintf('%s%03d.jpg',trainset,k));
%     img = histeq(img);
%    img=imgaussfilt(img,6);
     Irblur=imgaussfilt(img,1);
     Igblur=imgaussfilt(img,1);
     Iyblur=imgaussfilt(img,1);
%    img=rgb2gray(img);
    
    % Extracting RGB Color Planes for all 3 buoys
    Rr= double(Irblur(:,:,1));Rg= double(Irblur(:,:,2));Rb= double(Irblur(:,:,3));
    Gr= double(Igblur(:,:,1));Gg= double(Igblur(:,:,2));Gb= double(Igblur(:,:,3));
    Yr= double(Iyblur(:,:,1));Yg= double(Iyblur(:,:,2));Yb= double(Iyblur(:,:,3));
%     
%     Rr= img(:,:,1);Rg= img(:,:,2);Rb= img(:,:,3);
%     Gr= img(:,:,1);Gg= img(:,:,2);= img(:,:,3);
%     R= img(:,:,1);G= img(:,:,2);B= img(:,:,3);
      
    % Converting image matrix into a row matrix
%     xr= [Rr(Rr>-1) Rg(Rg>-1) Rb(Rb>-1)];
%     xg= [Gr(Gr>-1) Gg(Gg>-1) Gb(Gb>-1)];
%     xy= [Yr(Yr>-1) Yg(Yg>-1) Yb(Yb>-1)];
        xr= Rr(Rr>-1);
        xg= Gg(Gg>-1);
        xy= (Yr(Yr>-1) +Yg(Yg>-1))/2;

    %Generating 2D Probability Map
%     for i=1:size(img,1)
%         for j=1:size(img,2)
%             x=[Rr(i,j) Rg(i,j) Rb(i,j)]';
%             y=[Gr(i,j) Gg(i,j) Gb(i,j)]';
%             z=[Yr(i,j) Yg(i,j) Yb(i,j)]';
%             X=0;Y=0;Z=0;
            probR=0;probG=0;probY=0;
            for l=1:ngauss
                  mu_x=rbmean(l,:);
                  sigma_x=rbsigma(:,:,l);
%                 p_x=exp(-0.5*((double(x)-mu_x)'/sigma_x)*(double(x)-mu_x))/(((2*pi)^3/2)*sqrt(det(sigma_x)));
%                 X =X +rmix(l)*p_x;
                  probR= probR+ normpdf(double(xr),mu_x,sigma_x);
               
                  mu_y=gbmean(l,:);
                  sigma_y=gbsigma(:,:,l);
%                 p_y=exp(-0.5*((double(y)-mu_y)'/sigma_y)*(double(y)-mu_y))/(((2*pi)^3/2)*sqrt(det(sigma_y)));
%                 Y =Y +gmix(l)*p_y;
                  probG= probG+ normpdf(double(xg),mu_y,sigma_y);
                  
                  mu_z=ybmean(l,:);
                  sigma_z=ybsigma(:,:,l);
%                  p_z=exp(-0.5*((double(z)-mu_z)'/sigma_z)*(double(z)-mu_z))/(((2*pi)^3/2)*sqrt(det(sigma_z)));
%                  Z =Z +ymix(l)*p_z;
                  probY = probY +  normpdf(double(xy),mu_z,sigma_z);
            end
            
            % Reshaping the PDF Generated
            probR= reshape (probR,[size(img,1) size(img,2)]);
            probG= reshape (probG,[size(img,1) size(img,2)]);
            probY= reshape (probY,[size(img,1) size(img,2)]);

%         probR(i,j)=X; probG(i,j)=Y ;probY(i,j)=Z;
%         end
     
%     end
   
    
    
    %% Getting Red Green and Yellow Buoy Regions depending Upon the Threshold
     %Red Buoy
%         figure
%         subplot(2,2,1)
        red= probR> 1.5*std2(probR);
%         imshow(red);
%         title('red');
        
    % Green Buoy
%         figure
%         subplot(2,2,2) % Image frame
        green= probG> 10*std2(probG);
%         imshow(green);
%         title('green');
        
        %Yellow Buoy
%         figure
%         subplot(2,2,3) % Image frame
        yellow= probY> 1.7*std2(probY);
%         imshow(yellow);
%         title('yellow');

 
    %% Saing Binary Images
%     imwrite(red,sprintf('%sR_%03d.jpg',part0seg,k),'jpg');
%     imwrite(yellow,sprintf('%sY_%03d.jpg',part0seg,k),'jpg');
%     imwrite(green,sprintf('%sG_%03d.jpg',part0seg,k),'jpg');
%     
%     imwrite(probR,sprintf('%smainR_%03d.jpg',part0seg,k),'jpg');
%     imwrite(probY,sprintf('%smainY_%03d.jpg',part0seg,k),'jpg');
%     imwrite(probG,sprintf('%smainG_%03d.jpg',part0seg,k),'jpg');

%      saveas(gcf,sprintf('%sbinary_%03d.jpg',part0seg,k));
   %% Plotting Circles
     imshow(img);
     hold on
    % Red and Yellow Buoy
    try
        BW2=  bwmorph(yellow,'thicken',3);
        BW2 = bwmorph(BW2,'close',10);
        BW2 = bwmorph(BW2,'fill');
        BW2=imfill(BW2,'holes');
        BW2 = bwareafilt(BW2,[125,1000]);
%       imshow(BW2);

     stats = regionprops('table',BW2,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
     centers= stats.Centroid;
     diffr=abs(stats.MajorAxisLength- stats.MinorAxisLength);
     % Selecting on basis of difference in major and minor axis length
     if(~isempty(centers))
     if(k<5)
     index=diffr<11;
     else
        index=diffr<15;
     end
     else
         index=[ 1 1]';
     end
     plotcenters=centers(index,:);
     plotmajor=stats.MajorAxisLength(index);
     plotminor=stats.MajorAxisLength(index);
     yx=plotcenters(1,1);yy=plotcenters(1,2);
     for i=2:size(plotcenters,1)
         if(abs(yy- plotcenters(i,2))<20)
             ry=plotcenters(i,2);
             rx=plotcenters(i,1);
             break
         end         
     end

     r1=(plotmajor(1)+plotminor(1))/4;
        % Plotting Cirlces
       viscircles([plotcenters(1,1),plotcenters(1,2)],r1,'EdgeColor','y','LineWidth',2);
       
       if(~(abs(plotcenters(2,1)-size(img,2))<5) )
       r2=(plotmajor(2)+plotminor(2))/4;
       viscircles([rx ry], r1,'EdgeColor','r','LineWidth',2);
       end
       catch
           continue
       end 

 %% For Green Buoy
  try
      if(k<43)
        % Morphological Operations.
        BWg = bwmorph(green,'thicken',8);
        BWg = bwmorph(BWg,'close');
        BWg = bwmorph(BWg,'fill');
        BWg=imfill(BWg,'holes');
        BWg = bwareafilt(BWg,[150 800]);
%         imshow(BWg)
     statsg = regionprops('table',BWg,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
     centersg= statsg.Centroid;
     diffg=abs(statsg.MajorAxisLength- statsg.MinorAxisLength);
    % Selecting binary regons based on difference in major and minor axis 
     index=diffg<25;
     cg=centersg(index,:);
     major=stats.MajorAxisLength(index);
     minor=stats.MajorAxisLength(index);
     for i=2: size(cg,1)
         if(abs(cg(i,2)-338)<20)
             gy=cg(i,2);gx=(cg(i,1));
             break
         end
     end
%      r1=(major(1)+minor(1))/4;
     viscircles([gx gy],r1,'EdgeColor','g','LineWidth',2);
      end
  catch
      continue
  end
    % Saving Figure
%      saveas(gcf,sprintf('%sseg_%03d.jpg',part0seg,k));
    
end
