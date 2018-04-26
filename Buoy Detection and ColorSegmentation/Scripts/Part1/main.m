%% Project 3- Anirudh Topiwala
%% Buoy Recognition ad Detection
%% Part1: Expectation and maximization
clc;clear all; close all;


%% Line Space Data
dataset=0;
x1= linspace(10,20,1000);
[x1mean,x1sigma]=estimate(x1);
x2= linspace(20,30,1000);
[x2mean,x2sigma]=estimate(x2);
x3= linspace(30,40,1000);
[x3mean,x3sigma]=estimate(x3);
x4= linspace(40,50,100);
[x4mean,x4sigma]=estimate(x4);
% 
xtot= sort( [x1, x2, x3]');
% 
y1 = normpdf(xtot,x1mean,sqrt(x1sigma));
y2 = normpdf(xtot,x2mean,sqrt(x2sigma));
y3 = normpdf(xtot,x3mean,sqrt(x3sigma));
y4 = normpdf(xtot,x4mean,sqrt(x4sigma));
ytot=y1+y2+y3;

%% Random Normfit data
% dataset=0;
% x1 = normrnd(5,10,[1,10]);
% x2 = normrnd(10,20,[1,10]);
% x3 = normrnd(15,30,[1,10]);
% x4 = normrnd(20,40,[1,10]);
% xtot= [x1', x2',x3'];

%% Random Data
% dataset=1;
% Dimension of Data
% d=1;
% data = cat(3,(1 + rand(100,d))*125,(1 + rand(100,d))*255,(1 + rand(100,d))*200);
% X = [data(:,:,1); data(:,:,2); data(:,:,3)];
% xtot = sort(X);

%% Buoy Data
% dataset=1;
% cd ..;cd Part0;
% load('ColorSamples.mat')
% cd .. ; cd Part1;
% xtot=redbuoy;

%% Plot original Data
hold on
% normx= normalize(xtot);
% % % [heights,locations] = hist(xtot);
% % % width = locations(2)-locations(1);
% % % heights = heights / (size(xtot,1)*width);
% % % bar(locations,heights,'hist')
% h=histogram(xtot,50);
% bar(values,counts);
% hold off
%% YPlots
plot(xtot,y1,'r')
plot(xtot,y2,'r')
plot(xtot,y3,'r')
title('Comparison of 1D Gaussians')
% xtot= [x1, x2, x3];



%% Step 1 : Initialization of values
    llf = 0; 
    numberiter=100;
    %For K gaussian
    k=3; 
    temp1=randperm(k);
    pie=temp1/sum(temp1);
    D=size(xtot,2);
%     mean=zeros(k,D);
    rndm=randperm(size(xtot,1),k);
%     rndm=randperm(size(xtot,2),k);

    for j=1:k
     mean(:,j)=xtot(rndm(j),:)'; 
     sigma(:,:,j)=eye(size(xtot,2)).*var(xtot);     
    end  
    
  %% Iterating over n times
  
    for i = 1:numberiter
  %% Step 2 : Expectation Step; computes the responsibilities
      s=zeros(size(xtot,1),k);
       for j=1:size(xtot,1)
          for l=1:k       
              s(j,l)=pie(l)*gauss_dist(xtot(j,:),mean(:,l)',sigma(:,:,l));
          end         
       end
       s2=sum(s,2);
       llf(i)= sum(log(s2)); 
       
       for l=1:k
       gamma(:,l)=s(:,l)./s2;
       end

   %% Step 3 : Maximization Step; compute the weighted means and variances
        for l=1:k
        mean(:,l)= ((gamma(:,l)'*xtot)/sum(gamma(:,l)))';

        sigma(:,:,l) = ((gamma(:,l).*(xtot-mean(:,l)'))'*(xtot-mean(:,l)'))/sum(gamma(:,l));

        pie(l)=sum(gamma(:,l))/size(xtot,1);

        end
    end
    
%% Generating Gaussian Object

% Matlabs Gaussian Object
 options = statset('MaxIter',500);
 t=fitgmdist(xtot,k,'Options',options,'CovarianceType','full');
 
%% Plotting Data
if (dataset==1)
    gmObj = gmdistribution(mean',sigma,pie);
    ynew = pdf(gmObj,xtot);
    ynewmatlab = pdf(t,xtot);
    plot(xtot,ynew,'g');
    plot(xtot,ynewmatlab,'b');
    legend('Input Data','My EM Output','Matlab EM Output');
elseif (dataset==0)
   for j=1:k
       ynew(:,j)= normpdf(xtot,mean(j),sqrt(sigma(:,:,j)));
       ynewmatlab(:,j)= normpdf(xtot,t.mu(j),sqrt(sigma(:,:,j)));
       plot(xtot,ynew(:,j),'b');
       plot(xtot,ynewmatlab(:,j),'g');
   end


end

 
%% Plot Log Likelihood Convergence     
%     figure
%     plot(llf)
%     xlabel('Iteration');
%     ylabel('Observed Data Log-likelihood');
%     grid minor
%     
    

    

function [ y ] = gauss_dist(x,u,sigma)
    D=size(x,2);

%GAUSS_DIST function for gaussian distribution
    y=(1/((2*pi)^(D/2)))*(1/sqrt(det(sigma)))*exp(-0.5*(x-u)*inv(sigma)*(x-u)');
  
end



