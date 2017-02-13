function segments = generateSegments(image,finaloutput)
testImage = imread(image);
%% Flatten testImage
tic
testImage = rgb2gray(testImage);
imageVec = testImage(:);
disp('loading image ... done')
toc
%% Find points in each segment
% Find unique values in imageVec
% Each segment is represented by a unique numerical value
tic
uniqVal = unique(imageVec);
segments = cell(1,length(uniqVal));
% get image width and height
imageHeight = size(testImage,1);
imageWidth = size(testImage, 2);
for i=1:length(uniqVal)
    % Get all the entries of testImage whose value is uniqVal
    myInd = (testImage == uniqVal(i));
    % Get the x, y coordinates that matches a segment
    [row, col] = find(myInd);
    segments{i} = Segment(0,0,0,0);
    segments{i}.segmentRegion = [row, col];
end
disp('Getting segment regions ... done')
toc
%% Create a list of coordinates
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:), y(:)];
xAll = points(:,1);
yAll = points(:,2);
%% Reshape finaloutput so that it becomes a list of 1x2 cells
tic
finaloutputCopy = finaloutput;
% Indicates where each entry of the finaloutput starts
startIndex = zeros(1,length(finaloutputCopy));
numHypo = 0;
for i = 1:length(finaloutputCopy)
    numHypo = numHypo + size(finaloutputCopy{i},1);
    startIndex(i) = numHypo;
end
disp('Getting start index ... done')
fprintf('Number of hypotheses %d', numHypo); 
toc
%% Generate hypothesis list
tic
% For testing purposes, just let hypoList = finaloutputCopy
% hypoList = cell(1, numHypo);
hypoList = finaloutputCopy;
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
toc
%% Get edges coordinates
tic
edgesCoord = cellfun(@(x) x{1,1}, hypoList, 'UniformOutput', false);
hypoProb = cellfun(@(x) x{1,2}, hypoList, 'UniformOutput', false);
hypoProb = cell2mat(hypoProb);
toc
% for i=1:length(hypoList)
%     edgesCoord{i} = hypoList{i}{1,1};
%     hypoProb(i) = hypoList{i}{1,2};
% end
disp('Getting list coordinates ... done')
%% Determine the hypotheses that overlaps with each segment
for i = 1:length(segments)
    
    fprintf('Calculating %d th segment\n',i);
    cSegment = segments{i};
    xq = cSegment.segmentRegion(:,1);
    yq = cSegment.segmentRegion(:,2);
    % Keep track of whether segment overlaps with hypothesis
    hasOverlap = zeros(1,length(hypoList));
    cHypoX = zeros(1,4);
    cHypoY = zeros(1,4);
    for j = 1:length(hypoList)
%         if(mod(j, 0) == 0)
%             fprintf('Calculating %d th hypo\n',j);
%         end
        for k = 1:4
            % Find vertices of the hypotheses
            cHypoX(k) = edgesCoord{j}(1,2*k-1);
            cHypoY(k) = edgesCoord{j}(2,2*k-1);
        end
        % Find all points that overlaps with hypothesis
        [in, ~] = inpolygon(xq, yq, cHypoX', cHypoY');
        xIn = xq(in);
        yIn = yq(in);
        ind = ismember(xq, xIn) & ismember(yq, yIn);
        % Overlapping region
        overlap = cSegment.segmentRegion(ind,:);
        if(isempty(overlap)==false)
            hasOverlap(j) = 1;
        end
    end
    fprintf('Calculating overlap for %d th segment ... done\n',i); 
    % Return indices of hypotheses that overlaps with the segment
    ind = find(hasOverlap);
%     disp(ind);
    overlappingHypo = edgesCoord(ind);
%     disp(overlappingHypo);
    cSegment.hypothesisEdges = overlappingHypo;
    
%     disp(cSegment);
    
    fprintf('Setting edges for %d th segment ... done\n',i);
    
    %% Find the coordinates contained within each Hypo
    overlappingHypoRegions = cell(1, length(overlappingHypo));
    for j = 1:length(overlappingHypo)
        xv = overlappingHypo{j}(1,[1,3,5,7]);
        yv = overlappingHypo{j}(2,[1,3,5,7]);
        [in, ~] = inpolygon(xAll, yAll,xv',yv');
        xIn = xAll(in);
        yIn = yAll(in);
        inRegion = ismember(xAll, xIn) & ismember(yAll, yIn);
        pointsIn = points(inRegion,:);
        overlappingHypoRegions{j} = pointsIn;
    end
    fprintf('Calculating overlapping hypo for %d th segment ... done\n',i);

    %% Assign hypotheses Probabilities and Regions 
    cSegment.hypothesisRegions = overlappingHypoRegions;
    overlappingHypoProb = hypoProb(ind);
    cSegment.hypothesisProbability = overlappingHypoProb;
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
end

end

