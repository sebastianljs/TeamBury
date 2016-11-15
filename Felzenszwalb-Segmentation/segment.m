classdef segment < handle 
    properties 
        segmentRegion % set of x, y coordinates
        hypothesisRegions % list of set of x, y coordinates 
        hypothesisProbability % between 0 and 1 
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
            for i = 1:size(S.hypothesisRegions)
                regionDiff = setdiff(S.hypothesisRegions(i), S.segmentRegion);
                normalizedRatios(i) = 1 - size(regionDiff)/size(S.segmentRegion);
            end  
            % Normalize 
            normalizedRatios = normalizedRatios/norm(normalizedRatios);
        end 
        
        function percentageOverlap = findPercentageOverlap(S)
            % Compute the percentage overlap 
            % Jaccard Index 
            percentageOverlap = zeros(size(S.hypothesisRegions));
            for i = 1:size(S.hypothesisRegions)
                regionUnion = union(S.hypothesisRegions(i),S.segmentRegion);
                regionIntersect = intersect(S.hypothesisRegions(i),S.segmentRegion);
                % If overlap is complete, percentage should be 100 
                % If sets are disjoint, percentage should be 0 
                percentageOverlap(i) = size(regionIntersect)/size(regionUnion);
            end            
        end 
        function S = findHighScore(S, normalizedRatios, percentageOverlap)
            meanScore = (S.hypothesisProbability + normalizedRatios + percentageOverlap)/3;
            S.highScore = max(meanScore);
        end
    end 
end 
