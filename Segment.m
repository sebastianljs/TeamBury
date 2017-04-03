classdef Segment < handle 
    properties 
        segmentRegion % set of x, y coordinates
        hypothesisEdges % list of sets of 4 edges that forms the hypothesis
        hypothesisRegions % list of set of x, y coordinates in each hypothesis
        hypothesisProbability % between 0 and 4
        highScore % Highest score among hypothesisRegions
        bestHypothesis % Hypothesis with the highest score 
    end 
    
    methods     
        
        function S = Segment(segmentRegion, hypothesisRegions, hypothesisEdges, hypothesisProbability)
            % Constructor 
            S.segmentRegion = segmentRegion;
            S.hypothesisRegions = hypothesisRegions;
            S.hypothesisEdges = hypothesisEdges;
            S.hypothesisProbability = hypothesisProbability;
        end 
        function normalizedRatios = findNormalizedRatio(S)
            % Compute the normalized ratio 
%             normalizedRatios = zeros(size(S.hypothesisRegions));
            % Vectorize 
            regionDiff = cellfun(@(x) (setdiff(S.segmentRegion, x, 'rows')), S.hypothesisRegions, 'UniformOutput', false);
            normalizedRatios = cellfun(@(x) (1 - size(x,1)/size(S.segmentRegion,1)), regionDiff); 
%             for i = 1:length(S.hypothesisRegions)
%                 regionDiff = setdiff(S.segmentRegion, S.hypothesisRegions{i},'rows');
%                 normalizedRatios(i) = 1 - size(regionDiff,1)/size(S.segmentRegion,1);
%             end  
            % Normalize 
%             disp(normalizedRatios);
             normalizedRatios = normalizedRatios/norm(normalizedRatios);
        end 
        
        function percentageOverlap = findPercentageOverlap(S)
            % Jaccard Index 
            % Compute percentage overlap 
            regionUnion = cellfun(@(x) (union(x, S.segmentRegion, 'rows')), S.hypothesisRegions, 'UniformOutput', false); 
            regionIntersect = cellfun(@(x) (intersect(x, S.segmentRegion, 'rows')), S.hypothesisRegions, 'UniformOutput', false); 
            percentageOverlap = cellfun(@(x,y) (size(x,1)/size(y,1)), regionIntersect, regionUnion); 
%             percentageOverlap = cell2mat(percentageOverlap); 
%             for i = 1:length(S.hypothesisRegions)
%                 regionUnion = union(S.hypothesisRegions{i},S.segmentRegion,'rows');
%                 regionIntersect = intersect(S.hypothesisRegions{i},S.segmentRegion,'rows');
%                 percentageOverlap(i) = size(regionIntersect,1)/size(regionUnion,1);
%             end            
        end 
        function [bestHypothesis, highScore] = findHighScore(S, normalizedRatios, percentageOverlap)
            % Find highest score for given list of hypotheses
            meanScore = (transpose(S.hypothesisProbability) + normalizedRatios + percentageOverlap)/3;
            [~, idx] = max(meanScore);
            highScore = meanScore(idx);
            bestHypothesis = S.hypothesisEdges(idx);
        end
    end 
end 