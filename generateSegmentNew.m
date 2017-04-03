function segments = generateSegmentNew(image, testOutput)
% if nargin < 2
%     input = load('matlab_data/finaloutputFILE.mat')
%     image = 'seg.png';
%     testoutput = input.finaloutput;
% end
hypoList = testOutput;
edgesCoord = cell(1,length(hypoList));
for i = 1:length(hypoList)
    edgesCoord{i} = hypoList{i}{1,1};
end
% hypoProb = cellfun(@(x) x{1,2}, hypoList, 'UniformOutput', false);
% hypoProb = cell2mat(hypoProb);
hypoProb = zeros(1, length(hypoList)); 
for i = 1:length(hypoList) 
    hypoProb(i) = hypoList{i}{1,2};
end 

%% Use convhull
for i = 1:length(hypoList)
    xCoord = edgesCoord{i}(:,[1, 3, 5, 7]);
    
    yCoord = edgesCoord{i}(:,[2, 4, 6, 8]);
    k = convhull(xCoord,yCoord);
%     hold on
%     plot(xCoord(k), yCoord(k), 'LineWidth',3,'Color','r')
    edgesCoord{i} = cat(2, xCoord(k), yCoord(k));
end
%% Flatten test image
testImage = imread(image);
testImage = rgb2gray(testImage);
imageVec = testImage(:);
%% Find points in each segment
uniqVal = unique(imageVec);
segments = cell(1,length(uniqVal));
%% Get image width and height
[imageHeight, imageWidth] = size(testImage);
%% Create a list of coordinates 
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:), y(:)];
xAll = points(:,1);
yAll = points(:,2);
%% Generate empty segments with segment region defined
for i=1:length(uniqVal)
    myInd = (testImage == uniqVal(i));
    [row, col] = find(myInd);
    segments{i} = Segment([row(:),col(:)],{},{},0);
end
% segments = [segments{:}];
[x, y] = meshgrid(1:imageHeight, 1:imageWidth);
points = [x(:),y(:)];
for i = 1:length(segments)
    cSegment = segments{i};
    cRegion = cSegment.segmentRegion; 
    cSegment.hypothesisEdges = cell(1, length(hypoList));
    cSegment.hypothesisRegions = cell(1, length(hypoList));
    cSegment.hypothesisProbability = zeros(1, length(hypoList));
    xq = cSegment.segmentRegion(:,1);
    yq = cSegment.segmentRegion(:,2);
    maxXq = max(xq);
    minXq = min(xq);
    maxYq = max(yq);
    minYq = min(yq);
    for j = 1: length(hypoList)
        cHypoX = edgesCoord{j}(:,1); 
        cHypoY = edgesCoord{j}(:,2); 
        maxX = max(cHypoX);
        minX = min(cHypoX);
        maxY = max(cHypoY);
        minY = min(cHypoY);
        if(~(maxXq < minX || minXq > maxX || maxYq < minY || minYq > maxY))
            [in, ~] = inpolygon(xq, yq, cHypoX', cHypoY');
            overlap = cRegion(in,:); 
            if(~isempty(overlap))
                cSegment.hypothesisEdges{j} = hypoList{j}; 
                in = inpolygon(xAll, yAll, cHypoX(:), cHypoY(:)); 
%                 hold on 
%                 scatter(xAll, yAll);   
%                 plot(cHypoX(:), cHypoY(:));             
%                 hold off 
                pointsIn = points(in,:);
%                 hold on 
%                 scatter(pointsIn(:,1), pointsIn(:,2)); 
%                 hold off 
                cSegment.hypothesisRegions{j} = pointsIn;
                cSegment.hypothesisProbability(j) = hypoProb(j);          
            end
        end
    end 
    % Gets only the nonzero entries
    cSegment.hypothesisRegions = cSegment.hypothesisRegions(~cellfun('isempty',cSegment.hypothesisRegions));
    cSegment.hypothesisEdges = cSegment.hypothesisEdges(~cellfun('isempty', cSegment.hypothesisEdges));
    
    if(isempty(cSegment.hypothesisProbability))
        cSegment.hypothesisProbability = 0;
    else
        [~,~,v] = find(cSegment.hypothesisProbability);
        cSegment.hypothesisProbability = v';
    end
    %% Compute the ratios
    normalizedRatios = findNormalizedRatio(cSegment);
    percentageOverlap = findPercentageOverlap(cSegment);
    [bestHypothesis, highScore] = findHighScore(cSegment, normalizedRatios, percentageOverlap);
    % No longer needs segmentRegion, hypothesisEdges or hypothesisRegions,
    % set them all to empty to free up memory 
    cSegment.segmentRegion = []; 
    cSegment.hypothesisEdges = []; 
    cSegment.hypothesisRegions = [];   
    cSegment.bestHypothesis = bestHypothesis;
    cSegment.highScore = highScore;
    segments{i} = cSegment;
    disp(segments{i})
       
end
end