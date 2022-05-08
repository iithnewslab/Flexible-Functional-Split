n_DU = 10;
BW_max = 4200*n_DU; %Gbps
duration = 1e2;
BW_used = zeros(duration,1);
n_DU_centralized = zeros(duration,1);
t = linspace(0,1,duration);

%probability density function of an exponential distribution
function f = ft(t, lambda)
f = lambda*exp(-lambda*t);
end

% Gaussian Mixture Model (GMM)
% lambda = 