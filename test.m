% numHypo = 0; 
% for i=1:length(finaloutput) 
%     numHypo = numHypo + length(finaloutput{i});
%     
% end 
% hypoList = cell(1, numHypo);
% 
% for i=1:length(hypoList)
%     cCell = {}; 
%     for j=1:length(finaloutput)
%         cCell = finaloutput{j}; 
%         for k=1:length(cCell)
%             hypoList{i} = cCell;
%         end
%         i = i + length(cCell);
%     end 
% end 

% Test function 
finaloutputCopy = finaloutput;
numHypo = 0; 
% Indicates where each entry of the finaloutput starts 
startIndex = zeros(1,length(finaloutputCopy));
for i = 1:length(finaloutputCopy)
    numHypo = numHypo + size(finaloutputCopy{i},1);  
    startIndex(i) = numHypo;
end 
hypoList = cell(1, numHypo); 

% Use startindex might work 

for i=startIndex
    cCell = {};
    for j=1:length(finaloutputCopy)
        cCell = finaloutputCopy{j};
        for k = 1:size(cCell,1)
            hypoList{i+k-1} = cCell(k,:); 
        end       
    end 
end