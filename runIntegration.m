clear; 
load('matlab_data/finaloutputFILE.mat')
test1Segments = generateSegments('seg.png', finaloutput);
test2Segments = generateSegments('seg3.png', finaloutput);
test3Segments = generateSegments('seg3new.png', finaloutput);
test4Segments = generateSegments('seg4new.png', finaloutput);
save('integrationResults.mat');
