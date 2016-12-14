[bin, imgs] = prepareImages(0);
binPImg = imerode(bin{1},strel('disk',2,8));
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

%EXPERIMENTAL
bufferP2 = imerode(bufferP,strel('disk',20,8));
compP2 = bwconncomp(bufferP2,8);
disp(compP2.NumObjects)

