function data = load_data(dataset)
    
    % Load data sets.
    %
    % USAGE: data = load_data(dataset)
    %
    % INPUTS:
    %   dataset - 'collins18' or 'steyvers19'
    
    switch dataset
        
        case 'collins18'
            
            T = {'ID' 'learningblock' 'trial' 'ns' 'state' 'iter' 'corchoice' 'action' 'reward' 'rt' 'pcor' 'delay' 'phase'};
            x = csvread('Collins18_data.csv',1);
            S = unique(x(:,1));
            for s = 1:length(S)
                ix = x(:,1)==S(s) & x(:,end)==0;
                for j = 1:length(T)
                    data(s).(T{j}) = x(ix,j);
                end
            end
            
        case 'steyvers19'
            
            load steyvers19_data.mat
            
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
            
            for s = 1:length(data)
                data(s).N = length(data(s).state);
                data(s).C = 4;
                A = zeros(data(s).N,4);
                for t = 1:length(data(s).state)
                    A(t,data(s).action(t)) = 1;
                    data(s).Q(t,:) = Q(data(s).state(t),:);
                end
                for i = 1:size(A,2); A(:,i) = eps + smooth(A(:,i)); end
                data(s).logPa = log(A./sum(A,2));
            end
            
        case 'collins14'
            
            load Collins_JN2014.mat
            
            T = {'ID' 'learningblock' 'ns' 'trial' 'state' 'image' 'folder' 'iter' 'corchoice' 'action' 'key' 'cor' 'reward' 'rt' 'cond' 'pcor' 'delay'};
            S = unique(expe_data(:,1));
            for s = 1:length(S)
                ix = expe_data(:,1)==S(s);
                for j = 1:length(T)
                    data(s).(T{j}) = expe_data(ix,j);
                end
                data(s).ID = data(s).ID(1);
                data(s).cond = data(s).cond(1);
            end
            
        case 'rutledge09'
            
            %pop: 1 hc2000 young controls, 2 hc2600 elderly controls, 3 pdoff, 4 pdon
            %hdr: 1 trialnum within block, 2 pressed 1left 2right button, 3 reward
            %received, 4cumulative reward, 5 reward scheduled on left, 6 reward
            %scheduled on right, 7 probleft, 8 probright, 9 choice time, 10 trial onset
            %(RTs can be <100ms because people can anticipate)
            
            load rutledge_jns09_rawdata.mat
            
            
            
    end