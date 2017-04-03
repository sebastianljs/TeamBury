input = load('../matlab_data/testlines.mat'); %%Input files
lines = input.lines;
% sort the lines so that x1 is always the left of x2. If x1 and x2 are the
% same, then y1 is always smaller than y2(y1 is above y2 on the image)
for a = 1:size(lines,2)
    if (lines(1,a)>lines(2,a) == 1)
        temp1 = lines(2,a);
        lines(2,a) = lines(1,a);
        lines(1,a) = temp1;
        temp2 = lines(3,a);
        lines(3,a) = lines(4,a);
        lines(4,a) = temp2;
    elseif ((lines(1,a) == lines(2,a)) && (lines(3,a)>lines(4,a)))
        temp3 = lines(2,a);
        lines(2,a) = lines(1,a);
        lines(1,a) = temp3;
        temp4 = lines(3,a);
        lines(3,a) = lines(4,a);
        lines(4,a) = temp4;
        
    end
    
    
end
parallels = cell(1,2);
count = 0;
% To find the parallel pairs in the whole image
for i = 1:size(lines,2)-1
    for j = i+1:size(lines,2)
        % the window based method
        if (lines(1,j)<(lines(2,i)+50)) && (lines(1,j) > (lines(1,i)-50))
            % To check the values of y to see which one is bigger
            if (lines(3,i)<lines(4,i))
                if (lines(3,j)<(lines(4,i)+50)) && (lines(3,j)>(lines(3,i)-50))
                    % To compute the slopes of the lines
                    slopei = (lines(4,i) - lines(3,i))/(lines(2,i)-lines(1,i));
                    slopej = (lines(4,j) - lines(3,j))/(lines(2,j)-lines(1,j));
                    if (-0.3 < (slopei-slopej))&&((slopei-slopej) < 0.3)
                        count = count+1;
                        parallels{count,1} = lines(:,i);
                        parallels{count,2} = lines(:,j);
                        
                    end
                end
            else
                if (lines(3,j)<(lines(3,i)+50)) && (lines(3,j)>(lines(4,i)-50))
                    slopei = (lines(4,i) - lines(3,i))/(lines(2,i)-lines(1,i));
                    slopej = (lines(4,j) - lines(3,j))/(lines(2,j)-lines(1,j));
                    if (-0.4 < (slopei-slopej))&&((slopei-slopej) < 0.4)
                        count = count+1;
                        parallels{count,1} = lines(:,i);
                        parallels{count,2} = lines(:,j);
                    end
                end
            end
        end
    end
end

%Delete the repetive ones
% for m=1:size(parallels,1)-1
%     for n = m+1:size(parallels,1)
%         if (all(parallels{m,1}==parallels{n,2})) && (all(parallels{m,2} == parallels{n,1}))
%             parallels{n,1} = [0;0;0;0;0];
%             parallels{n,2} = [0;0;0;0;0];
%         end
%     end
%
% end

% for m = 1:size(parallels,1)
%     if (all(parallels{m,1}== 0))
%         parallels{m,1} = [];
%         parallels{m,2} = [];
%     end
% end

%parallelsnew = parallels(~cellfun('isempty',parallels)) ;
roofhypo = cell(1,4);
number = 0;
% Find the perpendicular rooftop hypothesis
for a = 1:size(parallels,1)-1
    for b = a+1:size(parallels,1)
        if ~any(parallels{a,1}==0) && ~any(parallels{b,1}==0)
            li1 = parallels{a,1};
            li12= parallels{a,2};
            li2 = parallels{b,1};
            li22 = parallels{b,2};
            slope1 = (li1(4,1) - li1(3,1))/(li1(2,1)-li1(1,1));
            slope2 = (li2(4,1) - li2(3,1))/(li2(2,1)-li2(1,1));
            if ((slope1*slope2) < -0.8) && ((slope1*slope2) > -1.2)
                % window based method
                maxx = max([li1(2),li12(2)]);%,li2(2),li22(2)]);
                minx = min([li1(1),li12(1)]);%,li2(1),li22(1)]);
                maxy = max([li1(3),li12(3),li1(4),li12(4)]);
                miny = min([li1(4),li12(4),li1(4),li12(4)]);
                buildingwidth = 50;
                if  (li2(1)>minx-buildingwidth)&&(li2(1)< maxx+buildingwidth) && (li22(1)>minx-buildingwidth) && (li22(1)< maxx+buildingwidth)
                    if  (li2(2)>minx-buildingwidth) && (li2(2)< maxx+buildingwidth)  && (li22(2)>minx-buildingwidth) && (li22(2)< maxx+buildingwidth)
                        if  (li2(3)>miny-buildingwidth) && (li2(3)< maxy+buildingwidth) && (li22(3)>miny-buildingwidth) && (li22(3)< maxy+buildingwidth)
                            if  (li2(4)>miny-buildingwidth) && (li2(4)< maxy+buildingwidth)  && (li22(4)>miny-buildingwidth) && (li22(4)< maxy+buildingwidth)
                                number = number + 1;
                                roofhypo{number,1} = li1;
                                roofhypo{number,2} = li12;
                                roofhypo{number,3} = li2;
                                roofhypo{number,4} = li22;
                            end
                        end
                    end
                end
            end
        end
    end
end
figure(2)
%imshow('Norfolk_01_training.tif');
for i =1:size(roofhypo,1)
    X1 = [roofhypo{i,1}(1),roofhypo{i,1}(2) ];
    Y1 = [roofhypo{i,1}(3),roofhypo{i,1}(4) ];
    h1 = line(X1,Y1,'color','red');
    X2 = [roofhypo{i,2}(1),roofhypo{i,2}(2) ];
    Y2 = [roofhypo{i,2}(3),roofhypo{i,2}(4) ];
    h2 = line(X2,Y2,'color','red');
    X3 = [roofhypo{i,3}(1),roofhypo{i,3}(2) ];
    Y3 = [roofhypo{i,3}(3),roofhypo{i,3}(4) ];
    h3 = line(X3,Y3,'color','red');
    X4 = [roofhypo{i,4}(1),roofhypo{i,4}(2) ];
    Y4 = [roofhypo{i,4}(3),roofhypo{i,4}(4) ];
    h4 = line(X4,Y4,'color','red');
    hold on;
end