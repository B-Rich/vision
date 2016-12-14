function output = getNumOfPetals(binImg)
binPImg = imerode(binImg,strel('disk',2,8));
%binPImg = bwmorph(binPImg,'fill');
compP = bwconncomp(binPImg,8);

%Buffer to perform operations for extracting petals
bufferP = binPImg;
compSizeP = getComponentSize(compP);

%Sort components by their size
[sortedSizes, srtingIdx] = sort(compSizeP,'descend');

%Retain flower
for i = 1:1:compP.NumObjects
    if compSizeP(i) ~= sortedSizes(1)
        bufferP(compP.PixelIdxList{i}) = 0;
    end
end
compPT = bwconncomp(bufferP,8);
compSizePT = getComponentSize(compPT);

%EXPERIMENTAL
%20 for 0, 10 for 1, 40 for 2, 7 for 4
bufferP2 = imerode(bufferP,strel('disk',20,8));
compP2 = bwconncomp(bufferP2,8);
compSizeP2 = getComponentSize(compP2);
imshow(bufferP2);

%Get count nMax, add
nMax = 1;
try
    while sortedSizes(nMax+1) >= 0.8*sortedSizes(nMax)
        nMax = nMax + 1;
    end
catch
    disp('Oops');
end


if(sortedSizes(2) >= 0.8*sortedSizes(1))
    disp(nMax*compP2.NumObjects)
else
    disp(compP2.NumObjects)
end
