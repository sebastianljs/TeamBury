%Initilize the workspace
clear;
% load the result mat file
input = load('globalResult.mat');
matrix = input.nOverlapFinal;
newmatrix = matrix(:);
% load the testlabels
input2 = load('test_labels.mat');
truelabels = input2.test_labels;
newtruelabels = truelabels(:);
% convert a matrix to array
size1 = size(matrix,1);
size2 = size(matrix,2);
npixels = size1*size2;
%reshape(matrix',npixels,1);
%reshape(truelabels',npixels,1);
% create a new object
a = Result2(newmatrix,newtruelabels);
% call the methods to calculate ROC curve and PR curve
a.calculateRoc();
a.calculatePR();
figure(1)
a.plotRoc();
figure(2)
a.plotPr();

 