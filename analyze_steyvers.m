function results = analyze_steyvers(data)
    
    % Analyze Steyvers et al. (2019) data.
    
    if nargin < 1
        data = load_data('steyvers19');
    end
    
    beta = linspace(1.5,5,30);
        
    for s = 1:length(data)
        results.R_data(s,1) = mutual_information(data(s).state,data(s).action,0.1);
        if isnan(results.R_data(s)); keyboard; end
        results.V_data(s,1) = mean(data(s).reward);
        for state = 1:32
            Ps(s,state) = mean(data(s).state==state);
        end
    end
    
    Ps = mean(Ps);
    [X, Y, Z] = ind2sub([4 4 2],1:32);
    Q = zeros(32,4);
    for i = 1:32
        if Z(i)==1
            a = X(i);
        else
            a = Y(i);
        end
        Q(i,a) = 1;
    end
    [results.R,results.V] = blahut_arimoto(Ps,Q,beta);
    results.Q = Q; results.Ps = Ps;
    
    Vd = interp1(results.R,results.V,results.R_data,'cubic');   % for some reason linear interpoloation doesn't work here
    [r,p] = corr(Vd,results.V_data)
    results.bias = Vd - results.V_data;
    [r,p] = corr(results.R_data,results.bias)