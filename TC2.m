close all;
%[img, alpha] = imread('testcase 2.jpg');
[img, alpha] = imread('testcase 1.jpg');
[cntrs, rd] = imfindcircles(img,[5 10],'ObjectPolarity','bright','Sensitivity',0.96);
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

bH = im2bw(H,graythresh(H));
bS = im2bw(S,graythresh(S));
bV = im2bw(V,graythresh(V));

cc = bwconncomp(bV,8);
petalBuffer = bV;
%numObj = cc.NumObjects;
diskR = 1;

%Erode until petals only remain
while cc.NumObjects > 5
    petalBuffer = imerode(petalBuffer,strel('disk',diskR,8));
    cc = bwconncomp(petalBuffer,8);
    if (cc.NumObjects == 5)
        break;
    else
        petalBuffer = bV;
        diskR = diskR + 1;
    end
end

figure,
subplot(1,3,1), imshow(img,[]), title('Original');
subplot(1,3,2), imshow(petalBuffer,[]), title('Petals');
subplot(1,3,3), imshow(bH,[]), title('Flower(s)');

gHSVImg = rgb2gray(hsvImg);
bHSVImg = ~im2bw(gHSVImg,graythresh(gHSVImg));
fImg = imfill(bwmorph(bHSVImg,'fill'),'holes');
fImg = imerode(fImg,strel('disk',2,8));


%cc = bwconncomp(binImg,8);

[l, n] = bwlabel(binImg,8);

props = regionprops(l,'Extrema');,
props2 = regionprops(l,'ConvexHull');,
props3 = regionprops(l,'Perimeter');,
crnrs = detectFASTFeatures(petalBuffer); %better than harris
crnrsHSV = detectHarrisFeatures(grayScale);

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

%Get value and index of minimas and maximas
[mnX, mnXi] = getMinMax(crnrsX,'min'); 
[mnY, mnYi] = getMinMax(crnrsY,'min');
[mxX, mxXi] = getMinMax(crnrsX,'max');
[mxY, mxYi] = getMinMax(crnrsY,'max');

%Get value and index of highest metric
[mxM, mxMi] = getMinMax(crnrsMet,'max'); 

crnrs(mnXi).Metric = mxM;
crnrs(mnYi).Metric = mxM;
crnrs(mxXi).Metric = mxM;
crnrs(mxYi).Metric = mxM;

%dist = sqrt(crnrsX.^2 + crnrsY.^2);

hash = zeros(size(cc.NumObjects));
for idx = 1:1:cc.NumObjects
     hash(idx) = prod(size(cc.PixelIdxList{idx}));
end

figure, imshow(bH), title('Yelp'); hold on
plot(crnrs(mnXi));
plot(crnrs(mnYi));
plot(crnrs(mxXi));
plot(crnrs(mxYi));
hold off
disp(mnX); disp(mxX); disp(mnY); disp(mxY);
extractedFlower = petalBuffer(mnY:mxY,mnX:mxX);
figure, imshow(extractedFlower)
%petalBuffer(mnY:mxY,mnX:mxX) get flower exactly