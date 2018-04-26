%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
clc;clear all;close all;

%Directory Initialization
trainset='../../Images/TestSet/Frames/';
part0seg='../../Output/Part0/';

% Loading RGB values of Red Green and yellow Buoy
load ColorSamples.mat

% Using Estimate Function to calculate mean and variance of Red color for Red Buoy; Green Color for Green Buoy and Red+Green color for yellow Buoy
[rmean,sigma_r]=estimate(redbuoy(:,1));
[gmean,sigma_g]=estimate(greenbuoy(:,2));
[ymean,sigma_y]=estimate((yellowbuoy(:,1)+yellowbuoy(:,2))/2);



% Loop to read all images in Test Set
for k=1:200
     pause(0.1)
    % Image Reading and Pre-Processing
     img= imread(sprintf('%s%03d.jpg',trainset,k));
%     img = histeq(img);
     img=imgaussfilt(img,2);
%     img=rgb2gray(img);
    
    % Extracting RGB Color Planes
    R= double(img(:,:,1));
    G= double(img(:,:,2));
    B= double(img(:,:,3));
    
    %Generating 2D Probability Map
    count=1;
    for i=1:size(img,1)
        for j=1:size(img,2)
            r=R(i,j);g=G(i,j);y=(r+g)/2;
%             probR(i,j)=exp(-0.5*(((r-rmean)/(sigma_r))^2))/(sqrt(2*pi*sigma_r^2));
            probR(i,j)= (1/sqrt(2*pi*sigma_r^2))*exp(-((r-rmean)^2)/(2*sigma_r));
            Rplot(count)=(1/sqrt(2*pi*sigma_r^2))*exp(-((r-rmean)^2)/(2*sigma_r));
            Rplotintensity(count)=r;
            probG(i,j)= (1/sqrt(2*pi*sigma_g^2))*exp(-((g-gmean)^2)/(2*sigma_g));
            Gplot(count)=(1/sqrt(2*pi*sigma_g^2))*exp(-((g-gmean)^2)/(2*sigma_g));
            Gplotintensity(count)=g;
            probY(i,j)= (1/sqrt(2*pi*sigma_y^2))*exp(-((y-ymean)^2)/(2*sigma_y));
            Yplot(count)= (1/sqrt(2*pi*sigma_y^2))*exp(-((y-ymean)^2)/(2*sigma_y));
            Yplotintensity(count)=y;
            count=count+1;
        end
    end
   
 Xplot= [1:1:count-1];
%  plot((Rplotintensity),(Rplot),'*');
%  plot(Gplotintensity,Gplot,'*');
%  plot(Yplotintensity,Yplot,'*');
 
    
    
    
    % Getting Red Green and Yellow Buoy Regions depending Upon the Threshold
     %Yellow Buoy
        yellow= probY> 2.7*std2(probY);

     %Red Buoy
        red= probR> 2.2*std2(probR);

    % Green Buoy
        green= probG> 2.5*std2(probG);

% imshow(img);
hold on

%% Red and Yellow Buoy
        BW1 = bwareafilt(red,[1,300]);
        imshow(yellow);
