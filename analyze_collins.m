function results = analyze_collins(data)
    
    % Analyze Collins (2018) data.
    
    if nargin < 1
        data = load_data('collins18');
    end
    
    beta = linspace(0.1,15,30);
    
    for s = 1:length(data)
        B = unique(data(s).learningblock);
        cond = zeros(length(B),1);
        R_data =zeros(length(B),1);
        V_data =zeros(length(B),1);
        for b = 1:length(B)
            ix = data(s).learningblock==B(b) & data(s).phase==0;
            stim = data(s).stim(ix)';
            c = data(s).corchoice(ix);
            choice = data(s).choice(ix)';
            lowerx = 1; upperx = max(stim); lowery = 1; uppery = max(stim);
            descriptor = [lowerx,upperx,upperx-lowerx;lowery,uppery,uppery-lowery];
            R_data(b) = information(stim,choice,descriptor);
            V_data(b) = mean(data(s).cor(ix));
            
            S = unique(stim);
            Q = zeros(length(S),3);
            Ps = zeros(1,length(S));
            for i = 1:length(S)
                ii = stim==S(i);
                Ps(i) = mean(ii);
                a = c(ii); a = a(1);
                Q(i,a) = 1;
            end
            
            [R(b,:),V(b,:)] = blahut_arimoto(Ps,Q,beta);
            
            if length(S)==3
                cond(b) = 1;
            else
                cond(b) = 2;
            end
            
            ix = data(s).learningblock==B(b) & data(s).phase==1;
            stim = data(s).stim(ix)';
            choice = data(s).choice(ix)';
            try
                R_test(b) = information(stim,choice);
                V_test(b) = mean(data(s).cor(ix));
            catch
                R_test(b) = nan;
                V_test(b) = nan;
            end
        end
        
        for c = 1:2
            results.R(s,:,c) = nanmean(R(cond==c,:));
            results.V(s,:,c) = nanmean(V(cond==c,:));
            results.R_data(s,c) = nanmean(R_data(cond==c));
            results.V_data(s,c) = nanmean(V_data(cond==c));
            results.V_test(s,c) = nanmean(V_test(cond==c));
            results.R_test(s,c) = nanmean(R_test(cond==c));
        end
        
        clear R V
        
    end