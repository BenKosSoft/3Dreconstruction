%TODO: turn it into function?
for i=1:1:2
    I = imread(strcat('Im',int2str(i),'.jpg'));
    I = rgb2gray(I);
    C = corner(I,'MinimumEigenValue',10000);%,'SensitivityFactor',0.001); % apply Harris algorithm
    
    if i == 1
        C = RemoveOut(C, 88, 392, 414, 722);
        C = NormalizeCorners(C,15); %TODO: adjust treshold value
    else
        C = RemoveOut(C, 217, 528, 430, 740);
        C = NormalizeCorners(C,15); %TODO: adjust treshold value
    end
    
    figure;
    imshow(I);
    hold on
    plot(C(:,1), C(:,2), 'r*');
    title('Shi-Tomasi corners');
end