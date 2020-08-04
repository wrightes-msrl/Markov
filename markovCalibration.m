%% Markov Model: Calibrating the Transition Matrix
% Our goal will be to observe time series data from a system we believe can 
% be accurately modeled with a discrete time markov model. Rather than collect 
% data from a physical system, we'll simulate it by establishing a valid Markov 
% transition matrix and then simulating a time series that represent observations 
% that we'd make of the dominant vegetation category in a landscape, had we decided 
% to collect physical data.

M=[
    0.70 0.25 0.11;
    0.14 0.63 0.04;
    0.16 0.12 0.85
    ];
n=size(M,2);
%% 
% 

steps=50;
ts=randi(n,1);
for i=1:steps
    ts=[ts randsample(n,1,true,M(:,ts(end)))];
end
%% 
% Count the number of times an observation of state j is followed immediately 
% by an observation of state i. The matrix N(i,j) stores these counts.

N=full(sparse(ts(2:end),ts(1:end-1),1,n,n));
%% 
% P is the maximum likelihood estimate of M given our time series observation. 
% Compare its transition probabilities with those of M.

P=(N./sum(N))
P-M
%% Improving Accuracy With More Data
% The agreement between P and M isn't exactly spectacular.  The way to improve 
% this in general is to collect more data to bue used in calibration. One way 
% to do this is to observe a longer time series. Consider a time series of 2500 
% steps:

steps=2500;
ts=randi(n,1);
for i=1:steps
    ts=[ts randsample(n,1,true,M(:,ts(end)))];
end
%% 
% Count the number of times an observation of state j is followed immediately 
% by an observation of state i. The matrix N(i,j) stores these counts.

N=full(sparse(ts(2:end),ts(1:end-1),1,n,n));
%% 
% P is the maximum likelihood estimate of M given our time series observation. 
% Compare its transition probabilities with those of M.

P=(N./sum(N))
P-M
%% 
% Clearly the accuracy has improved, but this has cost us 2500 observations 
% instead of 50.
%% Improving Accuracy With Multiple Data Collection Sites
% In the case of observing the dominant vegetation category in a landscape on 
% an annual basis, it is completely impractical to collect a single data point 
% for the time series once each year for 2500 years. It was probably even impractical 
% to collect a single data point once a year for 50 years.  However, it could 
% be feasible to distribute 500 independent sites across the landscape and make 
% an observation at each of them in parallel once every five years.  This would 
% result in 500 independent time series that are each five steps long, which is 
% still equivalent to a time series of 2500 elements. These five time series could 
% each be used to produce transition counts which could, in turn, be pooled in 
% order to approximate a transition probability matrix. An approach for this is 
% given below.

sites=500; % number of sites along transect
steps=5; % number of steps in time series
% simulate a time series of observed Markov states at each of the sites.
% Each row of the ts matrix will represent one of these time series
ts=randi(n,sites,1);
for i=1:steps
    tsnew=[];
    for j=1:sites
        % Create a column vector of new state observations to be appended
        % to the end of each row of the time series data
        tsnew=[tsnew;randsample(n,1,true,M(:,ts(j,end)))];
    end
    % Append the new state observations to the end of the time series data.
    ts=[ts tsnew];
end
%% 
% Count the number of times an observation of state j is followed immediately 
% by an observation of state i. The matrix N(i,j) stores these counts.

N=full(sparse(ts(:,2:end),ts(:,1:end-1),1,n,n));
%% 
% P is the maximum likelihood estimate of M given our time series observation.

P=(N./sum(N))
P-M
%% 
% The agreement between the actual and approximate transition matrices is comparable 
% to when we calibrated the model using a single, 2500 element time series.