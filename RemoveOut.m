function [Output] = RemoveOut(corners, x1, x2, y1, y2)

Output = corners;

i = 1;
while i<=length(Output)
    if i > length(Output)
        break;
    end
    
    if Output(i,1)<x1 || Output(i,1)>x2 || Output(i,2)<y1 || Output(i,2)>y2
        Output(i,:) = [];
    else
        i = i+1;
    end
end

end