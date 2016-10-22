classdef Features < handle
    % FEATURES - Class Summary
    %
    %   The Features class takes a Data class object as an input and
    %   extracts features from it for use with the Classifier class.
    %
    %   Author:         Kyle Bradbury
    %   Email:          kyle.bradbury@duke.edu
    %   Organization:   Duke University Energy Initiative
    
    properties
        dataSource  % Points to the original data
        featureType % Brief descriptor of the type of features that are extracted
        windowSize  % Radius of the window size for calculating features from (i.e. mean and variance for the example) 
        nFeatures   % Total number of features that will be calculated
        features    % Variable in which to store the extracted features
        labels      % Labels for each of the features (only non-empty for training and validation data)
    end
    
    methods
        %------------------------------------------------------------------
        % Features - Class Constructor
        %
        %   Extract features 
        %------------------------------------------------------------------
        function F = Features(Data)
            % Set parameters
            F.dataSource = Data ;
               
            % Load, process, and save the data
            fprintf('Extracting features from %s...\n', F.dataSource.imageFilename)
            F.extractFeatures() ;
            F.extractLabels() ;
            fprintf('Completed loading data from %s.\n', F.dataSource.imageFilename)
        end
        
        %------------------------------------------------------------------
        % extractAllFeatures
        %
        %   Extract all the features from the dataset. In this case the
        %   mean and variance are calculated form a 3-by-3 window around
        %   each pixel and is calculated for each of the three color
        %   channels for a total of 6 features (consider modifying this)
        %------------------------------------------------------------------
        function F = extractFeatures(F)
            
            % Create convolutional mask
            F.nFeatures = 6 ; %
            F.windowSize = 2 ; %
            F.featureType = 'channel_mean_and_variance' ;
            windowDiameter = 2*F.windowSize-1 ;
            nPixelsInWindow = windowDiameter^2 ;
            convMask = ones(windowDiameter) ;
            
            % Extract each of the three color channels
            pixels = double(F.dataSource.imageData) ;
            
            % Initialize feature vector
            F.features = nan(F.dataSource.nPixels,F.nFeatures) ;
            
            for iChannel = 1:3
                % Extract features
                cChannel = squeeze(pixels(:,:,iChannel)) ;
                cChannelMean       = (1/nPixelsInWindow) * conv2(cChannel,convMask,'same') ;
                cChannelMeanSquare = (1/nPixelsInWindow) * conv2(cChannel.^2,convMask,'same') ;
                cChannelVariance   = cChannelMeanSquare - cChannelMean.^2 ;
                
                % Store the features
                F.features(:,2*(iChannel-1)+1) = cChannelMean(:) ;
                F.features(:,2*iChannel)       = cChannelVariance(:) ;
            end
        end
        
        %------------------------------------------------------------------
        % extractLabels
        %
        %   Extract pixel labels (reshape into a vector of values)
        %------------------------------------------------------------------
        function F = extractLabels(F)
            F.labels = double(F.dataSource.labels(:)) ;
        end
    end
end

