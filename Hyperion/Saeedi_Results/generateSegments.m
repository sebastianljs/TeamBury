function segments = generateSegments(image,finaloutput)
hypoList = finaloutput;
testImage = imread(image);
%% Flatten testImage
testImage = rgb2gray(testImage);
imageVec = testImage(:);
disp('loading image ... done')
%% Find points in each segment
% Find unique values in imageVec
% Each segment is represented by a unique numerical value
uniqVal = unique(imageVec);
segments = cell(1,length(uniqVal));
% get image width and height
imageHeight = size(testImage,1);
imageWidth = size(testImage, 2);
for i=1:length(uniqVal)
    % Get all the entries of testImage whose value is uniqVal
    myInd = (testImage == uniqVal(i));
    % Get the x, y coordinates that matches a segment
%     imshow(myInd); 
    [row, col] = find(myInd);
    segments{i} = Segment([],{},{},0);
    segments{i}.segmentRegion = [row, col];
end
disp(segments{1});
disp('Getting segment regions ... done')
toc
%% Create a list of coordinates
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:), y(:)];
xAll = points(:,1);
yAll = points(:,2);
%% Reshape finaloutput so that it becomes a list of 1x2 cells
tic
% finaloutputCopy = finaloutput;
% Indicates where each entry of the finaloutput starts
% startIndex = zeros(1,length(finaloutputCopy));
% numHypo = 0;
% for i = 1:length(finaloutputCopy)
%     numHypo = numHypo + size(finaloutputCopy{i},1);
%     startIndex(i) = numHypo;
% end
% disp('Getting start index ... done')
% fprintf('Number of hypotheses %d', numHypo);
% toc
%% Generate hypothesis list
tic
% For testing purposes, just let hypoList = finaloutputCopy
% hypoList = cell(1, numHypo);

% for i=startIndex
%      if(mod(i,30)==0)
%         fprintf('Generating hypoList for %d th segment\n',i);
%     end
%     for j=1:length(finaloutputCopy)
%         cCell = finaloutputCopy{j};
%         for k = 1:size(cCell,1)
%             hypoList{i+k-1} = cCell(k,:);
%         end
%     end
% end
disp('Generating hypothesis list ... done')

%% Get edges coordinates

edgesCoord = cellfun(@(x) x{1,1}, hypoList, 'UniformOutput', false);
[xClose, yClose] = cellfun(@(x) closePolygonParts(x(1,:),x(2,:)), edgesCoord, 'UniformOutput', false); 

hypoProb = cellfun(@(x) x{1,2}, hypoList, 'UniformOutput', false);
hypoProb = cell2mat(hypoProb);
% for i=1:length(hypoList)
%     edgesCoord{i} = hypoList{i}{1,1};
%     hypoProb(i) = hypoList{i}{1,2};
% end
disp('Getting list coordinates ... done')
%% Determine the hypotheses that overlaps with each segment
for i = 1:length(segments)
    
    fprintf('Calculating %d th segment\n',i);
    cSegment = segments{i};
    cSegment.hypothesisEdges = cell(1, length(hypoList));
    cSegment.hypothesisRegions = cell(1, length(hypoList));
    cSegment.hypothesisProbability = zeros(1, length(hypoList));
    xq = cSegment.segmentRegion(:,1);
    yq = cSegment.segmentRegion(:,2);
    maxXq = max(xq);
    minXq = min(xq);
    maxYq = max(yq);
    minYq = min(yq);
    % Keep track of whether segment overlaps with hypothesis
    %     hasOverlap = zeros(1,length(hypoList));
    for j = 1:length(hypoList)
        % Find vertices of the hypotheses  
        cHypoX = edgesCoord{j}(1,:);
        cHypoY= edgesCoord{j}(2,:);
        plot(cHypoX,cHypoY,'LineWidth',3,'Color','r');
        maxX = max(cHypoX);
        minX = min(cHypoX);
        maxY = max(cHypoY);
        minY = min(cHypoY);
        
        % Find all points that overlaps with hypothesis
        % Meshgrid is computationally expensive, fix
        if(~(maxXq < minX || minXq > maxX || maxYq < minY || minYq > maxY))   
%             [x, y] = meshgrid(minX:maxX, minY:maxY);
%             toc
%             % Create a grid that contains the hypothesis
%              points = [x(:), y(:)];
%             toc 
            %         % Subsets the hypothesis points to a square
            %         rowInd = ismember(cSegment.segmentRegion, points, 'rows');
            [in, ~] = inpolygon(xq, yq, cHypoX', cHypoY');
            % Overlapping region
            overlap = cRegion(in,:);
            if(isempty(overlap)==false)
                cSegment.hypothesisEdges{j} = hypoList{j};            
                in = inpolygon(xAll, yAll, cHypoX', cHypoY');
                imshow(in);
                pointsIn = points(in,:);
                cSegment.hypothesisRegions{j} = pointsIn;
                cSegment.hypothesisProbability(j) = hypoProb(j);
            end
        end 
    end
    % Gets only the nonzero entries
    cSegment.hypothesisRegions = cSegment.hypothesisRegions(~cellfun('isempty',cSegment.hypothesisRegions));
    cSegment.hypothesisProbability = cSegment.hypothesisEdges(~cellfun('isempty', cSegment.hypothesisEdges));
    
    if(isempty(cSegment.hypothesisProbability))
        cSegment.hypothesisProbability = 0;
    else
        [~,~,v] = find(cSegment.hypothesisProbability);
        cSegment.hypothesisProbability = v';
    end
    fprintf('Calculating overlap for %d th segment ... done\n',i);
    % Return indices of hypotheses that overlaps with the segment
    %     ind = find(hasOverlap);
    % %     disp(ind);
    %     overlappingHypo = edgesCoord(ind);
    % %     disp(overlappingHypo);
    %     cSegment.hypothesisEdges = overlappingHypo;
    
    %     disp(cSegment.hypothesisEdges);
    
    fprintf('Setting edges for %d th segment ... done\n',i);
    
    %% Find the coordinates contained within each Hypo
    %     overlappingHypoRegions = cell(1, length(overlappingHypo));
    %     for j = 1:length(overlappingHypo)
    %         xv = overlappingHypo{j}(1,:);
    %         yv = overlappingHypo{j}(2,:);
    %         [in, ~] = inpolygon(xAll, yAll,xv',yv');
    %         pointsIn = points(in,:);
    %         overlappingHypoRegions{j} = pointsIn;
    %     end
    %     fprintf('Calculating overlapping hypo for %d th segment ... done\n',i);
    
    %% Assign hypotheses Probabilities and Regions
    %     cSegment.hypothesisRegions = overlappingHypoRegions;
    %     overlappingHypoProb = hypoProb(ind);
    %     cSegment.hypothesisProbability = overlappingHypoProb;
    %% Compute the ratios
    normalizedRatios = findNormalizedRatio(cSegment);
    percentageOverlap = findPercentageOverlap(cSegment);
    [bestHypothesis, highScore] = findHighScore(cSegment, normalizedRatios, percentageOverlap);
    %     disp(bestHypothesis)
    %     disp(highScore)
    cSegment.bestHypothesis = bestHypothesis;
    cSegment.highScore = highScore;
    fprintf('Calculating ratio for %d th segment ... done\n',i);
    segments{i} = cSegment;
    disp(segments{i})

end
    save('testSegment.mat', 'segments');
end

