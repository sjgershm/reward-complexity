function I = mutual_information(state,action,alpha)
    
    % Hutter estimator of mutual information.
    %
    % USAGE: I = mutual_information(state,action,[alpha])
    
    uS = unique(state);
    uA = unique(action);
    
    N = zeros(length(uS),length(uA));
    if nargin < 3; alpha = 1/numel(N); end % Perks (1947) prior
    
    for x = 1:length(uS)
        for y = 1:length(uA)
            N(x,y) = alpha + sum(state==uS(x) & action==uA(y));
        end
    end
    
    n = sum(N(:));
    nA = sum(N);
    nS = sum(N,2);
    P = psi(N+1) - repmat(psi(nA+1), size(N,1), 1) - repmat(psi(nS+1), 1, size(N,2)) + psi(n+1);
    I = sum(sum(N.*P))/n;