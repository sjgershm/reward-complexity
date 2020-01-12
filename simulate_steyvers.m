function [data, X] = simulate_steyvers(data)
    
    % Generate simulated data using the task switching design in Steyvers
    % et al. (2019).
    %
    % USAGE: [data, X] = simulate_steyvers(data)
    
    if nargin < 1; load_data('steyvers19'); end
    
    N = 200;
    S = 100;
    data = data(1:S);
    
    for s = 1:100
        
        X(s,:) = unifrnd([0 0],[5 5]);
        
        b = X(s,1);
        sticky = X(s,2);
        
        data(s).N = N;
        data(s).Q = data(s).Q(1:N,:);
        data(s).logPa = data(s).logPa(1:N,:);
        data(s).state = data(s).state(1:N);
        data(s).action = data(s).action(1:N);
        data(s).reward = data(s).reward(1:N);
        
        d = b*data(s).Q + sticky*data(s).logPa;
        P = exp(d - logsumexp(d,2));
        
        for n = 1:N
            data(s).action(n) = fastrandsample(P(n,:));
        end
        
    end