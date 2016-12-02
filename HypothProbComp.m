%This is Eric Peshkin's super swell Building Hypothesis Code. Welcome. I have
%updated the comments so they should be more descriptive. Also, the very
%last step may change substantially depending on how one interprets
%Saeedi's code. I will be checking this in class tomorrow and then changing
%or not changing it afterwards, appropriately.

%Inputs are a list of X1...X4 and Y1...Y4 as building hypotheses where each
%XN = [xn1 , xn2] and each YN = [yn1 , yn2]
%Random lines are of the form [[xk1,xk2;yk1,yk2],[x(k+1)1,x(k+1)2;y(k+1)1,y(k+2)2]...]
%(see linecell in code for an example of the other lines format)

%Output is explained in comment at bottom of code.

%VARIABLES TO TINKER WITH:
tuberad = 0.15; %The radius of the tubes (also determines the parallel "height beyond lines"
mintheta = 15; %The value of degrees for which all relevant 'other' lines must be within relative to the 'hypothesis' line in question.

%Generate sample hypotheses. We want 4. This is for the sake of testing
%things.
%Hypothesis:
X1=[1,1.5];
Y1=[1,7];
h1 = line(X1,Y1,'color','red');
X2=[1.5,4];
Y2=[7,7];
h2 = line(X2,Y2,'color','red');
X3=[4,4];
Y3=[1.5,7];
h3 = line(X3,Y3,'color','red');
X4=[1,4];
Y4=[1,1.5];
h4 = line(X4,Y4,'color','red');

%Other Lines:
X100=[0.5,2];
Y100=[2,6];
r100 = line(X100,Y100);
X101=[0,7];
Y101=[0,8];
r101 = line(X101,Y101);
X102=[1.6,3.9];
Y102=[6.9,6.9];
r102 = line(X102,Y102);
X103=[3.95,4.1];
Y103=[5,5.1];
r103 = line(X103,Y103);
X104=[2,3];
Y104=[5,4];
r104 = line(X104,Y104);
X105=[1.5,2.5];
Y105=[6,5];
r105 = line(X105,Y105);
X106=[3,4];
Y106=[2,3];
r106 = line(X106,Y106);
%Note: "Hypothesis" is in red. "Non-hypothesis" lines are in blue. 
%Note: for these purposes, 0-99 are hypotheses, 100-199 are random lines, 200+ are tubes. 

%STEP 1: Tube Creation. Tube is in green. Want a tube for every line in
%hypothesis. 
%Tube 1: Left Side TOTALLY TUBULAR!
hold on
tx1 = [X1(2)+tuberad,X1(1)+tuberad,X1(1)-tuberad,X1(2)-tuberad,X1(2)+tuberad,X1(1)+tuberad];
ty1 = [Y1(2)+tuberad,Y1(1)-tuberad,Y1(1)-tuberad,Y1(2)+tuberad,Y1(2)+tuberad,Y1(1)-tuberad];
plot(tx1,ty1,'.-','color','green')
%Tube 2: Top Side TUBULAR MY MAN! (Top - Bot = pos)
tx2 = [X2(1)-tuberad,X2(2)+tuberad,X2(2)+tuberad,X2(1)-tuberad,X2(1)-tuberad,X2(2)+tuberad];
ty2 = [Y2(1)+tuberad,Y2(2)+tuberad,Y2(2)-tuberad,Y2(1)-tuberad,Y2(1)+tuberad,Y2(2)+tuberad];
plot(tx2,ty2,'.-','color','green')
%Tube 3: Right Side TUBULAR DUDE! (Top - Bot = pos)
tx3 = [X3(1)+tuberad,X3(2)+tuberad,X3(2)-tuberad,X3(1)-tuberad,X3(1)+tuberad,X3(2)+tuberad];
ty3 = [Y3(1)-tuberad,Y3(2)+tuberad,Y3(2)+tuberad,Y3(1)-tuberad,Y3(1)-tuberad,Y3(2)+tuberad];
plot(tx3,ty3,'.-','color','green')
%Tube 4: Bottom Side TUBULAR BRO! (Top - Bot = positive)
tx4 = [X4(1)-tuberad,X4(2)+tuberad,X4(2)+tuberad,X4(1)-tuberad,X4(1)-tuberad,X4(2)+tuberad];
ty4 = [Y4(1)+tuberad,Y4(2)+tuberad,Y4(2)-tuberad,Y4(1)-tuberad,Y4(1)+tuberad,Y4(2)+tuberad];
plot(tx4,ty4,'.-','color','green')

%STEP 2: Find all lines that are fully or partially within the tubes. (From
%the set of III-A-5
%(use inpolygon to determine whether both endpoints are in the tube)

%Check all lines for interior of Tube 1:

%Linelist is list of suspect lines. Currently as [[x1,x2;y1,y2]]
linelist = [[0.5,2;2,6],[0,7;0,8],[1.6,3.9;6.9,6.9],[3.95,4.1;5,5.1],[2,3;5,4],[1.5,2.5;6,5],[3,4;2,3]];
linecell = cell(length(linelist)/2,1);
for i = 1:(length(linelist)/2);
    linecell{i,1} = linelist(4*i-3:4*i);
end
Tube1Array = [];
Tube2Array = [];
Tube3Array = [];
Tube4Array = [];
for k = linelist;
    [in] = inpolygon(k(1),k(2),tx1,ty1);
    Tube1Array = cat(1,Tube1Array,[in]);
end
for k = linelist;
    [in] = inpolygon(k(1),k(2),tx2,ty2);
    Tube2Array = cat(1,Tube2Array,[in]);
end
for k = linelist;
    [in] = inpolygon(k(1),k(2),tx3,ty3);
    Tube3Array = cat(1,Tube3Array,[in]);
end
for k = linelist;
    [in] = inpolygon(k(1),k(2),tx4,ty4);
    Tube4Array = cat(1,Tube4Array,[in]);
end
%TubeNArray is a vertical matrix for which every row corresponds to a
%point for tube 1:N. Every second row begins a new "line". 
%Let's split this into 7 2x1 doubles, each of which contains a single "line's" validity info.
Tube1Lines = mat2cell(Tube1Array,zeros(1,(size(Tube1Array,1)/2))+2,[1]);
Tube2Lines = mat2cell(Tube2Array,zeros(1,(size(Tube2Array,1)/2))+2,[1]);
Tube3Lines = mat2cell(Tube3Array,zeros(1,(size(Tube3Array,1)/2))+2,[1]);
Tube4Lines = mat2cell(Tube4Array,zeros(1,(size(Tube4Array,1)/2))+2,[1]);

%Now we will seperate any lines that "fit" (or one pt in the line is in the
%polygon, to check for the entire line in polygon switch to [0;0] on all.)
%The process will be carried out for each line one at a time from now on.
%Tube 1:
count = 0;
for k = 1:length(Tube1Lines);
    if cell2mat(Tube1Lines(k)) == [1;1]; %%%%%%
        %counter variable to determine size of the chosen lines cell.
        count = count+1;
    end
    
end
chosenlinescell = cell(count,1);
count2 = 1;
for k = 1:length(Tube1Lines);
    if cell2mat(Tube1Lines(k)) == [1;1];
        %select the matrices of lines information such that they are within
        %the tubes
        tubelinecoords = vec2mat(cell2mat(linecell(k)),2);
        chosenlinescell{count2,1} = tubelinecoords;
        count2 = count2 + 1;
    end
end

%Now we have a cell array that contains the matrices of every [x1,x2;y1,y2]
%line that is within each tube for Tube 1 in chosenlinescell. 


%(Still for tube 1, can copy-paste or try to automate in some complicated
%way. Consider both, even if just for learning value)
%STEP 3: Remove lines with an orientation difference from the side higher
%than 15%
%Remember hypothesis is X1,Y1. 
for k = 1:length(chosenlinescell);
    hypothline = cell2mat(chosenlinescell(k));
    linepointA = hypothline(1:2);
    linepointB = hypothline(3:4); 
    randlinevec = (linepointB - linepointA);     
    x1y1 = [X1(1),Y1(1)];
    x2y2 = [X1(2),Y1(2)];
    hypothvec = (x2y2-x1y1);
    dotp = dot(randlinevec,hypothvec);
    magA = norm(randlinevec);
    magB = norm(hypothvec);
    costheta = dotp/(magA * magB);
    thetarads = acos(costheta);
    thetadeg = thetarads * (180/pi);
    %Now we have our angle in degrees.
    %Let's remove the vectors that are more than 15 degrees different
    if thetadeg > mintheta;
        if thetadeg < 360-mintheta; 
        chosenlinescell{k,1} = NaN;  
        %Now anywhere this was true, the chosenlines cell contains NaN
        end 
    end 
end
%STEP 4: Now we project each selected line on the "closest side of the
%hypothesis," which based on how this code is written is already determined.
projectorcell1 = chosenlinescell;
scorecelltube1 = projectorcell1;
for k = 1:length(chosenlinescell);
    if isnan(chosenlinescell{k}) == 0;
        hypothline = cell2mat(chosenlinescell(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);
        x1y1 = [X1(1),Y1(1)];
        x2y2 = [X1(2),Y1(2)];
        hypothvec = (x2y2-x1y1);
        %Project randlinevec onto hypothvec.
        projection =(dot(randlinevec,hypothvec)/norm(hypothvec)^2)*hypothvec;
        %Create a cell to keep the projection information in for ease of
        %access. This may never be called again, idk. 
        projectorcell1{k} = projection;
        %STEP 5: Calculate normalized coverage due to line projection.
        normedcov = norm(projection)/norm(hypothvec);
        if normedcov > 1;
            %Adjust for the fact some lines may be far beyond the boundary
            %of our hypothesis and they don't deserve a higher score.
            normedcov = normedcov^-1;
        end 
        %Scorecell contains the normalized projection scores and NaN's
        %where a line was not utilized because it did not fit criteria. 
       	scorecelltube1{k} = normedcov;    
    end 
end 

%TUBE 2
count = 0;
for k = 1:length(Tube2Lines);
    if cell2mat(Tube2Lines(k)) == [1;1]; 
        %counter variable to determine size of the chosen lines cell.
        count = count+1;

    end 
end
chosenlinescell2 = cell(count,1);
count2 = 1;
for k = 1:length(Tube2Lines);
    if cell2mat(Tube2Lines(k)) == [1;1];
        %select the matrices of lines information such that they are within
        %the tubes
        tubelinecoords = vec2mat(cell2mat(linecell(k)),2);
        chosenlinescell2{count2,1} = tubelinecoords;
        count2 = count2 + 1;
    end
end

%Now we have a cell array that contains the matrices of every [x1,x2;y1,y2]
%line that is within each tube for Tube 2 in chosenlinescell. 

%STEP 3: Remove lines with an orientation difference from the side higher
%than 15%
%Remember hypothesis is X1,Y1. 
for k = 1:length(chosenlinescell2);
    hypothline = cell2mat(chosenlinescell2(k));
    linepointA = hypothline(1:2);
    linepointB = hypothline(3:4); 
    randlinevec = (linepointB - linepointA);     
    x1y1 = [X1(1),Y1(1)];
    x2y2 = [X1(2),Y1(2)];
    hypothvec = (x2y2-x1y1);
    dotp = dot(randlinevec,hypothvec);
    magA = norm(randlinevec);
    magB = norm(hypothvec);
    costheta = dotp/(magA * magB);
    thetarads = acos(costheta);
    thetadeg = thetarads * (180/pi);
    %Now we have our angle in degrees.
    %Let's remove the vectors that are more than 15 degrees different
    if thetadeg > mintheta;
        if thetadeg < 360-mintheta; 
        chosenlinescell2{k,1} = NaN;  
        %Now anywhere this was true, the chosenlines cell contains NaN
        end 
    end 
end
%STEP 4: Now we project each selected line on the "closest side of the
%hypothesis," which based on how this code is written is already determined.
projectorcell2 = chosenlinescell2;
scorecelltube2 = projectorcell2;
for k = 1:length(chosenlinescell2);
    if isnan(chosenlinescell2{k}) == 0;
        hypothline = cell2mat(chosenlinescell2(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);
        x1y1 = [X1(1),Y1(1)];
        x2y2 = [X1(2),Y1(2)];
        hypothvec = (x2y2-x1y1);
        %Project randlinevec onto hypothvec.
        projection =(dot(randlinevec,hypothvec)/norm(hypothvec)^2)*hypothvec;
        %Create a cell to keep the projection information in for ease of
        %access. This may never be called again, idk. 
        projectorcell2{k} = projection;
        %STEP 5: Calculate normalized coverage due to line projection.
        normedcov = norm(projection)/norm(hypothvec);
        if normedcov > 1;
            %Adjust for the fact some lines may be far beyond the boundary
            %of our hypothesis and they don't deserve a higher score.
            normedcov = normedcov^-1;
        end 
        %Scorecell contains the normalized projection scores and NaN's
        %where a line was not utilized because it did not fit criteria. 
       	scorecelltube2{k} = normedcov;    
    end 
end 
%Tube 3
count = 0;
for k = 1:length(Tube3Lines);
    if cell2mat(Tube3Lines(k)) == [1;1]; %COULDN'T GET "OR" "|" OPERATOR TO WORK!!!!!
        %counter variable to determine size of the chosen lines cell.
        count = count+1;
    end
end
chosenlinescell3 = cell(count,1);
count2 = 1;
for k = 1:length(Tube3Lines);
    if cell2mat(Tube3Lines(k)) == [1;1];
        %select the matrices of lines information such that they are within
        %the tubes
        tubelinecoords = vec2mat(cell2mat(linecell(k)),2);
        chosenlinescell3{count2,1} = tubelinecoords;
        count2 = count2 + 1;
    end
end

%Now we have a cell array that contains the matrices of every [x1,x2;y1,y2]
%line that is within each tube for Tube 1 in chosenlinescell. 


%(Still for tube 1, can copy-paste or try to automate in some complicated
%way. Consider both, even if just for learning value)
%STEP 3: Remove lines with an orientation difference from the side higher
%than 15%
%Remember hypothesis is X1,Y1. 
for k = 1:length(chosenlinescell3);
    hypothline = cell2mat(chosenlinescell3(k));
    linepointA = hypothline(1:2);
    linepointB = hypothline(3:4); 
    randlinevec = (linepointB - linepointA);     
    x1y1 = [X1(1),Y1(1)];
    x2y2 = [X1(2),Y1(2)];
    hypothvec = (x2y2-x1y1);
    dotp = dot(randlinevec,hypothvec);
    magA = norm(randlinevec);
    magB = norm(hypothvec);
    costheta = dotp/(magA * magB);
    thetarads = acos(costheta);
    thetadeg = thetarads * (180/pi);
    %Now we have our angle in degrees.
    %Let's remove the vectors that are more than 15 degrees different
    if thetadeg > mintheta;
        if thetadeg < 360-mintheta; 
        chosenlinescell3{k,1} = NaN;  
        %Now anywhere this was true, the chosenlines cell contains NaN
        end 
    end 
end
%STEP 4: Now we project each selected line on the "closest side of the
%hypothesis," which based on how this code is written is already determined.
projectorcell3 = chosenlinescell3;
scorecelltube3 = projectorcell3;
for k = 1:length(chosenlinescell3);
    if isnan(chosenlinescell3{k}) == 0;
        hypothline = cell2mat(chosenlinescell3(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);
        x1y1 = [X1(1),Y1(1)];
        x2y2 = [X1(2),Y1(2)];
        hypothvec = (x2y2-x1y1);
        %Project randlinevec onto hypothvec.
        projection =(dot(randlinevec,hypothvec)/norm(hypothvec)^2)*hypothvec;
        %Create a cell to keep the projection information in for ease of
        %access. This may never be called again, idk. 
        projectorcell3{k} = projection;
        %STEP 5: Calculate normalized coverage due to line projection.
        normedcov = norm(projection)/norm(hypothvec);
        if normedcov > 1;
            %Adjust for the fact some lines may be far beyond the boundary
            %of our hypothesis and they don't deserve a higher score.
            normedcov = normedcov^-1;
        end 
        %Scorecell contains the normalized projection scores and NaN's
        %where a line was not utilized because it did not fit criteria. 
       	scorecelltube3{k} = normedcov;    
    end 
end

%Tube 4
count = 0;
for k = 1:length(Tube4Lines);
    if cell2mat(Tube4Lines(k)) == [1;1]; %COULDN'T GET "OR" "|" OPERATOR TO WORK!!!!!
        %counter variable to determine size of the chosen lines cell.
        count = count+1;
    end
end
chosenlinescell4 = cell(count,1);
count2 = 1;
for k = 1:length(Tube4Lines);
    if cell2mat(Tube4Lines(k)) == [1;1];
        %select the matrices of lines information such that they are within
        %the tubes
        tubelinecoords = vec2mat(cell2mat(linecell(k)),2);
        chosenlinescell4{count2,1} = tubelinecoords;
        count2 = count2 + 1;
    end
end

%Now we have a cell array that contains the matrices of every [x1,x2;y1,y2]
%line that is within each tube for Tube 1 in chosenlinescell. 


%(Still for tube 1, can copy-paste or try to automate in some complicated
%way. Consider both, even if just for learning value)
%STEP 3: Remove lines with an orientation difference from the side higher
%than 15%
%Remember hypothesis is X1,Y1. 
for k = 1:length(chosenlinescell4);
    hypothline = cell2mat(chosenlinescell4(k));
    linepointA = hypothline(1:2);
    linepointB = hypothline(3:4); 
    randlinevec = (linepointB - linepointA);     
    x1y1 = [X1(1),Y1(1)];
    x2y2 = [X1(2),Y1(2)];
    hypothvec = (x2y2-x1y1);
    dotp = dot(randlinevec,hypothvec);
    magA = norm(randlinevec);
    magB = norm(hypothvec);
    costheta = dotp/(magA * magB);
    thetarads = acos(costheta);
    thetadeg = thetarads * (180/pi);
    %Now we have our angle in degrees.
    %Let's remove the vectors that are more than 15 degrees different
    if thetadeg > mintheta;
        if thetadeg < 360-mintheta; 
        chosenlinescell4{k,1} = NaN;  
        %Now anywhere this was true, the chosenlines cell contains NaN
        end 
    end 
end
%STEP 4: Now we project each selected line on the "closest side of the
%hypothesis," which based on how this code is written is already determined.
projectorcell4 = chosenlinescell4;
scorecelltube4 = projectorcell4;
for k = 1:length(chosenlinescell4);
    if isnan(chosenlinescell4{k}) == 0;
        hypothline = cell2mat(chosenlinescell4(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);
        x1y1 = [X1(1),Y1(1)];
        x2y2 = [X1(2),Y1(2)];
        hypothvec = (x2y2-x1y1);
        %Project randlinevec onto hypothvec.
        projection =(dot(randlinevec,hypothvec)/norm(hypothvec)^2)*hypothvec;
        %Create a cell to keep the projection information in for ease of
        %access. This may never be called again, idk. 
        projectorcell4{k} = projection;
        %STEP 5: Calculate normalized coverage due to line projection.
        normedcov = norm(projection)/norm(hypothvec);
        if normedcov > 1;
            %Adjust for the fact some lines may be far beyond the boundary
            %of our hypothesis and they don't deserve a higher score.
            normedcov = normedcov^-1;
        end 
        %Scorecell contains the normalized projection scores and NaN's
        %where a line was not utilized because it did not fit criteria. 
       	scorecelltube4{k} = normedcov;   
    end 
end 
%Remember, chosenlinescellN and scorecelltubeN contain the vector form of
%the lines [x1,x2;y1,y2] and the scores for each line, respectively, at matching indices.

%Now we stop this tube-by-tube madness, and create the total "score", then find
%the lines that maximize that score.

%First, filter out those scorecellN's with no results.

if isempty(cell2mat(scorecelltube1)) == 1;
    scorecelltube1 = cell(1);
end 
if isempty(cell2mat(scorecelltube2)) == 1;
    scorecelltube2 = cell(1);
end 
if isempty(cell2mat(scorecelltube3)) == 1;
    scorecelltube3 = cell(1);
end 
if isempty(cell2mat(scorecelltube4)) == 1;
    scorecelltube4 = cell(1);
end 
%add the original hypoth lines to the end of cell of things being
%looped through in calculting score. add 'perfect score' to list of scores.
%Remember: things in chosenlinescell are now in [x1,y1;x2,y2]
chosenlinescell{(length(chosenlinescell)+1),1} = [X1(1),Y1(1);X1(2),Y1(2)];
chosenlinescell2{(length(chosenlinescell2)+1),1} = [X2(1),Y2(1);X2(2),Y2(2)];
chosenlinescell3{(length(chosenlinescell3)+1),1} = [X3(1),Y3(1);X3(2),Y3(2)];
chosenlinescell4{(length(chosenlinescell4)+1),1} = [X4(1),Y4(1);X4(2),Y4(2)];
scorecelltube1{(length(scorecelltube1)+1),1} = 1;
scorecelltube2{(length(scorecelltube2)+1),1} = 1;
scorecelltube3{(length(scorecelltube3)+1),1} = 1;
scorecelltube4{(length(scorecelltube4)+1),1} = 1;

fh = @(x) all(isnan(x(:)));
chosenlinescell(cellfun(fh, chosenlinescell)) = [];
chosenlinescell2(cellfun(fh, chosenlinescell2)) = [];
chosenlinescell3(cellfun(fh, chosenlinescell3)) = [];
chosenlinescell4(cellfun(fh, chosenlinescell4)) = [];
scorecelltube1(cellfun(fh, scorecelltube1)) = [];
scorecelltube2(cellfun(fh, scorecelltube2)) = [];
scorecelltube3(cellfun(fh, scorecelltube3)) = [];
scorecelltube4(cellfun(fh, scorecelltube4)) = [];

%Now we add all projected line "scores" and assocaite them with the coordinates of the four lines represented by the score . 
%Let's initialize the home cell for all this great information.
outputlinesandscores = cell(length(scorecelltube1)*length(scorecelltube2)*length(scorecelltube3)*length(scorecelltube4),2)
count = 0;
for k1 = 1:length(scorecelltube1);
    for k2 = 1:length(scorecelltube2);
        for k3 = 1:length(scorecelltube3);
            for k4 = 1:length(scorecelltube4);
               count = count + 1;
               comboscore = scorecelltube1{k1} + scorecelltube2{k2} + scorecelltube3{k3} + scorecelltube4{k4}; 
               scoredlines = [chosenlinescell{k1}, chosenlinescell2{k2}, chosenlinescell3{k3}, chosenlinescell4{k4}];
               outputlinesandscores{count, 1} = scoredlines;
               outputlinesandscores{count, 2} = comboscore; 
            
            
            end 
        end 
    end 
end


outputlinesandscores
%outputlinesandscores is a cell with two columns. The second contains the
%score associated with any four lines. The first contains the four lines in
%the format [x1, y1; x2, y2]*4, for the four lines. The first two columns
%within this column of outputlinesandscores belong to the first line, and so on. 


%Also do part D for monday 
