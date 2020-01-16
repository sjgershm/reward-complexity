function [results, bms_results] = fit_models_collins(data,models,results)
    
    % Fit Collins (2018) data. Requires mfit package.
    
    if nargin < 2; models = 1:2; end
    
    for s = 1:length(data)
        trials = find(data(s).phase==0);
        data(s).N = length(trials);
        data(s).C = 3;
        A = zeros(data(s).N,3);
        for t = 1:data(s).N
            if data(s).action(t)>0
                A(t,data(s).action(t)) = 1;
            end
        end
        
        for b = 1:max(data(s).learningblock)
            ix = data(s).learningblock==b;
            for i = 1:size(A,2)
                A(ix,i) = eps + smooth(A(ix,i));
            end
        end
        data(s).logPa = log(A./sum(A,2));
    end
    
    for m = models
        disp(['... fitting model ',num2str(m)]);
        
        switch m
            
            case 1
                
                param(1) = struct('name','b1','logpdf',@(x) 0);
                param(2) = struct('name','b2','logpdf',@(x) 0);
                param(3) = struct('name','lr','logpdf',@(x) 0);
                param(4) = struct('name','tau','logpdf',@(x) 0);
                fun = @lik_collins;
                
            case 2
                
                param(1) = struct('name','b1','logpdf',@(x) 0);
                param(2) = struct('name','b2','logpdf',@(x) 0);
                param(3) = struct('name','lr','logpdf',@(x) 0);
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
    lr = 1./(1+exp(-x(3)));
    if length(x) > 3
        tau = x(end);
    else
        tau = 1;
    end
    
    lik = 0;
    
    for t = 1:data.N
        
        if t==1 || data.learningblock(t)~=data.learningblock(t-1)
           Q = zeros(data.ns(t),3);
        end
        
        a = data.action(t);
        s = data.state(t);
        r = data.reward(t);
        if a > 0
            if data.ns(t)==3
                b = B(1);
            else
                b = B(2);
            end
            d = b*Q(data.state(t),:) + tau*data.logPa(t,:);
            lik = lik + d(a) - logsumexp(d,2);
            Q(s,a) = Q(s,a) + lr*(r-Q(s,a));
        end
    end
end