function results = analyze_collins(data)
    
    % Analyze Collins (2018) data.
    
    if nargin < 1
        data = load_data('collins18');
    end
    
    beta = linspace(0.1,15,50);
    
    for s = 1:length(data)
        B = unique(data(s).learningblock);
        cond = zeros(length(B),1);
        R_data =zeros(length(B),1);
        V_data =zeros(length(B),1);
        for b = 1:length(B)
            ix = data(s).learningblock==B(b) & data(s).phase==0;
            state = data(s).state(ix);
            c = data(s).corchoice(ix);
            action = data(s).action(ix);
            R_data(b) = mutual_information(state,action,0.7);
            V_data(b) = mean(data(s).reward(ix));
            
            S = unique(state);
            Q = zeros(length(S),3);
            Ps = zeros(1,length(S));
            for i = 1:length(S)
                ii = state==S(i);
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
            
        end
        
        for c = 1:2
            results.R(s,:,c) = nanmean(R(cond==c,:));
            results.V(s,:,c) = nanmean(V(cond==c,:));
            results.R_data(s,c) = nanmean(R_data(cond==c));
            results.V_data(s,c) = nanmean(V_data(cond==c));
        end
        
        clear R V
        
    end
    
    p = signrank(results.R_data(:,1),results.R_data(:,2))
    
    R = squeeze(nanmean(results.R));
    V = squeeze(nanmean(results.V));
    for c = 1:2
        Vd2(:,c) =  interp1(R(:,c),V(:,c),results.R_data(:,c));
        results.bias(:,c) = results.V_data(:,c) - Vd2(:,c);
    end
    
    [r,p] = corr([results.V_data(:,1); results.V_data(:,2)],[Vd2(:,1); Vd2(:,2)])
    [r,p] = corr([results.R_data(:,1); results.R_data(:,2)],abs([results.bias(:,1); results.bias(:,2)]))