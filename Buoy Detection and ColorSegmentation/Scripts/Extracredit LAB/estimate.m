function [mu,sigma]=estimate(data)
mu=mean(double(data))';
sigma=var(double(data))';
end

