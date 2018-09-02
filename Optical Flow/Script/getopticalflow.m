function [xselect,yselect, uselect,vselect] = getopticalflow(img1rgb,img2rgb)

% Function to implement Lucas kanade method on the whole Image. (Reference taken from Mathworks File Exchange) ) 

%% Converting Image to double for doing calculations
    img1=im2double((img1rgb));
    img2=im2double((img2rgb));
    
%% Computing Individual Derivatives

    Ix = conv2(img1,[-1 1; -1 1], 'valid'); 
    Iy = conv2(img1, [-1 -1; 1 1], 'valid');
    % Getting derivatie over time
    Idiff = conv2(img1, ones(2), 'valid') + conv2(img2, -ones(2), 'valid');
%% Intializing Variables 
    w=10; %Window Size
    u = zeros(size(img1));
    v = zeros(size(img2));

   for i = w+1:size(Ix,1)-w
     for j = w+1:size(Ix,2)-w
         
        Ixw = Ix(i-w:i+w, j-w:j+w);
        Iyw = Iy(i-w:i+w, j-w:j+w);
        Idiffw = Idiff(i-w:i+w, j-w:j+w);
        
        Ixw = Ixw(:);
        Iyw = Iyw(:);
        b = -Idiffw(:); 
        
        A = [Ixw Iyw]; 
        result = pinv(A)*b;
        u(i,j)=result(1);
        v(i,j)=result(2);
     end   
   end
   
 %% Selecting points at even intervals from the entire u and v.
    [m, n] = size(Ix);
    [X,Y] = meshgrid(1:n, 1:m);
    interval=20;
    xselect = X(1:interval:end, 1:interval:end);
    yselect = Y(1:interval:end, 1:interval:end);
    
    uselect = u(1:interval:end, 1:interval:end);
    vselect = v(1:interval:end, 1:interval:end);

    
end