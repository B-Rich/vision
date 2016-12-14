function [numOfFlawahs, Var, bufferF, compBF] = getNumOfFlowers(binImg,dFlag)
%function [numOfFlawahs, Var, bufferF] = getNumOfFlowers(binImg,dFlag)
%function o = getNumOfFlowers(binImg)
%figure, imshow(binImg);
if nargin < 2
    dFlag = 1;
end

%Get flower
binFImg = imerode(binImg,strel('disk',2,8));
binFImg = bwmorph(binFImg,'fill');
compF = bwconncomp(binFImg,8);

%Buffer to perform operations for extracting flower
bufferF = binFImg;
compSizeF = getComponentSize(compF);

%Sort components by their size
sortedSizes = sort(compSizeF,'descend');

nMax = 1; %Desired maximum values
try
    while 0.15*sortedSizes(nMax) <= sortedSizes(nMax+1) %0.15, old acceptance value New=0.7525
        nMax = nMax + 1;
    end
catch
    %disp('Oops');
end
maxVals = sortedSizes(1:nMax);

%Eliminate insignificant components
for i = 1:1:compF.NumObjects
    if ~ismember(compSizeF(i),maxVals)
        bufferF(compF.PixelIdxList{i}) = 0;
    end
end
bufferF = imerode(bufferF,strel('disk',2,8));
%bufferF = imfill(bufferF,8,'holes');
compBF = bwconncomp(bufferF,8);

if dFlag
    figure, imshow(bufferF);
end

compSizeBF = getComponentSize(compBF);
trueAt = compSizeBF < 50;

for i = 1:1:size(compSizeBF,2)
    if trueAt(i) == 1
        bufferF(compBF.PixelIdxList{i})=0;
    end
end

compBF = bwconncomp(bufferF,8);
compSizeBF = getComponentSize(compBF);

sortedSizes2  = sort(compSizeBF,'descend');
%If an object is roughly twice (or more) the size of another, it's probably two overlapped
loc = (compSizeBF <= 0.5*sortedSizes2);
numOfObjs = size(compSizeBF,2);
numOfFlawahs = numOfObjs + sum(loc);
disp(['Number of flowers: ',num2str(numOfFlawahs)]);
Var = compBF.NumObjects;
end