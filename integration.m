load('SaeediEricJoyceWorkspace.mat')
test1Segments = generateSegments('test1.png');
test2Segments = generateSegments('test2.png');
test3Segments = generateSegments('test3.png');
test4Segments = generateSegments('test4.png');

function segments = generateSegments(image)
testImage = imread(image);
%% Flatten testImage
testImage = rgb2gray(testImage);
imageVec = testImage(:);

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
    [row, col] = find(myInd);
    segments{i} = Segment;
    segments{i}.segmentRegion = [row, col];
end
%% Create a list of coordinates
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:), y(:)];
xAll = points(:,1);
yAll = points(:,2);

%% Reshape finaloutput so that it becomes a list of 1x2 cells

finaloutputCopy = finaloutput;
numHypo = 0;
% Indicates where each entry of the finaloutput starts
startIndex = zeros(1,length(finaloutputCopy));
for i = 1:length(finaloutputCopy)
    numHypo = numHypo + size(finaloutputCopy{i},1);
    startIndex(i) = numHypo;
end

% hypoList is a list of 1x2 cells
hypoList = cell(1, numHypo);

for i=startIndex
    for j=1:length(finaloutputCopy)
        cCell = finaloutputCopy{j};
        for k = 1:size(cCell,1)
            hypoList{i+k-1} = cCell(k,:);
        end
    end
end
%% Get edges coordinates
edgesCoord = cell(1,length(hypoList));
hypoProb = zeros(1,length(hypoList));
for i=1:length(hypoList)
    edgesCoord{i} = hypoList{i}{1,1};
    hypoProb(i) = hypoList{i}{1,2};
end
%% Determine the hypotheses that overlaps with each segment
for i = 1:length(segments)
    cSegment = segments{i};
    xq = cSegment.segmentRegion(:,1);
    yq = cSegment.segmentRegion(:,2);
    % Keep track of whether segment overlaps with hypothesis
    hasOverlap = zeros(1,length(hypoList));
    cHypoX = zeros(1,4);
    cHypoY = zeros(1,4);
    for j = 1:length(hypoList)
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
    % Return indices of hypotheses that overlaps with the segment
    ind = find(hasOverlap);
    overlappingHypo = edgesCoord(ind);
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
    cSegment.hypothesisRegions = overlappingHypoRegions;
    overlappingHypoProb = hypoProb(ind);
    cSegment.hypothesisProbability = overlappingHypoProb;
    %% Compute the ratios
    normalizedRatios = findNormalizedRatio(cSegment);
    percentageOverlap = findPercentageOverlap(cSegment);
    highScore = findHighScore(cSegment, normalizedRatios, percentageOverlap);
    cSegment.highScore = highScore;
end

end

