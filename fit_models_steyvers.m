function [results, bms_results] = fit_models_steyvers(data,models)
    
    % Fit models to Steyvers data. Requires mfit package.
    
    if nargin < 2; models = 1:2; end
    
    for m = models
        disp(['... fitting model ',num2str(m)]);
        
        switch m
            
            case 1
                
                param(1) = struct('name','b','logpdf',@(x) 0);
                param(2) = struct('name','sticky','logpdf',@(x) 0);
                fun = @lik_steyvers;
                
            case 2
                
                param(1) = struct('name','b','logpdf',@(x) 0);
                fun = @lik_steyvers;
                
        end
        
        results(m) = mfit_optimize(fun,param,data);
        clear param
    end
    
    % Bayesian model selection
    if nargout > 1
        bms_results = mfit_bms(results,1);
    end
    
end

function lik = lik_steyvers(x,data)
    
    b = x(1);
    if length(x) > 1
        sticky = x(2);
    else
        sticky = 1;
    end
    
    d = b*data.Q + sticky*data.logPa;
    lik = -sum(logsumexp(d,2));
    
    for t = 1:data.N
        lik = lik + d(t,data.action(t));
    end
end