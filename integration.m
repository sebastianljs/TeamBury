load('SaeediEricJoyceWorkspace.mat')
testImage = imread('test1.png');
% Flatten testImage
testImage = rgb2gray(testImage);
imageVec = testImage(:);
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
% A hypothesis is two pairs of parallel lines perpendicular to each other
% Allocate edges coordinates
% xv are the x coordinates of vertices
% yv are the y coordinates of vertices
xv = zeros(1,4);
yv = zeros(1,4);
% Create a list of coordinates
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:), y(:)];
xAll = points(:,1);
yAll = points(:,2);
% Get edges coordinates
% Loop through hypotheses
% for i=1:length(finaloutput)
%     edgesCoord = finaloutput{i}{1};
%     for j = 1:4
%         xv(j) = edgesCoord(1, 2*j-1);
%         yv(j) = edgesCoord(2, 2*j-1);
%     end
%     hypoProb = finaloutput{i}{2};
%     % Loop through segments
%     for j = 1:length(segments)
%         cSegment = segments{j};
%         xq = cSegment.segmentRegion(:,1);
%         yq = cSegment.segmentRegion(:,2);
%         [in, ~] = inpolygon(xq, yq, xv', yv');
%         xIn = xq(in);
%         yIn = yq(in);
%         ind = ismember(xq, xIn) & ismember(yq, yIn);
%         % Find all points in polygon
%         pointsIn = cSegment.segmentRegion(ind,:);
%         if(isempty(pointsIn)==false)
%             cSegment.hypothesisRegions = {cSegment.hypothesisRegions; pointsIn};
%         end
%     end
% end

edgesCoord = cell(1,length(finaloutput));
hypoProb = zeros(1,length(finaloutput));
for i=1:length(finaloutput)
    edgesCoord{i} = finaloutput{i}{1,1};
    hypoProb(i) = finaloutput{i}{1,2};
end

for i = 1:length(segments)
    cSegment = segments{i};
    xq = cSegment.segmentRegion(:,1);
    yq = cSegment.segmentRegion(:,2);
    % Keep track of whether segment overlaps with hypothesis
    hasOverlap = zeros(1,length(finaloutput));
    cHypoX = zeros(1,4);
    cHypoY = zeros(1,4);
    for j = 1:length(finaloutput)
        for k = 1:4
            % Find vertices of the hypotheses
            cHypoX(k) = edgesCoord{j}(1,2*k-1); % Problem is edgesCoord
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
       
    ind = find(hasOverlap);
    if(isempty(ind)==false)
        overlappingHypo = edgesCoord(ind);
        % TODO: Find the coordinates contained within each Hypo
        overlappingHypoRegions = cell(1, length(overlappingHypo));
        
        for j = 1:length(overlappingHypo)
            xv = overlappingHypo{j}(1,[1,3,5,7]);
            yv = overlappingHypo{j}(2,[1,3,5,7]);
            [in, on] = inpolygon(xAll, yAll,xv',yv');
            xIn = xAll(in);
            yIn = yAll(in);
            inRegion = ismember(xAll, xIn) & ismember(yAll, yIn);
            pointsIn = points(inRegion,:);
            overlappingHypoRegions{j} = pointsIn;          
        end        
        cSegment.hypothesisRegions = overlappingHypoRegions;
        overlappingHypoProb = hypoProb(ind);
        cSegment.hypothesisProbability = overlappingHypoProb;
        % Compute the ratios
        normalizedRatios = findNormalizedRatio(cSegment);
        percentageOverlap = findPercentageOverlap(cSegment);
        highScore = findHighScore(cSegment, normalizedRatios, percentageOverlap);
        cSegment.highScore = highScore;
    end
    
    
end
% Get vertices in each polygon
% Find all x's and y's in polygon
% [in, on] = inpolygon(xq, yq, xv', yv');
% xIn = xq(in); % Set of x's in polygon
% yIn = yq(in); % Set of y's in polygon
% % Find all points in polygon
% % A point is in the polygon if both its x and y are in polygon
% ind = ismember(points(:,1),xIn) & ismember(points(:,2),yIn);
% pointsIn = points(ind,:); % Set of points in polygon
% % Create a list of hypothesis
% h1 = pointsIn;
% h2 = pointsIn(1:floor(length(pointsIn)/2),:);
% h3 = pointsIn(1:floor(length(pointsIn)/3),:);
% hypothesisRegions = {h1, h2, h3};
% segmentRegion = pointsIn;
% hypothesisProbability = ones(1,length(hypothesisRegions));
%

% Create segment and compute the ratios
% mySegment = Segment;
% mySegment.segmentRegion = segmentRegion;
% mySegment.hypothesisRegions = hypothesisRegions;
% mySegment.hypothesisProbability = hypothesisProbability;
% normalizedRatios = findNormalizedRatio(mySegment);
% percentageOverlap = findPercentageOverlap(mySegment);
% mySegment = findHighScore(mySegment, normalizedRatios, percentageOverlap);