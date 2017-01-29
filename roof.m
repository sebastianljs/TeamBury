figure(2)
im = imread('cropped.png');
imshow('cropped.png');
a = load('burns.mat');
edgeim = a.edgeim;
%[edgeim, labelededgeim] = edgelink(edgeim, 10);

%edgeim = filledgegaps(edgeim,5);
%The line linking and filtering algorithm only makes lines fewer
hold on;
for a = 1:size(edgeim, 2)
    plot(edgeim(1:2, a), edgeim(3:4, a), 'LineWidth', edgeim(5, a) / 2, 'Color', [1, 0, 0]);
end
hold off;
%matrix = load('seg3.mat');
%seg = matrix.srManSpec;
figure(3)
imshow('cropped.png')

% tol = 5;
% [~,ang] = imgradient(im);
% out = (ang >= 180 - tol | ang <= -180 + tol);
% imshow(out);
hold on;
count = 0;
verticals = zeros(5,17);
horizontals = zeros(5,17);
count2 = 0;
for a = 1:size(edgeim,2)
    if (-2<(edgeim(1,a)-edgeim(2,a))) && ((edgeim(1,a)-edgeim(2,a))<2)
        plot(edgeim(1:2, a), edgeim(3:4, a), 'LineWidth', edgeim(5, a) / 2, 'Color', [1, 0, 0]);
        count = count+1;
        verticals(1,count) = edgeim(1,a);
        verticals(2,count) = edgeim(2,a);
        verticals(3,count) = edgeim(3,a);
        verticals(4,count) = edgeim(4,a);
        verticals(5,count) = edgeim(5,a);
    else
        count2 = count2+1;
        horizontals(1,count2) = edgeim(1,a);
        horizontals(2,count2) = edgeim(2,a);
        horizontals(3,count2) = edgeim(3,a);
        horizontals(4,count2) = edgeim(4,a);
        horizontals(5,count2) = edgeim(5,a);
    end
        

end


hypo = zeros(5,1088);
count3 = 0;
for i = 1:size(verticals,2)-1
    for j = i+1:size(verticals,2)
        if abs(verticals(1,i) - verticals(1,j))<40 && abs(verticals(1,i) - verticals(1,j))>10 && abs(verticals(3,i)-verticals(3,j))<20
           for a=1:size(horizontals,2)-1
               for b = a+1:size(horizontals,2)
                   if abs(horizontals(3,a) - horizontals(3,b))<40 && abs(horizontals(3,a) - horizontals(3,b))>10 && abs(horizontals(1,a)-horizontals(1,b))<30
                      hypo(1,4*count3+1) = verticals(1,i);
                      hypo(2,4*count3+1) = verticals(2,i);
                      hypo(3,4*count3+1) = verticals(3,i);
                      hypo(4,4*count3+1) = verticals(4,i);
                      hypo(5,4*count3+1) = verticals(5,i);
                      hypo(1,4*count3+2) = verticals(1,j);
                      hypo(2,4*count3+2) = verticals(2,j);
                      hypo(3,4*count3+2) = verticals(3,j);
                      hypo(4,4*count3+2) = verticals(4,j);
                      hypo(5,4*count3+2) = verticals(5,j);
                       hypo(1,4*count3+3) = horizontals(1,a);
                      hypo(2,4*count3+3) = horizontals(2,a);
                      hypo(3,4*count3+3) = horizontals(3,a);
                      hypo(4,4*count3+3) = horizontals(4,a);
                      hypo(5,4*count3+3) = horizontals(5,a);
                       hypo(1,4*count3+4) = horizontals(1,b);
                      hypo(2,4*count3+4) = horizontals(2,b);
                      hypo(3,4*count3+4) = horizontals(3,b);
                      hypo(4,4*count3+4) = horizontals(4,b);
                      hypo(5,4*count3+4) = horizontals(5,b);
                      count3 = count3+1;
                      
                      
                   end
               end
           end
        end
    end
end




