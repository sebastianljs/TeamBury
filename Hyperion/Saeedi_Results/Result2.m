classdef Result2 < handle
    % define the variables
    properties
        roc
        pr
        truelabels
        score
        lengththread = 1e4;
    end
    % define all the methods
    methods
        % define a constructor
        function R = Result2(score,truelabels)
            R.score = score;
            R.truelabels = truelabels;
            fprintf('Calculating ROC curve...')
            R.calculateRoc();
            fprintf('Calculating PR curve...')
            R.calculatePR();
        end
        % caculate the Roc curve
        function R = calculateRoc(R)
            [R.roc.x,R.roc.y,R.roc.auc] = perfcurve(R.truelabels,R.score,1) ;
            
            nPoints = length(R.roc.x) ;
            if length(nPoints) < R.lengththread
                % if there are not many points, leave the curve as it is
                R.roc.xPlot = R.roc.x ;
                R.roc.yPlot = R.roc.y ;
            else
                % Determine how much downsampling needs to be done
                downsampleValue = ceil(nPoints / R.lengththread) ;
                
                % interpolate the data for plotting
                R.roc.xPlot = downsample(R.roc.x,downsampleValue) ;
                R.roc.yPlot = downsample(R.roc.y,downsampleValue) ;
            end
        end
        % calculate the pr curve
        function R = calculatePR(R)
            [R.roc.x,R.roc.y,~,R.roc.auc] = perfcurve(R.truelabels,R.score,1) ;
            [R.pr.x,R.pr.y,~,R.pr.auc] = perfcurve(R.truelabels,R.score, 1, 'xCrit', 'reca', 'yCrit', 'prec');
            
            nPoints = length(R.pr.x) ;
            if length(nPoints) < R.lengththread
                % if there are not many points, leave the curve as it is
                R.pr.xPlot = R.pr.x ;
                R.pr.yPlot = R.pr.y ;
            else
                % Determine how much downsampling needs to be done
                downsampleValue = ceil(nPoints / R.lengththread) ;
                
                
            
       
                
                % interpolate the data for plotting
               R.pr.xPlot = downsample(R.pr.x,downsampleValue) ;
                R.pr.yPlot = downsample(R.pr.y,downsampleValue) ;
            end
        end
        
        function plotRoc(R)
            plot([0 1],[0 1],'k') ; hold on ;
            plot(R.roc.xPlot,R.roc.yPlot,'r','linewidth',1)
            xlabel('Probability of False Alarm')
            ylabel('Probability of Detection')
            title(['AUC = ' num2str(R.roc.auc)])
            axis square
            axis([0 1 0 1])
        end
        
        function plotPr(R)
            proportionPositive = sum(R.truelabels) / length(R.truelabels) ;
            plot([0 1],proportionPositive*ones(1,2),'k') ; hold on ;
            plot(R.pr.xPlot,R.pr.yPlot,'r','linewidth',1)
            xlabel('Recall')
            ylabel('Precision')
            axis square
            axis([0 1 0 1])
        end
    end
end
        
        
        
        