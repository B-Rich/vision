close all;
img = imread('testcase 4.jpg');%Working
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
%hist = histogram(grayScale);
binImg = im2bw(grayScale,graythresh(grayScale));
imshow(binImg)
%binImg = imerode(binImg,strel('disk',2,8));
comp = bwconncomp(binImg,8);

%Get size of components
compSize = zeros(size(comp.NumObjects));
for idx = 1:1:comp.NumObjects
     compSize(idx) = prod(size(comp.PixelIdxList{idx}));
end

%Get flower
rmLargest = compSize(compSize<max(compSize));
SE = strel('disk',2,8);
binFImg = imerode(binImg,SE);
binFImg = bwmorph(binFImg,'fill');
compF = bwconncomp(binFImg,8);

bufferF = binFImg;
compSizeF = getComponentSize(compF);

[sortedSizes, srtingIdx] = sort(compSizeF,'descend');
nMax = 1; %Desired maximum values
while 0.15*sortedSizes(nMax) <= sortedSizes(nMax+1)
    nMax = nMax + 1;
end
maxVals = sortedSizes(1:nMax);
maxValIdx = srtingIdx(1:nMax);

for i = 1:1:compF.NumObjects
    if ~ismember(compSizeF(i),maxVals)
        bufferF(compF.PixelIdxList{i}) = 0;
    end
end
compBF = bwconncomp(bufferF,8);

figure, imshow(bufferF)
disp(compBF.NumObjects);