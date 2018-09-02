function [C,u,v] = getopticalflowcorner(img1rgb,img2rgb)
% Function to implement Lucas kanade method on the Corner Points Detected from Harris Corner Detection. (Reference taken from Mathworks File Exchange) ) 

%% Converting Image to double for doing calculations
    img1=im2double((imgaussfilt(img1rgb,2)));
    img2=im2double((imgaussfilt((img2rgb),2)));
    
%% Computing Individual Derivatives

    Ix = conv2(img1,[-1 1; -1 1], 'valid'); 
    Iy = conv2(img1, [-1 -1; 1 1], 'valid');
    % Getting derivatie over time
    Idiff = conv2(img1, ones(2), 'valid') + conv2(img2, -ones(2), 'valid');
%% Intializing Variables 
    w=20; %Windiw Size
    
%% Using Harris corners of matlab
%     c= detectHarrisFeatures(img1);
%     cor= round(c.Location);
%% Using User Defined Harris corners
    c= harriscornerdetect(img1);
    cor= round(c); 
%% Discard coners near the margin of the image
    k = 1;
    wi=w;
    for i= 1:size(cor,1)
        x = cor(i, 1);
        y = cor(i, 2);
        if ((x-wi)>=1 && (y-wi)>=1 && (x+wi)<=size(img1,2)-1 && (y+wi)<=size(img1,1)-1)
          C(k,:) = cor(i,:);
          k = k+1;
        end
    end
    % Plot corners on the image
%     figure();
%     imshow(img2);
%     hold on
%     plot(C(:,1), C(:,2), 'r*');
    
    % Least Sqaure Difference in size of window w
    for k = 1:size(C,1)
        y = C(k,1); x = C(k,2);
        Ixw = Ix(x-w:x+w, y-w:y+w);
        Iyw = Iy(x-w:x+w, y-w:y+w);
        Idiffw = Idiff(x-w:x+w, y-w:y+w);
        Ixw = Ixw(:);
        Iyw = Iyw(:);
        b = -Idiffw(:); % get b here
        A = [Ixw Iyw]; % get A here
        result = pinv(A)*b;
        u(k)=result(1);
        v(k)=result(2);
    end   
    u=u';v=v';
    
end