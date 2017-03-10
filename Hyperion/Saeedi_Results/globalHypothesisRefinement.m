 % globalHypothesisRefinement.m
% test1Segments = generateSegmentNew('seg.png', testoutput);
% test2Segments = generateSegmentNew('seg3.png', testoutput);
% test3Segments = generateSegmentNew('seg3new.png', testoutput);
% test4Segments = generateSegmentNew('seg4new.png', testoutput); 
% Select best hypotheses for each image 
load pic1_array;
load pic2_array;
load pic3_array;
load pic4_array;

picResults = {test1Array, test2Array, test3Array, test4Array}; 
bestHypoList = cell(1, length(picResults)); 
for i = 1:length(picResults)   
    cArray = picResults{i}; 
    tempList = cell(1, length(cArray)); 
    for j = 1:length(cArray)
        cBestHypothesis = cArray(j).bestHypothesis; 
        if(isempty(cBestHypothesis))
            % Pad with zeros if cell is empty 
            tempList(j) = {zeros(2,8)};
        else
            tempList(j) = {cBestHypothesis{1,1}{1}}; 
        end
    end
    bestHypoList{i} = tempList; 
    
end 
clear('picResults'); 
% Load image 
testImage = imread('seg.png');
testImage = rgb2gray(testImage); 
[height, width] = size(testImage);  
%% Create a list of coordinates 
[x,y] = meshgrid(1:height, 1:width); 
points = [x(:), y(:)]; 
xAll = points(:,1);
yAll = points(:,2); 
picMat = zeros(length(xAll),1); 
for i = 1:length(bestHypoList) 
    % This matrix contains 
    cHypoList = bestHypoList{i}; 
    cMat = zeros(length(xAll),length(cHypoList)); 
    for j = 1:length(cHypoList)
        cXCoords = cHypoList{j}(:,[1, 3, 5, 7]); 
        cYCoords = cHypoList{j}(:,[2, 4, 6, 8]);
        if(sum(cHypoList{j}) ~= 0)
            k = convhull(cXCoords, cYCoords);
            cXCoords = cXCoords(k); 
            cYCoords = cYCoords(k); 
            [in, ~] = inpolygon(xAll, yAll, cXCoords(:), cYCoords(:)); 
            cMat(:,j) = in; 
        else 
            cMat(:,j) = 0; 
        end      
    end 
    cMatSum = sum(cMat, 2); 
    picMat = picMat + cMatSum; 
end 
picMat = reshape(picMat, [height, width]); 
save('finalGlobalResult.mat','picMat'); 
% Get all x coordinates of vertices of hypothesis edges 
% xCoord1 = cellfun(@(x) x{1}(1, :), bestHypoList1, 'UniformOutput', false);
% xCoord2 = cellfun(@(x) x{1}(1, :), bestHypoList2, 'UniformOutput', false); 
% xCoord3 = cellfun(@(x) x{1}(1, :), bestHypoList3, 'UniformOutput', false); 
% xCoord4 = cellfun(@(x) x{1}(1, :), bestHypoList4, 'UniformOutput', false);

% Get all y coordinates of vertices of hypothesis edges 
% yCoord1 = cellfun(@(x) x{1}(2, :), bestHypoList1, 'UniformOutput', false);
% yCoord2 = cellfun(@(x) x{1}(2, :), bestHypoList2, 'UniformOutput', false); 
% yCoord3 = cellfun(@(x) x{1}(2, :), bestHypoList3, 'UniformOutput', false); 
% yCoord4 = cellfun(@(x) x{1}(2, :), bestHypoList4, 'UniformOutput', false); 
% 
% % Check if each point is in polygon using inpolygon 
% pointsInPolygon1 = cellfun(@(x,y) inpolygon(xAll, yAll, x', y'), xCoord1, yCoord1, 'UniformOutput', false);
% pointsInPolygon2 = cellfun(@(x,y) inpolygon(xAll, yAll, x', y'), xCoord2, yCoord2, 'UniformOutput', false);
% pointsInPolygon3 = cellfun(@(x,y) inpolygon(xAll, yAll, x', y'), xCoord3, yCoord3, 'UniformOutput', false);
% pointsInPolygon4 = cellfun(@(x,y) inpolygon(xAll, yAll, x', y'), xCoord4, yCoord4, 'UniformOutput', false);
% % Convert cell array to matrix & sum up each row to get the number of
% % hypotheses that contains the point 
% % 1st Threshold 
% pointsInPolygon1 = cell2mat(pointsInPolygon1);
% nOverlapHypo1 = sum(pointsInPolygon1,2);
% nOverlapHypo1 = reshape(nOverlapHypo1, [height, width]);
% % 2nd Threshold
% pointsInPolygon2 = cell2mat(pointsInPolygon2);
% nOverlapHypo2 = sum(pointsInPolygon2,2);
% nOverlapHypo2 = reshape(nOverlapHypo2, [height, width]);
% % 3rd Threshold
% pointsInPolygon3 = cell2mat(pointsInPolygon3);
% nOverlapHypo3 = sum(pointsInPolygon1,2);
% nOverlapHypo3 = reshape(nOverlapHypo3, [height, width]);
% % 4th Threshold
% pointsInPolygon4 = cell2mat(pointsInPolygon4);
% nOverlapHypo4 = sum(pointsInPolygon4,2);
% nOverlapHypo4 = reshape(nOverlapHypo4, [height, width]);
% 
% % Creates a map depicting how many hypothesis covers a particular point 
% nOverlapFinal = nOverlapHypo1 + nOverlapHypo2 + nOverlapHypo3 + nOverlapHypo4;
