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
verticals = zeros(4,17);
horizontals = zeros(4,17);
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



figure(4)
for i = 1:size(verticals,2)-1
    for j = i+1:size(verticals,2)
        if abs(verticals(1,i) - verticals(1,j))<40 && abs(verticals(1,i) - verticals(1,j))>10 && abs(verticals(3,i)-verticals(3,j))<20
           for a=1:size(horizontals,2)-1
               for b = a+1:size(horizontals,2)
                   if abs(horizontals(1,a) - verticals(1,i))<10 && abs(horizontals(1,b)-verticals(1,j)<10)
                       imshow('cropped.png')
                       hold on;
                       plot(verticals(1:2, i), verticals(3:4, i), 'LineWidth', verticals(5, i) / 2, 'Color', [1, 0, 0]);
                        plot(verticals(1:2, j), verticals(3:4, j), 'LineWidth', verticals(5, j) / 2, 'Color', [1, 0, 0]);
                         plot(horizontals(1:2, a), horizontals(3:4, a), 'LineWidth', horizontals(5, a) / 2, 'Color', [1, 0, 0]);
                          plot(horizontals(1:2, b), horizontals(3:4, b), 'LineWidth', horizontals(5, b) / 2, 'Color', [1, 0, 0]);
                   end
               end
           end
        end
    end
end




