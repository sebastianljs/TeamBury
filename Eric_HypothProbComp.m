%This is Eric Peshkin's super swell Building Hypothesis Code. Welcome. I have
%updated the comments so they should be more descriptive. Also, the very
%last step may change substantially depending on how one interprets
%Saeedi's code. I will be checking this in class tomorrow and then changing
%or not changing it afterwards, appropriately.


%Generate sample hypotheses. We want 4. This is for the sake of testing
%things.
%Hypothesis 1:
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
%This is with every line charted simultaneously as one long line. Maybe it
%will be helpful?
%line([1,1.5,1.5,4,4,4,4,1],[1,7,7,7,7,1.5,1.5,1],'color','red')
%Hypothesis 2:

%Hypothesis 3:

%Hypothesis 4:

%Random Lines:
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
%Step 1: Tube Creation. Tube is in green. Want a tube for every line in
%hypothesis. 
tuberad = 0.15;
%for loop to simplify here FIX FIX

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
for k = linelist;
    [in] = inpolygon(k(1),k(2),tx1,ty1);
    Tube1Array = cat(1,Tube1Array,[in]);
end

%Tube1Array is a vertical matrix for which every row corresponds to a
%point. Every second row begins a new "line". 
%Let's split this into 7 2x1 doubles, each of which contains a single "line's" validity info.
Tube1Lines = mat2cell(Tube1Array,zeros(1,(size(Tube1Array,1)/2))+2,[1]);

%Now we will seperate any lines that "fit" (or one pt in the line is in the
%polygon, to check for the entire line in polygon switch to [1;1] on all.)
count = 0;
for k = 1:length(Tube1Lines);
    if cell2mat(Tube1Lines(k)) == [0;1]; %COULDN'T GET "OR" "|" OPERATOR TO WORK!!!!!
        %counter variable to determine size of the chosen lines cell.
        count = count+1;
    end
    if cell2mat(Tube1Lines(k)) == [1;0]; 
        %counter variable to determine size of the chosen lines cell.
        count = count+1;
    end 
end
chosenlinescell = cell(count,1);
count2 = 1;
for k = 1:length(Tube1Lines);
    if cell2mat(Tube1Lines(k)) == [0;1];
        %select the matrices of lines information such that they are within
        %the tubes
        tubelinecoords = vec2mat(cell2mat(linecell(k)),2);
        chosenlinescell{count2,1} = tubelinecoords;
        count2 = count2 + 1;
    end
    %hi, couldn't get or operator to work again...idk why. 
    if cell2mat(Tube1Lines(k)) == [1;0];
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
    if thetadeg > 15;
        if thetadeg < 345; 
        chosenlinescell{k,1} = NaN;  
        %Now anywhere this was true, the chosenlines cell contains NaN
        end 
    end 
end
%STEP 4: Now we project each selected line on the "closest side of the
%hypothesis," which based on how this code is written is already determined.
projectorcell = chosenlinescell;
scorecell = projectorcell;
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
        projectorcell{k} = projection;
        %STEP 5: Calculate normalized coverage due to line projection.
        normedcov = norm(projection)/norm(hypothvec);
        if normedcov > 1;
            %Adjust for the fact some lines may be far beyond the boundary
            %of our hypothesis and they don't deserve a higher score.
            normedcov = normedcov^-1;
        end 
        %Scorecell contains the normalized projection scores and NaN's
        %where a line was not utilized because it did not fit criteria. 
       	scorecell{k} = normedcov      
    end 
end 
%Currently, scorecell is the final output that gives you the scores for the
%one edge. This will be changed as I ask questions tomorrow, so the code
%isn't entirely finished yet. The stuff below is all my notes for future
%improvement or ambiguity, not important for the code but feel free to
%read if you're reading this, I guess. 
%I should also probably make it correspond to the linecell. Cool, wait it
%already does lol. I'll write this all up tomorrow morning. 


%Also find lines both fully and partially in tubes...
%Sum the four scores and normalize them?

%Project each line on the closest line of the hypothesis is the part that's
%missing, we only project one line on the closest line of the hypothesis,
%so nothing to sum yet? This could be read as my code or another
%interpretation but the lines are not square buildings there are only lines
%so I think my interpretation is correct. Saeedi is vague here. 

%One thing that needs adjusting, if a line crosses from one tube to another
%it will NOT be considered viable. Idk if this is meant to work this way, I
%will check soon. This could rudimentarily be fixed by increasing tube
%radius, but this is obviously not cost-free. 
