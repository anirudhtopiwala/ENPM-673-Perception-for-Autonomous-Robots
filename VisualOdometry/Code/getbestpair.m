%% Project 2- Anirudh Topiwala

function [newR, newT,alpha]= getbestpair(rots,trans,oldpoints, newpoints,alpha)
% This function is used to select which rot or trans pair will give 3D
% point in front of both the cameras.

Horigin=eye(4);
for i=1:size(oldpoints,1)
    check = false(1,2);
    for j=1:2
       rot= rots(:,:,j);t= trans(:,:,j);
       H= [rot t ; 0 0 0 1];
       H=inv(H); % Inv of H is taken as we want the rot and trans as Frame 2 wrt to Frame 2
       Anew=[ oldpoints(i,1)*Horigin(3,:)- Horigin(1,:);
               oldpoints(i,2)*Horigin(3,:)- Horigin(2,:);
               newpoints(i,1)*H(3,:)- H(1,:);
               newpoints(i,2)*H(3,:)- H(2,:)];
       [~,~, v]= svd(Anew);
       X= v(:,size(v,2));
       X=X./X(4);  
       Xdash= H\X;  % inv(H) is taken to calculate as again Hdash is wrt to the other frame.
       if (X(3)>0 && Xdash(3)>0)
           check(j) = true;
       end
    end
      if (sum(check)==1)
             Hdash= [rots(:,:,check) trans(:,:,check);0 0 0 1];
             Hdash=inv(Hdash);
            newR = Hdash(1:3,1:3) ;
            newT=Hdash(1:3,4);
            if (newT(3)<0)
                newT= -newT;
            end
            
            return;
      end
end
newR=eye(3); 
newT=[ 0 0 0]';
alpha=alpha+1; % Count to see, how many times identity matrix is used.
end



