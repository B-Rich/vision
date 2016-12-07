close all;
img = imread('testcase 7.jpg');%Working
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end

binImg = im2bw(grayScale,graythresh(grayScale));
imshow(binImg)
comp = bwconncomp(binImg,8);

%Get flower
binFImg = imerode(binImg,strel('disk',2,8));
binFImg = bwmorph(binFImg,'fill');
compF = bwconncomp(binFImg,8);

bufferF = binFImg;
compSizeF = getComponentSize(compF);

[sortedSizes, srtingIdx] = sort(compSizeF,'descend');
nMax = 1; %Desired maximum values
try
while 0.15*sortedSizes(nMax) <= sortedSizes(nMax+1) %0.15, old acceptance value New=0.7525
    nMax = nMax + 1;
end
catch
    disp('Oops');
end
maxVals = sortedSizes(1:nMax);
maxValIdx = srtingIdx(1:nMax);

%Eliminate insignificant components
for i = 1:1:compF.NumObjects
    if ~ismember(compSizeF(i),maxVals)
        bufferF(compF.PixelIdxList{i}) = 0;
    end
end
bufferF = imerode(bufferF,strel('disk',2,8));
%bufferF = imfill(bufferF,8,'holes');
compBF = bwconncomp(bufferF,8);

figure, imshow(bufferF)

compSizeBF = getComponentSize(compBF);
trueAt = compSizeBF < 50;%compSizeBF(end)<0.15*compSizeBF;

%Works with 6
% for i = 1:1:size(compSizeBF,2)
%     if trueAt(i) == 0
%         compSizeBF(i) = [];
%     end
% end
for i = 1:1:size(compSizeBF,2)
 if trueAt(i) == 1
    bufferF(compBF.PixelIdxList{i})=0;
end
end
compBF = bwconncomp(bufferF,8);
compSizeBF = getComponentSize(compBF);

[sortedSizes2, srtingIdx2] = sort(compSizeBF,'descend');
%If an object is roughly twice (or more) the size of another, it's probably two overlapped
loc = (compSizeBF <= 0.5*sortedSizes2); 
numOfObjs = size(compSizeBF,2);
numOfFlawahs = numOfObjs + sum(loc);
disp('Number of flowers: ')
disp(numOfFlawahs);