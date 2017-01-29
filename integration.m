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
edgesCoord = {};
% xv are the x coordinates of vertices
% yv are the y coordinates of vertices
xv = zeros(1,4);
yv = zeros(1,4);
% Create a list of coordinates
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:), y(:)];
xq = points(:,1);
yq = points(:,2);
% Get edges coordinates
for i=1:length(finaloutput)
    edgesCoord = finaloutput{i}{1};
    for j = 1:4
        xv(j) = edgesCoord(1, 2*j-1);
        yv(j) = edgesCoord(2, 2*j-1);
    end
end
% Get coordinate of vertices of polygon


% Find all x's and y's in polygon
[in, on] = inpolygon(xq, yq, xv', yv');
xIn = xq(in); % Set of x's in polygon
yIn = yq(in); % Set of y's in polygon
% Find all points in polygon
% A point is in the polygon if both its x and y are in polygon
ind = ismember(points(:,1),xIn) & ismember(points(:,2),yIn);
pointsIn = points(ind,:); % Set of points in polygon
% Create a list of hypothesis
h1 = pointsIn;
h2 = pointsIn(1:floor(length(pointsIn)/2),:);
h3 = pointsIn(1:floor(length(pointsIn)/3),:);
hypothesisRegions = {h1, h2, h3};
segmentRegion = pointsIn;
hypothesisProbability = ones(1,length(hypothesisRegions));
% Create segment and compute the ratios
mySegment = Segment;
mySegment.segmentRegion = segmentRegion;
mySegment.hypothesisRegions = hypothesisRegions;
mySegment.hypothesisProbability = hypothesisProbability;
normalizedRatios = findNormalizedRatio(mySegment);
percentageOverlap = findPercentageOverlap(mySegment);
mySegment = findHighScore(mySegment, normalizedRatios, percentageOverlap);