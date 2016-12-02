%Objective: Eliminate Hypotehses have been generated over pool or yard
%areas. 


%(Ratio computed for each hypothesis by accumulating the hue value of the
%pixels inside each rooftop region, after normalizing this ratio by the
%area of the hypothesis, hypothesis with a ratio more than a threshold is
%classified as an outlier and removed from the hypotheses candidate list. 
RGB = imread('test.jpg');
imshow('Norfolk_01_training.tif')
%Convert to double so we don't end up with int values only. (This is not a
%binary problem)
RGBdouble = double(RGB);

%Step 1: Find all pixels within a given hypothesis (use inpolygon?)
%Sample Hypothesis: (Looks familiar?)
hold on
X1=[567,584];
Y1=[1463,1472];
h1 = line(X1,Y1,'color','red','LineWidth',2);
X2=[584,578];
Y2=[1472,1486];
h2 = line(X2,Y2,'color','red','LineWidth',2);
X3=[578,562];
Y3=[1486,1479];
h3 = line(X3,Y3,'color','red','LineWidth',2);
X4=[567,562];
Y4=[1463,1479];
h4 = line(X4,Y4,'color','red','LineWidth',2);
%Loop through all x,y values within the RGB matrix
greenratios = [];
blueratios = []; 
%We've chosen to blue ratio and green ratio independently, only because if
%we combine them in some way (as in GBRatio1) we would lose some important
%information
%**Ratio Computation
%BlueGreenRatio = (RGBdouble(:,:,2) + RGBdouble(:,:,3))./(RGBdouble(:,:,1));
BlueRatio = (RGBdouble(:,:,3)./(RGBdouble(:,:,1)));
GreenRatio = (RGBdouble(:,:,2)./(RGBdouble(:,:,1)));
for i = 1:size(BlueRatio,1); %%Rename if changing metric
    for j = 1:size(BlueRatio,2); %%Rename if changing metric 
        [in] = inpolygon(i,j,hx1,hy1);
        %Check to see if the region we're looking at is within a given hyp.
        if [in] == 1;
            greenratios = [greenratios, GreenRatio(i,j)];
            blueratios = [blueratios, BlueRatio(i,j)];
        end 
    end 
end
%Now we have two lists, one of the list of green ratios (G/R) for each pixel and one of the list of blue ratios (B/R)
%for each pixel. The computation of the ratio can easily be altered in the
%computation section marked ** if another metric is deemd more appropriate.

%Now, for each color we compute some metric representative of the larger segment from which the points 
%come that can be subject to thresholding. In this example we will use the
%independent blue and green data as calculated above: 
%greenratios and blueratios

%avg
avggreenR = mean(greenratios); 
avgblueR = mean(blueratios);
%median
medgreenR = median(greenratios);
medblueR = median(blueratios);
%stdev--produces interesting results :o
stdgreenR = std(greenratios);
stdblueR = median(blueratios); 

%PARAMETERS TO PLAY WITH
%Threshold...need to discuss/test for appropriate values. 
avgthresh = 1.2; %?
medthresh = 1.2; %?
stdthresh = 1.2; %?

%We currently use the 'median' metric, as it's not sensitive to outliers, and seems to describe the 
%hypothesis decently well. However, others can be tried. 

if medgreenR > medthresh;
     val = 0   
else val = 1
end 
if medblueR > medthresh;
    val = 0
else val = 1
end 

%Returns 0 if the value  exceeds the threshold and thus the segmented
%region has enough green or blue to be considered invalid automatically. 
%otherwise returns 1. 