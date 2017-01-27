%This is Saeedi Team's super swell Building Hypothesis Code. Welcome. I have
%updated the comments so they should be more descriptive. 

%TO_DO:
%We must determine in finality whether or not we want the lines checked to
%be contained within the tubes, or simply passing through the tubes. Right
%now we have the former, but the latter may be more closely related to
%Saeedi and would require a revamping of Step 2. 

%Output is explained in comment at bottom of code.


%VARIABLES TO TINKER WITH:
tuberad = 3; %The magnitude of the vector from the end of a hypothesis to the corner of a tube. 
mintheta = 15; %The value of degrees for which all relevant 'other' lines must be within relative to the 'hypothesis' line in question.


%Generate sample hypotheses. We want 4. 
%Hypothesis:
%roofhyp{i,j}, where i is the hypothesis, and j is each line where 1<=j<=4
%[x1,x2;y1,y2]
crashcount = 0;
finaloutput = cell(1,length(roofhypo));
for khypo = 1:length(roofhypo)
    crashcount = crashcount + 1;
    %imshow('Norfolk_01_training.tif');
    hyp1=[roofhypo{khypo,1}(1),roofhypo{khypo,1}(2);roofhypo{khypo,1}(3),roofhypo{khypo,1}(4)];
    hyp2=[roofhypo{khypo,2}(1),roofhypo{khypo,2}(2);roofhypo{khypo,2}(3),roofhypo{khypo,2}(4)];
    hyp3=[roofhypo{khypo,3}(1),roofhypo{khypo,3}(2);roofhypo{khypo,3}(3),roofhypo{khypo,3}(4)];
    hyp4=[roofhypo{khypo,4}(1),roofhypo{khypo,4}(2);roofhypo{khypo,4}(3),roofhypo{khypo,4}(4)];
    line([roofhypo{khypo,1}(1),roofhypo{khypo,1}(2)],[roofhypo{khypo,1}(3),roofhypo{khypo,1}(4)], 'color', 'red', 'LineWidth', 1)
    %STEP 1: Tube Creation. Tube is in green. Want a tube for every line in
    %hypothesis. Each hypothesis hyp1 etc is of form [x1,x2;y1,y2].
    hypotheses = cell(1,4);
    hypotheses{1,1} = hyp1;
    hypotheses{1,2} = hyp2;
    hypotheses{1,3} = hyp3;
    hypotheses{1,4} = hyp4;
    %Now we're going to use the tube creator as defined below in order to
    %create tubes for all four lines of the hypotheses: hyp1,hyp2,hyp3,hyp4

    for k = 1:length(hypotheses); 
        hyp = hypotheses{1,k};
        %TUBE CREATOR: For a general line, creates a tube: (hyp1x=[x1,x2]=[a,c], hyp1y=[y1,y2]=[b,d], the first wall of hypothesis 1))
        x1 = hyp(1);
        y1 = hyp(2);
        x2 = hyp(3);
        y2 = hyp(4);
        X1000 = [x1,x2];
        Y1000 = [y1,y2];
        line(X1000,Y1000, 'color', 'red', 'LineWidth', 1.5)
        %We are going to use rectangles whose corners are a constant 45 degrees
        %from the hypothesis wall. 
        %First, find the angle, theta, that the hypothesis makes with x=0.

        theta = acos((abs(dot([(x2-x1),(y2-y1)],[1,0]))/(norm([(x2-x1),(y2-y1)])*norm([1,0]))));
        thetadeg = theta * (180/pi)   ; 
        %Theta deg is the angle that the hypothesis makes with the X-axis but it is always between 0 and 90, so we must 
        %account for the full 360 degrees of vector position.
        %In the case the vector is in the first quadrant, no transformation is
        %required.
        %Second Quadrant
        if (y2-y1) > 0;
            if (x2-x1) < 0;
                thetadeg = thetadeg + 90;
            end
        end 
        %Third Quadrant
        if (y2-y1) < 0;
            if (x2-x1) < 0;
                thetadeg = thetadeg + 180;
            end
        end 
        %Four Quadrant
        if (y2-y1) < 0;
            if (x2-x1) > 0;
                thetadeg = thetadeg + 270;
            end
        end 

        %Now we have the angle that the hypothesis makes with the x axis,
        %preserving its direction properly.
        %Now we'll find what the coordinates at which the points are if adjusted by
        %degtheta
        %Given thetadeg, we know which quadrant the vector belongs to. Thus, we can
        %determine the sign on each corner of the box. The protocol is that we go
        %clockwise, with x1cord representing the x coordinate the length of the magnitude away from the 
        %corner of the rectangle, the vector positive 45 degrees from the x2y2, tip
        %of the vector. from there we proceed counterclockewise to -45degrees, then
        %around to the "base".

        %FOR THETA DICTATING HYPOTHESIS IS IN QUADRANTS 1 OR 3.
        if (0 < thetadeg) && (thetadeg <= 90) || (180 < thetadeg) && (thetadeg <= 270);
            %Transforming the coordinates for "vector 1": (x2,y2 are coords for the endpoint of
            %the hypoth vetor)
            v1x2cord = x2 + tuberad*cos((thetadeg+45)*pi/180);
            v1y2cord = y2 + tuberad*sin((thetadeg+45)*pi/180);
            v1x1cord = x2;
            v1y1cord = y2;
            %Transforming the coordinates for "vector 2": 
            v2x2cord = x2 + tuberad*cos((thetadeg-45)*pi/180);
            v2y2cord = y2 + tuberad*sin((thetadeg-45)*pi/180) ;
            v2x1cord = x2;
            v2y1cord = y2;
            %Transforming the coordinates for "vetor 3": (x1,y1 are the tail poitns of
            %the hypoth vetctor, opposite its direction).
            v3x2cord = x1 + tuberad*cos((thetadeg+225)*pi/180);
            v3y2cord = y1 + tuberad*sin((thetadeg+225)*pi/180) ;
            v3x1cord = x1;
            v3y1cord = y1;
            %Transforming the coordinates for "vector 4": 
            v4x2cord = x1 + tuberad*cos((thetadeg+135)*pi/180);
            v4y2cord = y1 + tuberad*sin((thetadeg+135)*pi/180) ;
            v4x1cord = x1;
            v4y1cord = y1;
        end
        %FOR THETA DICTATING HYPOTHESIS IS IN QUADRANTS 2 OR 4.
        if (90 < thetadeg) && (thetadeg <= 180) || (270 < thetadeg) && (thetadeg <= 360);
            %Transforming the coordinates for "vector 1": (x2,y2 are coords for the endpoint of
            %the hypoth vetor)
            v1x2cord = x2 + tuberad*cos((-(thetadeg+135))*pi/180);
            v1y2cord = y2 + tuberad*sin((-(thetadeg+135))*pi/180);
            v1x1cord = x2;
            v1y1cord = y2;
            %Transforming the coordinates for "vector 2": 
            v2x2cord = x2 + tuberad*cos((-(thetadeg+45))*pi/180);
            v2y2cord = y2 + tuberad*sin((-(thetadeg+45))*pi/180) ;
            v2x1cord = x2;
            v2y1cord = y2;
            %Transforming the coordinates for "vetor 3": (x1,y1 are the tail poitns of
            %the hypoth vetctor, opposite its direction).
            v3x2cord = x1 + tuberad*cos((-(thetadeg+315))*pi/180);
            v3y2cord = y1 + tuberad*sin((-(thetadeg+315))*pi/180);
            v3x1cord = x1;
            v3y1cord = y1;
            %Transforming the coordinates for "vector 4": 
            v4x2cord = x1 + tuberad*cos((-(thetadeg+225))*pi/180);
            v4y2cord = y1 + tuberad*sin((-(thetadeg+225))*pi/180);
            v4x1cord = x1;
            v4y1cord = y1;
        end 
        line([v1x2cord,v2x2cord],[v1y2cord,v2y2cord], 'color', 'green', 'LineWidth', 2)
        line([v2x2cord,v3x2cord],[v2y2cord,v3y2cord], 'color', 'green', 'LineWidth', 2)
        line([v3x2cord,v4x2cord],[v3y2cord,v4y2cord], 'color', 'green', 'LineWidth', 2)
        line([v4x2cord,v1x2cord],[v4y2cord,v1y2cord], 'color', 'green', 'LineWidth', 2)
        %End of TUBE CREATOR
        %Now we will put the boundary points of each rectangle for each hypoth
        %in its respective matrix. [x1,x2,x3,x4;y1,y2,y3,y4]
        if k == 1;
            tube1 = [v1x2cord,v2x2cord,v3x2cord,v4x2cord;v1y2cord,v2y2cord,v3y2cord,v4y2cord];      
        end 
        if k == 2;
            tube2 = [v1x2cord,v2x2cord,v3x2cord,v4x2cord;v1y2cord,v2y2cord,v3y2cord,v4y2cord]; 
        end 
        if k == 3;
            tube3 = [v1x2cord,v2x2cord,v3x2cord,v4x2cord;v1y2cord,v2y2cord,v3y2cord,v4y2cord]; 
        end 
        if k == 4;
            tube4 = [v1x2cord,v2x2cord,v3x2cord,v4x2cord;v1y2cord,v2y2cord,v3y2cord,v4y2cord]; 
        end 
    end

    %Now that we have these coordinates, we can draw a rectangle between the
    %endpoints of every transformed vector, creating a rectangle.

    %STEP 2: Find all lines that are fully or partially within the tubes. (From
    %the set of III-A-5
    %(use inpolygon to determine whether both endpoints are in the tube)
    %Check all lines for interior of Tube 1:
    %Linelist is list of suspect lines. Currently as [[x1,x2;y1,y2]]
    %Linelist will now be taking from joyce's "lines". lines is a 5x3924 cell 
    %with [x1,x2,y1,y2,width].' in every column.
    %THIS NEEDS TO BE OPTIMIZED!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    %Integration one from joyce
    for k = 1:length(lines)
        x2 = lines(2,k);
        y1 = lines(3,k);
        x1 = lines(1,k);
        y2 = lines(4,k);
        linelist = [linelist, [x1,x2;y1,y2]];
    end 
    linecell = cell(length(linelist)/2,1);
    for i = 1:(length(linelist)/2);
        linecell{i,1} = linelist(4*i-3:4*i);
    end
    Tube1Array = [];
    Tube2Array = [];
    Tube3Array = [];
    Tube4Array = [];
    for k = linelist;
        [in] = inpolygon(k(1),k(2),tube1(1,:),tube1(2,:));
        Tube1Array = cat(1,Tube1Array,[in]);
    end
    for k = linelist;
        [in] = inpolygon(k(1),k(2),tube2(1,:),tube2(2,:));
        Tube2Array = cat(1,Tube2Array,[in]);
    end
    for k = linelist;
        [in] = inpolygon(k(1),k(2),tube3(1,:),tube3(2,:));
        Tube3Array = cat(1,Tube3Array,[in]);
    end
    for k = linelist;
        [in] = inpolygon(k(1),k(2),tube4(1,:),tube4(2,:));
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


    %STEP 3: Remove lines with an orientation difference from the side higher
    %than 15%
    %Remember hypothesis is hyp1
    for k = 1:length(chosenlinescell);
        hypothline = cell2mat(chosenlinescell(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);     
        x1y1 = [hyp1(1),hyp1(2)];
        x2y2 = [hyp1(3),hyp1(4)];
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
            x1y1 = [hyp1(1),hyp1(2)];
            x2y2 = [hyp1(3),hyp1(4)];
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
    %Remember hypothesis is in hyp1. 
    for k = 1:length(chosenlinescell2);
        hypothline = cell2mat(chosenlinescell2(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);     
        x1y1 = [hyp2(1),hyp2(2)];
        x2y2 = [hyp2(3),hyp2(4)];
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
            x1y1 = [hyp2(1),hyp2(2)];
            x2y2 = [hyp2(3),hyp2(4)];;
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
    %TUBE 3
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
    %Remember hypothesis is in hyp1. 
    for k = 1:length(chosenlinescell3);
        hypothline = cell2mat(chosenlinescell3(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);     
        x1y1 = [hyp3(1),hyp3(2)];
        x2y2 = [hyp3(3),hyp3(4)];
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
            x1y1 = [hyp3(1),hyp3(2)];
            x2y2 = [hyp3(3),hyp3(4)];
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
    %Remember hypothesis is in hyp 1. 
    for k = 1:length(chosenlinescell4);
        hypothline = cell2mat(chosenlinescell4(k));
        linepointA = hypothline(1:2);
        linepointB = hypothline(3:4); 
        randlinevec = (linepointB - linepointA);     
        x1y1 = [hyp4(1),hyp4(2)];
        x2y2 = [hyp4(3),hyp4(4)];
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
            x1y1 = [hyp4(1),hyp4(2)];
            x2y2 = [hyp4(3),hyp4(4)];
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

    chosenlinescell{(length(chosenlinescell)+1),1} = [hyp1(1),hyp1(2);hyp1(3),hyp1(4)];
    chosenlinescell2{(length(chosenlinescell2)+1),1} = [hyp2(1),hyp2(2);hyp2(3),hyp2(4)];
    chosenlinescell3{(length(chosenlinescell3)+1),1} = [hyp3(1),hyp3(2);hyp3(3),hyp3(4)];
    chosenlinescell4{(length(chosenlinescell4)+1),1} = [hyp4(1),hyp4(2);hyp4(3),hyp4(4)];
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
    outputlinesandscores = cell(length(scorecelltube1)*length(scorecelltube2)*length(scorecelltube3)*length(scorecelltube4),2);
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

        finaloutput{1,khypo} = outputlinesandscores;
                    
                end 
            end 
        end 
    end
end
outputlinesandscores == finaloutput{1,1}

       %Should this be in the loop? Review code at some point. Maybe put in
       %a threshold parameter that things must be higher than in order to reduce
       %number of final outputs?

%outputlinesandscores is a cell with two rows. The second contains the
%score associated with any four lines. The first contains the four lines in
%the format [x1, y1; x2, y2]*4, for the four lines. The first two columns
%within this column of outputlinesandscores belong to the first line, and so on. 


%Also do part D for monday 

%} 
