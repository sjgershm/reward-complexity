function [results, bms_results] = fit_models_collins(data)
    
    % Fit Collins (2018) data. Requires mfit package.
    
    for m = 1:2
        disp(['... fitting model ',num2str(m)]);
        
        switch m
            
            case 1
                
                param(1) = struct('name','b1','logpdf',@(x) 0);
                param(2) = struct('name','b2','logpdf',@(x) 0);
                param(3) = struct('name','sticky','logpdf',@(x) 0);
                fun = @lik_collins;
                
            case 2
                
                param(1) = struct('name','b1','logpdf',@(x) 0);
                param(2) = struct('name','b2','logpdf',@(x) 0);
                fun = @lik_collins;
                
        end
        
        results(m) = mfit_optimize(fun,param,data);
        clear param
    end
    
    % Bayesian model selection
    if nargout > 1
        bms_results = mfit_bms(results,1);
    end
    
end

function lik = lik_collins(x,data)
    
    B = x(1:2);
    if length(x) > 2
        sticky = x(3);
    else
        sticky = 1;
    end
    
    lik = 0;
    
    for t = 1:size(data.Q,1)
        a = data.choice(t);
        if a > 0
            if data.ns(t)==3
                b = B(1);
            else
                b = B(2);
            end
            d = b*data.Q(t,:) + sticky*data.logPa(t,:);
            lik = lik + d(a) - logsumexp(d,2);
        end
    end
end