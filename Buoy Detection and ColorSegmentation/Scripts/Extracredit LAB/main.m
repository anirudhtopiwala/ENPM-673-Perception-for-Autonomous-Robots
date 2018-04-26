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
rb=fitgmdist(redbuoy,3,'Options',options,'CovarianceType','full');
gb=fitgmdist(greenbuoy,3,'Options',options,'CovarianceType','full');
yb=fitgmdist(yellowbuoy,3,'Options',options,'CovarianceType','full');

% Get GM models using User Function
% rb=fitdata(redbuoy,3,50);
% gb=fitdata(greenbuoy,3,50);
% yb=fitdata(yellowbuoy,3,50);

rmix=rb.ComponentProportion;
gmix=gb.ComponentProportion;
ymix=yb.ComponentProportion;
rbmean=rb.mu;gbmean=gb.mu;ybmean=yb.mu;
rbsigma=rb.Sigma;gbsigma=gb.Sigma;ybsigma=yb.Sigma;
store=zeros(200,3);

% Loop to read all images in Test Set
for k=1:200
     pause(0.1)
    % Image Reading and Pre-Processing
     img= imread(sprintf('%s%03d.jpg',trainset,k));
%     img = histeq(img);
%    img=imgaussfilt(img,2);
     Irblur=imgaussfilt(img,1);
     Igblur=imgaussfilt(img,2);
     Iyblur=imgaussfilt(img,1);
%    img=rgb2gray(img);
    
    % Extracting RGB Color Planes for all 3 buoys
    Rr= double(Irblur(:,:,1));Rg= double(Irblur(:,:,2));Rb= double(Irblur(:,:,3));
    Gr= double(Igblur(:,:,1));Gg= double(Igblur(:,:,2));Gb= double(Igblur(:,:,3));
    Yr= double(Iyblur(:,:,1));Yg= double(Iyblur(:,:,2));Yb= double(Iyblur(:,:,3));
    

    %Generating 2D Probability Map
    count=1;
    for i=1:size(img,1)
        for j=1:size(img,2)
            x=[Rr(i,j) Rg(i,j) Rb(i,j)]';
            y=[Gr(i,j) Gg(i,j) Gb(i,j)]';
            z=[Yr(i,j) Yg(i,j) Yb(i,j)]';
            X=0;Y=0;Z=0;
            for l=1:3
                mu_x=rbmean(l,:)';
                sigma_x=rbsigma(:,:,l)';
                p_x=exp(-0.5*((double(x)-mu_x)'/sigma_x)*(double(x)-mu_x))/(((2*pi)^3/2)*sqrt(det(sigma_x)));
                X =X +rmix(l)*p_x;
               

                mu_y=gbmean(l,:)';
                sigma_y=gbsigma(:,:,l)';
                p_y=exp(-0.5*((double(y)-mu_y)'/sigma_y)*(double(y)-mu_y))/(((2*pi)^3/2)*sqrt(det(sigma_y)));
                Y =Y +gmix(l)*p_y;

                mu_z=ybmean(l,:)';
                sigma_z=ybsigma(:,:,l)';
                p_z=exp(-0.5*((double(z)-mu_z)'/sigma_z)*(double(z)-mu_z))/(((2*pi)^3/2)*sqrt(det(sigma_z)));
                Z =Z +ymix(l)*p_z;

            end
        probR(i,j)=X; probG(i,j)=Y ;probY(i,j)=Z;
        end
     
    end
   
 Xplot= [1:1:count-1];
%  plot((Rplotintensity),(Rplot),'*');
%  plot(Gplotintensity,Gplot,'*');
%  plot(Yplotintensity,Yplot,'*');
 
%     store(k,:)=[ probR probG probY];
    
    
    % Getting Red Green and Yellow Buoy Regions depending Upon the Threshold
     %Yellow Buoy
%         figure
        yellow= probY> 3.5*std2(probY);
%         imshow(yellow);

     %Red Buoy
%         figure
        red= probR> 3*std2(probR);
%         imshow(red);
    % Green Buoy
%         figure
        green= probG> 11*std2(probG);
%         imshow(green);

    imwrite(red,sprintf('%sR_%03d.jpg',part0seg,k),'jpg');
    imwrite(yellow,sprintf('%sY_%03d.jpg',part0seg,k),'jpg');
    imwrite(green,sprintf('%sG_%03d.jpg',part0seg,k),'jpg');
    
    imwrite(probR,sprintf('%smainR_%03d.jpg',part0seg,k),'jpg');
    imwrite(probY,sprintf('%smainY_%03d.jpg',part0seg,k),'jpg');
    imwrite(probG,sprintf('%smainG_%03d.jpg',part0seg,k),'jpg');
    
end

% imshow(img);
% hold on

%% Red and Yellow Buoy
   
% % % % %  
% % % % %         BW2 = bwmorph(red,'close',10);
% % % % %         BW2 = bwmorph(BW2,'fill');
% % % % %         BW2=imfill(BW2,'holes');
% % % % %         BW2 = bwareafilt(BW2,[450,5500]);
% % % % % %         imshow(yellow);
% % % % % 
% % % % % 
% % % % %      stats = regionprops('table',BW2,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
% % % % %      centers= stats.Centroid;
% % % % %      diffr=abs(stats.MajorAxisLength- stats.MinorAxisLength);
% % % % %      if(k<50)
% % % % %      index=diffr<8;
% % % % %      else
% % % % %         index=diffr<5;
% % % % %      end
% % % % %      plotcenters=centers(index,:);
% % % % %      plotmajor=stats.MajorAxisLength(index);
% % % % %      plotminor=stats.MajorAxisLength(index);
% % % % %      r1=(plotmajor(1)+plotminor(1))/4;
% % % % %          
% % % % %      
% % % % %    viscircles([plotcenters(1,1),plotcenters(1,2)],r1,'EdgeColor','y','LineWidth',2);
% % % % %    try
% % % % %    if(~(abs(plotcenters(2,1)-size(img,2))<5) )
% % % % %    r2=(plotmajor(2)+plotminor(2))/4;
% % % % %    viscircles([plotcenters(2,1),plotcenters(2,2)], r2,'EdgeColor','r','LineWidth',2);
% % % % %    end
% % % % %    catch
% % % % %        continue
% % % % %    
% % % % %    end 
% % % % % 
% % % % % 
% % % % %  %% For Green Buoy
% % % % %   try
% % % % %         BWg = bwmorph(green,'close');
% % % % %         BWg = bwmorph(BWg,'fill');
% % % % %         BWg=imfill(BWg,'holes');
% % % % %         BWg = bwareafilt(BWg,[400 650]);
% % % % %         
% % % % %      statsg = regionprops('table',BWg,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
% % % % %      centersg= statsg.Centroid;
% % % % %      diffg=abs(statsg.MajorAxisLength- statsg.MinorAxisLength);
% % % % %      index=diffg<8;
% % % % %      cg=centersg(index,:);
% % % % %      major=stats.MajorAxisLength(index);
% % % % %      minor=stats.MajorAxisLength(index);
% % % % %      r1=(major(1)+minor(1))/4;
% % % % %      viscircles([cg(1,1),cg(1,2)],r1,'EdgeColor','g','LineWidth',2);
% % % % %   catch
% % % % %       continue
% % % % %   end
% % % % % 
% % % % % 
% % % % % 
% % % % %      saveas(gcf,sprintf('%sseg_%03d.jpg',part0seg,k));
% % % % % 
% % % % % 
% % % % %     
% % % % % 
% % % % %    
% % % % % 
% % % % %     
% % % % %    
% % % % % 
% % % % % 
% % % % %     
% % % % % end
