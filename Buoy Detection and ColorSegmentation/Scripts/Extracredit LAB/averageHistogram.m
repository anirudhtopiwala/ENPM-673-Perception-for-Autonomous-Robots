%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% LAB
clc;clear all;
% close all;
tic
% Setting Up Directories
croppedimages='../../Images/TrainingSet/CroppedBuoys/';
trainset='../../Images/TrainingSet/Frames/';
storehist= '../../Output/Part0/';

% Initializing Arrays to store all intensities value. 

% (Notation: Capital R,G and Y indicates buoy;
%            Small r,g and b indicate color frames
%            i indicates intensity (these variables are used to store hist values.)

Rr=[];Gr=[];Br=[];
Rg=[];Gg=[];Bg=[];
Ry=[];Gy=[];By=[];

Rri=[];Gri=[];Yri=[];
Rgi=[];Ggi=[];Ygi=[];
Rbi=[];Gbi=[];Ybi=[];


% Loop to read all images in Training Set
for i=1:42
   
    img= imread(sprintf('%s%03d.jpg',trainset,i));
    % Image Pre-Processing
%     img = histeq(img);
    img=imgaussfilt(img,2);
    img=rgb2lab(img);
    % Extracting RGB Color Planes
    R= double(img(:,:,2));
    G= double(img(:,:,2));
%     B= double(img(:,:,3));
    B= double(img(:,:,3));
     
    %% For Red Buoy
    
    % Get Region of Red buoy 
    r_buoy= imread(sprintf('%sR_%03d.jpg',croppedimages,i));
    % Find where value is not zero or where actual buoy is present
    r_region= find(r_buoy);
    % Get values of RGB in that region of buoy
    Rr= [Rr;R(r_region)];
    Gr=[Gr;G(r_region)];
    Br=[Br;B(r_region)];
    
    % Getting hist values
    [Rrio, Rgio, Rbio,x]=gethistdata(R(r_region),G(r_region),B(r_region));
    % Accumulating Hist values for all 42 Frames
    Rri=[Rri,Rrio];
    Rgi=[Rgi,Rgio];
    Rbi=[Rbi,Rbio];

    %% For Green Buoy
    
    % Get Region of Green buoy 
    g_buoy= imread(sprintf('%sG_%03d.jpg',croppedimages,i));
    % Find where value is not zero or where actual buoy is present
    g_region= find(g_buoy);
    % Get values of RGB in that region of buoy
    Rg= [Rg;R(g_region)];
    Gg=[Gg;G(g_region)];
    Bg=[Bg;B(g_region)];
    
    % Getting hist values
    [Grio, Ggio, Gbio,x]=gethistdata(R(g_region),G(g_region),B(g_region));
    % Accumulating Hist values for all 42 Frames
    Gri=[Gri,Grio];
    Ggi=[Ggi,Ggio];
    Gbi=[Gbi,Gbio];
    
    %% For Yellow Buoy
    
    % Get Region of Yellow buoy 
    y_buoy= imread(sprintf('%sY_%03d.jpg',croppedimages,i));
    % Find where value is not zero or where actual buoy is present
    y_region= find(y_buoy);
    % Get values of RGB in that region of buoy
    Ry= [Ry;R(y_region)];
    Gy=[Gy;G(y_region)];
    By=[By;B(y_region)];
    
    % Getting hist values
    [Yrio, Ygio, Ybio,x]=gethistdata(R(y_region),G(y_region),B(y_region));
    % Accumulating Hist values for all 42 Frames
    Yri=[Yri,Yrio];
    Ygi=[Ygi,Ygio];
    Ybi=[Ybi,Ybio];
    
    
end
%% Forming Mean Colored Histogram

     %For Red Buoy
     %Get histValues for each channel for all 42 images and then taking mean
     figure
     title('Averge Colored Histogram for Red Buoy');
     hold on
     Rrimean=mean(Rri,2);
     Rgimean=mean(Rgi,2);
     Rbimean=mean(Rbi,2);
     %Plotting Values
     area(x, Rrimean, 'FaceColor','r');
     area(x, Rgimean, 'FaceColor','g');
     area(x, Rbimean, 'FaceColor','b');
     hold off
     saveas(gcf,sprintf('%sR_hist.jpg',storehist));
     
     %For Green Buoy
     %Get histValues for each channel for all 42 images and then taking mean
     figure
     title('Averge Colored Histogram for Green Buoy');
     hold on
     Grimean=mean(Gri,2);
     Ggimean=mean(Ggi,2);
     Gbimean=mean(Gbi,2);
     %Plotting Values
     area(x, Grimean, 'FaceColor','r');
     area(x, Ggimean, 'FaceColor','g');
     area(x, Gbimean, 'FaceColor','b');
     hold off
     saveas(gcf,sprintf('%sG_hist.jpg',storehist));
        
     
     %For Yellow Buoy
     %Get histValues for each channel for all 42 images and then taking mean
     figure
     title('Averge Colored Histogram for Yellow Buoy');
     hold on
     Yrimean=mean(Yri,2);
     Ygimean=mean(Ygi,2);
     Ybimean=mean(Ybi,2);
     %Plotting Values
     area(x, Yrimean, 'FaceColor','r');
     area(x, Ygimean, 'FaceColor','g');
     area(x, Ybimean, 'FaceColor','b');
     hold off
     saveas(gcf,sprintf('%sY_hist.jpg',storehist));


%% Plotting all points to form Scatter Plot
    s=10;cr=[1 0 0];cg=[0 1 0];cy=[1 1 0];
    cr=[0 0 1];cg= [ 0 0 1];cy=[0 0 1];
    
    % For Red Buoy
    figure
    scatter3(Rr,Gr,Br,s,cr,'.');    
    title('Color Distribubtion for Red Buoy');
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');
    saveas(gcf,sprintf('%sR_scatter.jpg',storehist));
    
    % For Green Buoy
    figure    

    scatter3(Rg,Gg,Bg,s,cg,'.');  
    title('Color Distribubtion for Green Buoy');
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');
    saveas(gcf,sprintf('%sG_scatter.jpg',storehist));     
    
    % For Yellow Buoy
    figure
    scatter3(Ry,Gy,By,s,cy,'.');  
    title('Color Distribubtion for Yellow Buoy');
    xlabel('Red');
    ylabel('Green');
    zlabel('Blue');
    saveas(gcf,sprintf('%sY_scatter.jpg',storehist));
    
    %Saving Buoy Intensity Data
    redbuoy=[Rr Gr Br ]; greenbuoy=[Rg Gg Bg] ; yellowbuoy=[Ry Gy By]; 

    save('ColorSamples.mat','redbuoy','greenbuoy','yellowbuoy');
  toc




    
    
    
    
    
