function plot_figures(fig)
    
    switch fig
        
        case 'fig2'
            
            figure;
            load results_collins18.mat
            C = linspecer(2);
            R = squeeze(nanmean(results.R));
            V = squeeze(nanmean(results.V));
            ylim = [0.25 1.1];
            xlim = [0 0.9];
            for i = 1:2
                h(i) = plot(R(:,i),V(:,i),'LineWidth',4,'Color',C(i,:));
                hold on;
            end
            xlabel('Policy complexity','FontSize',25);
            ylabel('Average reward','FontSize',25);
            set(gca,'FontSize',25,'YLim',ylim,'XLim',xlim);
            for i =1:2
                h(i+2) = plot(results.R_data(:,i),results.V_data(:,i),'o','Color',C(i,:),'MarkerSize',10,'LineWidth',3,'MarkerFaceColor',C(i,:));
            end
            legend(h,{'Ns = 3 (theory)' 'Ns = 6 (theory)' 'Ns = 3 (data)' 'Ns = 6 (data)'},'FontSize',25,'Location','SouthEast');
            
            p = signrank(results.R_data(:,1),results.R_data(:,2))
            
            R = [R(:,1); R(:,2)]; V = [V(:,1); V(:,2)];
            Rd = [results.R_data(:,1); results.R_data(:,2)]; Vd = [results.V_data(:,1); results.V_data(:,2)];
            Vd2 = interp1(R,V,Rd,'cubic');
            [r,p] = corr(Vd,Vd2)
            
        case 'fig3'
            
            figure;
            load results_steyvers19.mat
            C = linspecer(1);
            plot(results.R,results.V,'LineWidth',4,'Color',C);
            hold on;
            plot(results.R_data,results.V_data,'o','MarkerSize',10,'LineWidth',3,'Color',C,'MarkerFaceColor',C);
            set(gca,'FontSize',25);
            xlabel('Policy complexity','FontSize',25);
            ylabel('Average reward','FontSize',25);
            legend({'theory' 'data'},'FontSize',25,'Location','East');
            
            Vd = interp1(results.R,results.V,results.R_data,'cubic');
            [r,p] = corr(Vd,results.V_data)
            
        case 'fig4'
            
            figure;
            load results_collins_modelfit.mat
            
            subplot(2,2,1)
            hist(results(1).x(:,end))
            colormap bone
            set(gca,'FontSize',25,'XLim',[-0.2 2]);
            xlabel('Perseveration parameter','FontSize',25);
            ylabel('Frequency','FontSize',25);
            
            subplot(2,2,2)
            L = log(bms_results.g(:,2)) - log(bms_results.g(:,1));
            plot(sort(L),'-k','LineWidth',4);
            set(gca,'FontSize',25,'YLim',[-5 10],'XLim',[1 91]);
            xlabel('Subject','FontSize',25);
            ylabel('Model evidence','FontSize',25);
            
            load results_steyvers_modelfit.mat
            
            subplot(2,2,3)
            hist(results(1).x(:,end))
            colormap bone
            set(gca,'FontSize',25,'XLim',[-0.2 2]);
            xlabel('Perseveration parameter','FontSize',25);
            ylabel('Frequency','FontSize',25);
            
            subplot(2,2,4)
            L = log(bms_results.g(:,2)) - log(bms_results.g(:,1));
            plot(sort(L),'-k','LineWidth',4);
            set(gca,'FontSize',25,'YLim',[-5 10],'XLim',[1 1000]);
            xlabel('Subject','FontSize',25);
            ylabel('Model evidence','FontSize',25);
            
            set(gcf,'Position',[200 200 950 800])
            
        case 'fig5'
            
            load simresults_steyvers.mat
            
            figure;
            plot(X(:,2),results(1).x(:,2),'+k','MarkerSize',10,'LineWidth',3);
            h = lsline; set(h,'Color','k','LineWidth',4);
            set(gca,'FontSize',25,'XLim',[0 5],'YLim',[0 5]);
            xlabel('True parameter','FontSize',25);
            ylabel('Recovered parameter','FontSize',25);
            
            [r,p] = corr(results(1).x(:,2),X(:,2))
            
    end