% globalHypothesisRefinement.m

% Measure intersection of complex polygons 
% After all geometric overlaps are computed, overlapping groups will be
% generated
% In each group the best representative will be chosen using the hypothesis
% probabilty measured in IIIB and IIIC 

% Group hypotheses into overlapping groups

% For a list of hypothesis, use a for loop to run setDiff
% Use a boolean array to keep track of which hypothesis has been added 
hypothesis = {};
groups = {};
added = false(length(hypothesis));

for i = 1:length(hypothesis)
    cHypothesis = hypothesis(i);
    cOverlap = false(length(hypothesis));
    added(i) = true;
    for j = i:length(hypothesis)       
        if(added(j) == false && size(union(cHypothesis, hypothesis(j)) > 0))
           cOverlap(j) = true; 
        end 
    end 
    % Get the number of true elements in cOverlap 
    num_overlap = sum(cOverlap(:));
    % Create a cell array to represent the group of overlapping matrices 
    cOverlapping_hypotheses = cell(num_overlap, 1);
    for 
    end 
    
end 

    