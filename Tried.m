close all;
img = imread('testcase 1.jpg');
[cntrs, rd] = imfindcircles(img,[5 20],'ObjectPolarity','dark','Sensitivity',0.94);
figure, imshow(img), title('Original Image');
viscircles(cntrs,rd,'EdgeColor','b');

if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
hsvImg = rgb2hsv(img);

H = hsvImg(:,:,1); 
S = hsvImg(:,:,2); 
V = hsvImg(:,:,3);

gHSVImg = rgb2gray(hsvImg);
bHSVImg = ~im2bw(gHSVImg,graythresh(gHSVImg));
fImg = imfill(bwmorph(bHSVImg,'fill'),'holes');
fImg = imerode(fImg,strel('disk',2,8));

% hueHist = hist(H(:),255); 
% satHist = hist(S(:),255); 
% valHist = hist(V(:),255);

%hsvHist = imhist(hsvImg);

gHSVImg = rgb2gray(hsvImg);
%hist = histogram(grayScale);

binImg = im2bw(grayScale,graythresh(grayScale));
%[eucDist nIdx] = bwdist(binImg,'euclidean');

binImg = imerode(binImg,strel('disk',3,8));
binImg = bwmorph(binImg,'fill');
binImg = imfill(binImg,'holes');
%dist = pdist(binImg ,'euclidean');
cc = bwconncomp(binImg,8);
props = regionprops(binImg);
crnrs = detectHarrisFeatures(binImg);
crnrsHSV = detectHarrisFeatures(fImg);
%detectSURFFeatures(binImg); 
%detectHarrisFeatures(grayScale); tested
%detectFASTFeatures(grayScale); not tested
%detectBRISKFeatures(grayScale); not tested
%detectMSERFeatures(grayScale); not tested

numOfPts = crnrs.Count;

crnrsX = zeros(size(numOfPts));
crnrsY = zeros(size(numOfPts));
crnrsMet = zeros(size(numOfPts));
%crnrsX = []; crnrsY = []; crnrsMet = [];

for idx = 1:1:numOfPts
     currPoint = crnrs(idx);
     crnrsX(idx) = currPoint.Location(1); %Get all X coordinates
     crnrsY(idx) = currPoint.Location(2); %Get all Y coordinates
     crnrsMet(idx) = currPoint.Metric;
end

[mnX, mnXi] = getMinMax(crnrsX,'min'); %Get value and index of minimas and maximas
[mnY, mnYi] = getMinMax(crnrsY,'min');
[mxX, mxXi] = getMinMax(crnrsX,'max');
[mxY, mxYi] = getMinMax(crnrsY,'max');
[mxM, mxMi] = getMinMax(crnrsMet,'max'); %Get value and index of highest metric

crnrs(mnXi).Metric = mxM;
crnrs(mnYi).Metric = mxM;
crnrs(mxXi).Metric = mxM;
crnrs(mxYi).Metric = mxM;

%dist = sqrt(crnrsX.^2 + crnrsY.^2);

hash = [];
for idx = 1:1:cc.NumObjects
     hash(idx) = prod(size(cc.PixelIdxList{idx}));
end
% [maxVal idxOfMax] = max(hash);
% hash(idxOfMax) = 0;
% [newMaxVal newIdxOfMax] = max(hash);

figure, imshow(binImg), title('Harris features'); hold on
%plot(crnrs.selectStrongest(1));

plot(crnrs(mnXi));
plot(crnrs(mnYi));
plot(crnrs(mxXi));
plot(crnrs(mxYi));

%plot(crnrs(1).Location);
hold off

[feats, crnrs2] = extractFeatures(binImg,crnrs);
[featsHSV, crnrsHSV2] = extractFeatures(fImg,crnrsHSV);

figure, imshow(binImg), title('Extract features'); hold on
plot(crnrs2);
hold off

figure, imshow(fImg), title('HSV');

figure, imshow(or(fImg,binImg)), title('HSV + GS'); hold on
plot(crnrsHSV2);
hold off
