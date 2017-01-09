%TODO: update this... or fuck it pick manually
function [normalizedCorners] = NormalizeCorners(corners, treshold)

normalizedCorners = corners;

i = 1;
while i<=length(normalizedCorners)
    if i > length(normalizedCorners)
        break;
    end
    removed = 0;
    point = [normalizedCorners(i,1), normalizedCorners(i,2)];
    index = i+1;
    j=1;
    while j<=length(normalizedCorners)
        if j > length(normalizedCorners)
            break;
        end
        t = norm(point - [normalizedCorners(j,1), normalizedCorners(j,2)]);
        if j~=i && t < treshold
            normalizedCorners(j,:) = [];
            removed = 1;
            index = j;
        else
            j = j+1;
        end
    end
    if ~removed && index>i
        i = i+1;
    end
end

end