% % % % % %         BW2 = bwmorph(BW1,'thicken',8);
% % % % % %         BW2 = bwmorph(BW2,'close',10);
% % % % % %         BW2 = bwmorph(BW2,'fill');
% % % % % %         BW2=imfill(BW2,'holes');
% % % % % %      if (k<30)
% % % % % %         BW5 = bwmorph(BW2,'thin',8);
% % % % % %      else
% % % % % %         BW3 = bwareafilt(BW2,[850 6000]);
% % % % % %         BW4 = bwmorph(BW3,'thin',8);
% % % % % %         BW5= bwareafilt(BW4,4);
% % % % % %      end       
% % % % % % %      imshow(BW5);
% % % % % %    
% % % % % %      stats = regionprops('table',BW5,img(:,:,1),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
% % % % % %      centers= stats.Centroid;
% % % % % %      Yx= centers(1,1); Yy=centers(1,2);
% % % % % %      Yr = mean([stats.MajorAxisLength(1), stats.MinorAxisLength(1)])/2;
% % % % % % 
% % % % % % %      i=2; 
% % % % % % %     noplot=1;
% % % % % %      for i=2:size(centers,1)
% % % % % %          if (abs(centers(i,2)- Yy)<50)
% % % % % %              diffx=centers(i,1)-Yx;
% % % % % %              diffy=abs(centers(i,2)- Yy);
% % % % % %              Rx= centers(i,1); Ry=centers(i,2);
% % % % % %              Rr = mean([stats.MajorAxisLength(i), stats.MinorAxisLength(i)])/2;
% % % % % % %              noplot=0;
% % % % % %              break
% % % % % % %          else
% % % % % % %              noplot=1;
% % % % % %          end
% % % % % %      end
% % % % % %    
% % % % % %        
% % % % % %      if(k==1)
% % % % % %          Yxprev=Yx;Yyprev=Yy;Rxprev=Rx;Ryprev=Ry; Yrprev=Yr;
% % % % % %      end
% % % % % %      
% % % % % %    if( abs(Yy-Yyprev)>50)
% % % % % %        Yx=Yxprev; Yy=Yyprev;Yr=Yrprev;
% % % % % %    else
% % % % % %        Yxprev=Yx; Yyprev=Yy;Yrprev=Yr;
% % % % % %    end
% % % % % % %    if(noplot==0)
% % % % % % %    if( abs(Rx-Rxprev)>50 || abs(Ry-Ryprev)>50)
% % % % % % %        Rx=Rxprev; Ry=Ryprev;
% % % % % % %    else
% % % % % % %        Rxprev=Rx; Ryprev=Ry;
% % % % % % %    end   
% % % % % % %    end
% % % % % %      
% % % % % %    viscircles([Yx,Yy], Yr,'EdgeColor','y','LineWidth',1);
% % % % % %    if(~(abs(Rx-size(img,2))<20 ||abs(Ry-size(img,1))<20 ))
% % % % % %    viscircles([Rx,Ry], Rr,'EdgeColor','r','LineWidth',1);
% % % % % %    end
% % % % % % 
% % % % % % 
% % % % % %        
% % % % % %     
% % % % % %  %% For Green Buoy
% % % % % %     if (k<42)
% % % % % %         BW1 = bwareafilt(green ,[1,300]);
% % % % % % %         imshow(BW1);
% % % % % %         BW2 = bwmorph(BW1,'thicken',8);
% % % % % %         BW2 = bwmorph(BW2,'close',10);
% % % % % %         BW2 = bwmorph(BW2,'fill');
% % % % % %         BW2=imfill(BW2,'holes');
% % % % % %         BW3 = bwareafilt(BW2,[850 1500]);
% % % % % %         BW4 = bwmorph(BW3,'thin',8);
% % % % % %         BW5= bwareafilt(BW4,10);
% % % % % % %             imshow(BW5);
% % % % % %          
% % % % % %       statsg = regionprops('table',BW5,img(:,:,3),'Centroid','MajorAxisLength','MinorAxisLength','MeanIntensity','PixelValues','MaxIntensity');
% % % % % %       centersg= statsg.Centroid;
% % % % % %       Yx= centersg(1,1); Yy=centersg(1,2);
% % % % % %       Yr = mean([statsg.MajorAxisLength(1), statsg.MinorAxisLength(1)])/2;
% % % % % %       
% % % % % %           noplot=1;
% % % % % %       if(k==1)
% % % % % %      for i=2:size(centersg,1)
% % % % % %          if (abs(centersg(i,2)- Yy)<50)
% % % % % %              diffx=centersg(i,1)-Yx;
% % % % % %              diffy=abs(centersg(i,2)- Yy);
% % % % % %              Gx= centersg(i,1); Gy=centersg(i,2);
% % % % % %              Gr = mean([statsg.MajorAxisLength(i), statsg.MinorAxisLength(i)])/2;
% % % % % %              noplot=0;
% % % % % %              break
% % % % % %          else
% % % % % %              noplot=1;
% % % % % %          end
% % % % % %      end
% % % % % %           Gxprev=Gx;Gyprev=Gy;Gxprev=Gx;Gyprev=Gy; Grprev=Gr;
% % % % % %       else
% % % % % %               for i=2:size(centersg,1)
% % % % % %                  if (abs(centersg(i,2)- Gy)<50)
% % % % % %                      diffx=centersg(i,1)-Gx;
% % % % % %                      diffy=abs(centersg(i,2)- Yy);
% % % % % %                      Gx= centersg(i,1); Gy=centersg(i,2);
% % % % % %                      Gr = mean([statsg.MajorAxisLength(i), statsg.MinorAxisLength(i)])/2;
% % % % % %                      noplot=0;
% % % % % %                      break
% % % % % %                  end
% % % % % %               end
% % % % % %       end
% % % % % %         
% % % % % %    
% % % % % %    if( abs(Gx-Gxprev)>100 )      
% % % % % %        Gx=Gxprev+diffgx; Gr=Grprev;
% % % % % %    else
% % % % % %        diffgx=abs(Gx-Gxprev); 
% % % % % %        Gxprev=Gx; Grprev=Gr;
% % % % % %    end
% % % % % %    
% % % % % %    if( abs(Gy-Gyprev)>5 )                         
% % % % % %        Gy=Gyprev+diffgy; Gr=Grprev;
% % % % % %    else
% % % % % %        diffgy=abs(Gy-Gyprev); 
% % % % % %        Gyprev=Gy; Grprev=Gr;
% % % % % %        
% % % % % %    end   
% % % % % %    if(~(abs(Gx-size(img,2))<20 ||abs(Gy-size(img,1))<20 ))
% % % % % %    viscircles([Gx,Gy], Gr,'EdgeColor','g','LineWidth',1);
% % % % % %    end
% % % % % % 
% % % % % %     end
% % % % % % 
% % % % % %      saveas(gcf,sprintf('%sseg_%03d.jpg',part0seg,k));


    

   

    
   


    
end
