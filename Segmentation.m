%% Segmentation.m 

% Psuedocode 

% Each image is considered a region corresponding to a node v in the overall
% image graph G(V, E)

% Neighboring pixels are connected by undirected edges, for eachedge a
% weight coefficient is computed according to dissimilarities between
% pixels (suggestion: normxcorr2) 

% Dif(A,B) minimum weight between a pixel and all neighboring pixels are

% Int(A) is the largest weight in the MST of region A 
% Int(B) is the largest weight in the MST of region B 

% tau(A) = k/|A| where k is the sensitivity level 

% Regions are merged when Dif(A,B) <= min(Int(A) + tau(A), Int(B) + tau(B))

% graphminspantree 



