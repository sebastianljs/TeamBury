classdef Segment < handle 
    properties 
        segmentRegion % set of x, y coordinates
        hypothesisRegions % list of set of x, y coordinates 
        hypothesisProbability % between 0 and 4
        highScore % Highest score among hypothesisRegions 
    end 
    
    methods     
        function S = segment(segmentRegion, hypothesisRegions, hypothesisProbability)
            % Constructor 
            S.segmentRegion = segmentRegion;
            S.hypothesisRegions = hypothesisRegions;
            S.hypothesisProbability = hypothesisProbability;
        end 
        function normalizedRatios = findNormalizedRatio(S)
            % Compute the normalized ratio 
            normalizedRatios = zeros(size(S.hypothesisRegions));
            for i = 1:length(S.hypothesisRegions)
                regionDiff = setdiff(S.segmentRegion, S.hypothesisRegions{i},'rows');
                normalizedRatios(i) = 1 - size(regionDiff,1)/size(S.segmentRegion,1);
            end  
            % Normalize 
             normalizedRatios = normalizedRatios/norm(normalizedRatios);
        end 
        
        function percentageOverlap = findPercentageOverlap(S)
            % Jaccard Index 
            % Compute percentage overlap 
            percentageOverlap = zeros(size(S.hypothesisRegions));
            for i = 1:length(S.hypothesisRegions)
                regionUnion = union(S.hypothesisRegions{i},S.segmentRegion,'rows');
                regionIntersect = intersect(S.hypothesisRegions{i},S.segmentRegion,'rows');
                percentageOverlap(i) = size(regionIntersect,1)/size(regionUnion,1);
            end            
        end 
        function highScore = findHighScore(S, normalizedRatios, percentageOverlap)
            % Find highest score for given list of hypotheses 
            meanScore = (S.hypothesisProbability + normalizedRatios + percentageOverlap)/3;
            [~, idx] = max(meanScore);
            highScore = meanScore(idx);
        end
    end 
end 
