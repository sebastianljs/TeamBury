load('SaeediEricJoyceWorkspace.mat')
testImage = imread('test1.png');

% A hypothesis is two pairs of parallel lines perpendicular to each other
% Edge of length d 
imageHeight = size(testImage,1);
imageWidth = size(testImage, 2); 
d = 3; 
% Example edge coordinates
edgesCoord = [0 0 0 d d d d 0; 0 d d d d 0 0 0];            
% xv are the x coordinates of vertices
% yv are the y coordinates of vertices 
% Get coordinate of vertices of polygon
xv = zeros(1,4); 
yv = zeros(1,4); 
for i = 1:4
    xv(i) = edgesCoord(1, 2*i-1);
    yv(i) = edgesCoord(2, 2*i-1); 
end 
% Find all x's and y's in polygon
% Create a list of coordinates
[x, y] = meshgrid(xq, yq);
points = [x(:), y(:)];
xq = points(:,1);
yq = points(:,2); 
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