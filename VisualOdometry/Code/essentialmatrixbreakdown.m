%% Project 2- Anirudh Topiwala

function [rots,trans]= essentialmatrixbreakdown(E)
 
    % Regenrating Essential Matrix such that rank=2.
    [UF, S,VF] = svd(E);
    % SF=eye(3);
    S = diag([(S(1,1)+S(2,2))/2 (S(1,1)+S(2,2))/2 0]);% to make rank=2
    %S(3,:)=0; 
    E= UF*S*VF';
    % e(abs(e)<1e-5)=0; 


    % Decompose the matrix E by svd
    [u, ~, v] = svd(E);
    W = [0 -1 0; 1 0 0; 0 0 1];

    % Two possibilities:
    rot1 = u * W' * v'; %Prove given in"Multiple View Geometry" Page 258, -9.14
    rot2 = u * W * v';

    % Two possibilities:
    % t1 = u(:,3) ./max(abs(u(:,3)));
    % t2 = -u(:,3) ./max(abs(u(:,3)));
    if(u(3,3)>0)
    t1 = -(u(:,3)) ;      % Only Negative T is taken as after taking inverse later on we want T to be positive. This is an constraint added to get correct answer.
    else
    t1 = (u(:,3)) ;
    end

    if(det(rot1)<0)
        rot1=-rot1;        % Only Positive det(rot) is taken as rotation matrices can never have -ive determinant. This is an constraint added to get correct answer.
    end
    if(det(rot2)<0)
        rot2=-rot2;
    end

    %As there are two rotations and one translations, we get 2 possible choices as follows:
    rots(:,:,1) = rot1; 
    trans(:,:,1) = t1;

    rots(:,:,2) = rot2; 
    trans(:,:,2) = t1;
    
    % Note: these R and T generated are Frame1 wrt Frame2


end
