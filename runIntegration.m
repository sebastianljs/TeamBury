load('SaeediEricJoyceWorkspace.mat')
test1Segments = generateSegments('test1.png', finaloutput);
save('test1Segments.mat','test1Segments'); 
test2Segments = generateSegments('test2.png', finaloutput);
save('test2Segments.mat','test2Segments'); 
test3Segments = generateSegments('test3.png', finaloutput);
save('test3Segments.mat','test3Segments'); 
test4Segments = generateSegments('test4.png', finaloutput);
save('test4Segments.mat','test4Segments'); 
