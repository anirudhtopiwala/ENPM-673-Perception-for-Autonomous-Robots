
function [ri,gi,bi,x]= gethistdata(Rr,Gr,Br) 
     %Get histValues for each channel
     sizer= floor(sqrt(size(Rr,1)));
     sizeg= floor(sqrt(size(Gr,1))); 
     sizeb= floor(sqrt(size(Br,1)));
     Rr=Rr(1:sizer^2);  Gr=Gr(1:sizeg^2);  Br=Br(1:sizeb^2);
     Rhist= reshape(Rr,[],sizer);Ghist= reshape(Gr,[],sizeg);Bhist= reshape(Br,[],sizeb);

    [ri, x] = imhist(uint8(Rhist));
    [gi, x] = imhist(uint8(Ghist));
    [bi, x] = imhist(uint8(Bhist));
    
end