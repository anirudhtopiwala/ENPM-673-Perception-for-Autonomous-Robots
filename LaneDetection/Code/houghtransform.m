function [imgshapetext, mlprevious,mrprevious,xy_longlprevious,xy_longrprevious,xintersect,yintersect] = houghtransform(img,mlprevious,mrprevious,xy_longlprevious,xy_longrprevious,ii,xintersect,yintersect)
%% Hough Tansform
% Here I detect the lines, find the longest line, and using the points
% generated insert the trapezoid shape. This code also incldues turn
% prediciton.
% imshow(img);
flag=0;
[rows,cols]=size(img);
processimg1= processimg(img);
try
numpeaks=102;
[H,theta,rho] = hough(processimg1,'RhoResolution',1,'ThetaResolution',1);
% imshow(imadjust(clorescale(H)));
peaks = houghpeaks(H,numpeaks,'Threshold',20);
lines = houghlines(processimg1,theta,rho,peaks,'FillGap',54,'MinLength',1);
hold on
max_lenl = 0;max_lenr=0;xrmax=0;yrmax=0;xlmax=0;ylmax=0; 
for k = 1:length(lines)
   xy=[lines(k).point1;lines(k).point2]; 
   m(k)=((lines(k).point1(2)- lines(k).point2(2))/(lines(k).point1(1)- lines(k).point2(1)));
   if(m(k)>0)
    
       lenr = norm(lines(k).point1 - lines(k).point2);
       if ( lenr > max_lenr)
          max_lenr = lenr;
          xy_longr = xy;
      end

   elseif (m(k)<0)

       lenl = norm(lines(k).point1 - lines(k).point2);
       if ( lenl > max_lenl)
          max_lenl = lenl;
          xy_longl = xy;
       end
  end 

end
catch
        xy_longl=xy_longlprevious;
        xy_longr=xy_longrprevious;
end

%% Left Lane
if (exist ('xy_longl'))
    xy_longl=xy_longl;
else
    xy_longl=xy_longlprevious;
end
ml= ((xy_longl(1,2)-xy_longl(2,2))/(xy_longl(1,1)-xy_longl(2,1)));  

for i=1:2
    if (xy_longlprevious==0)
        break;
    end
    for j=1:2
        if(abs((xy_longl(i,j)- xy_longlprevious(i,j)))>200)
            flag=1;
        end
    end
end
     if(flag==1)
        ml=mlprevious;
        xy_longl= xy_longlprevious;
        flag=0;
     elseif(flag==0)
        mlprevious=ml;
        xy_longlprevious=xy_longl;
    end
xl= xy_longl(2,1)+ (rows- xy_longl(2,2))/ml;
yl= rows+ ml*200;

%% Right Lane

if (exist('xy_longr'))
    xy_longr=xy_longr;
else
    xy_longr=xy_longrprevious;
end

mr= ((xy_longr(1,2)-xy_longr(2,2))/(xy_longr(1,1)-xy_longr(2,1)));

for i=1:2
    if (xy_longrprevious==0)
        break;
    end
    for j=1:2
        if(abs((xy_longr(i,j)- xy_longrprevious(i,j)))>200 || abs(mr-mrprevious)>0.25)
            flag=2;
            break;
        end
    end
end
     if(flag==2)
        mr=mrprevious;
        xy_longr= xy_longrprevious;
        flag=0;
     elseif(flag==0)
        mrprevious=mr;
        xy_longrprevious=xy_longr;
    end

mr= ((xy_longr(1,2)-xy_longr(2,2))/(xy_longr(1,1)-xy_longr(2,1)));

xr= xy_longr(1,1)+ (rows- xy_longr(1,2))/mr;
xr2= ((yl-rows)/mr) + xr;
hold on
Xl=[xl xl+200];Yl=[rows, yl];
Xr=[xr,xr2];Yr=[rows,yl];

%Finding Intersection Point
p1 = polyfit(Xl,Yl,1);
p2 = polyfit(Xr,Yr,1);
%calculate intersection
xintersect(ii)= fzero(@(x) polyval(p1-p2,x),3);
yintersect(ii) = polyval(p1,xintersect(ii));

trapezoid=[ xl rows xl+200 yl xr2 yl xr rows];
imgshapef= insertShape(img,'FilledPolygon', trapezoid,'Opacity',0.5,'Color',{'green'});
pos= [501 205]; pos2= [588 196];
mavg(ii)= ((ml+mr)/2);
if (ii<4)
    mean= mavg(ii); 
    xint=xintersect(ii);
else
    mean= (mavg(ii)+mavg(ii-1)+mavg(ii-2))/3;
    xint= (xintersect(ii)+xintersect(ii-1)+xintersect(ii-2))/3;
end
value2=mean;
value3= xint;
pos3=[xint 100];
% 
% if(mean<(-0.04))
%     value='Turning Left';
% elseif(mean>-.04 && mean<-.02)
%         value='Going Straight ';
% elseif (mean>-.02)
%         value='Turning Right';
% end

if(xint<620)
    value='Turning Left';
elseif(xint> 616 && xint<638)
        value='Going Straight ';
elseif (xint>635 )
        value='Turning Right';
end
if(mean>-.0189)
            value='Turning Right';
end
imgshapetext = insertText(imgshapef,pos,value,'AnchorPoint','LeftBottom','FontSize',35);
% imgshapetext = insertText(imgshapetext,pos2,value2,'AnchorPoint','LeftBottom','FontSize',20);
% imgshapetext = insertText(imgshapetext,pos3,value3,'AnchorPoint','LeftBottom','FontSize',20);
imgshapetext = insertShape(imgshapetext,'line',[Xl(1),Yl(1),Xl(2),Yl(2)],'LineWidth',7,'Color','red');
imgshapetext = insertShape(imgshapetext,'line',[Xr(1),Yr(1),Xr(2),Yr(2)],'LineWidth',7,'Color','red');

% imshow(imgshapetext);
% plot(Xl,Yl,'LineWidth',2.1,'Color','red');
% plot(Xr,Yr,'LineWidth',2.1,'Color','red');

% pause(0.0005);

    
 end