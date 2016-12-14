close all;
[bin, imgs] = prepareImages(0);
key = 5;
binPImg = imerode(bin{key},strel('disk',2,8));
%binPImg = bwmorph(binPImg,'fill');
compP = bwconncomp(binPImg,8);

%Buffer to perform operations for extracting petals
bufferP = binPImg;
compSizeP = getComponentSize(compP);

%Sort components by their size
[sortedSizes, srtingIdx] = sort(compSizeP,'descend');

%Retain flower
for i = 1:1:compP.NumObjects
    if compSizeP(i) ~= sortedSizes(1) %for 7, 2
        bufferP(compP.PixelIdxList{i}) = 0;
    end
end
figure, imshow(bufferP);
compPT = bwconncomp(bufferP,8);
nOf = compPT.NumObjects; %number of flowers
rC = regionprops(bufferP,'Centroid');%,'MajorAxisLength','MinorAxisLength');
rPix = regionprops(bufferP,'PixelList');
pixX = rPix.PixelList(:,1);
pixY = rPix.PixelList(:,2);
rPer = regionprops(bufferP,'Perimeter');
rArea = regionprops(bufferP,'Area');
rExt = regionprops(bufferP,'Extent');
rExtrm = regionprops(bufferP,'Extrema');
extX = rExtrm.Extrema(:,1);
extY = rExtrm.Extrema(:,2);
cntr = rC.Centroid;
rdi = (mean([rC.MajorAxisLength, rC.MinorAxisLength],2))/2;
compSizePT = getComponentSize(compPT);

%EXPERIMENTAL
%20 for 0, 10 for 1, 40 for 2, 7 for 4
Z = [20,10,40,0,7,0,0];
bufferP2 = imerode(bufferP,strel('disk',Z(key),8));
compP2 = bwconncomp(bufferP2,8);
compSizeP2 = getComponentSize(compP2);
hold on
%imshow(bufferP);
imshow(bufferP2);
%viscircles(cntr,rdi);
hold off

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
    disp(['Number of petals ',num2str(nMax*compP2.NumObjects)])
else
    disp(['Number of petals ',num2str(compP2.NumObjects)])
end






%%%%%%%%%%%%%%%%%%%%%
[cx cy] = meshgrid(1:size(binPImg,2),1:size(binPImg,1));
cAcc = zeros(size(binPImg)); %accumilate circles
mpX = cntr(1);
mpY = cntr(2);
sclF = [1,0.5,1.58,1.6,0.42]; %1.6 for image 4
dummy = 0;
%while dummy <= nOf
    removeCenter = sqrt((cx-mpX).^2+(cy-mpY).^2)<=63*sclF(key);
    killEM = and(~removeCenter,bufferP);
    newComp = bwconncomp(killEM,8);
    nOp = newComp.NumObjects;
    figure,imshow(killEM), hold on
    %%plot(extX,extY,'--')
    %plot(pixX,pixY,'--')
    hold off;
    disp(['Using center hole: ', num2str(nOp*nMax)]);
%end
%Get value and index of minimas and maximas
[mnX, mnXi] = getMinMax(pixX,'min'); 
[mnY, mnYi] = getMinMax(pixY,'min');
[mxX, mxXi] = getMinMax(pixX,'max');
[mxY, mxYi] = getMinMax(pixY,'max');
% % plot(crnrs(mnXi));
% % plot(crnrs(mnYi));
% % plot(crnrs(mxXi));
% % plot(crnrs(mxYi));

% %Get value and index of highest metric
% [mxM, mxMi] = getMinMax(crnrsMet,'max'); 
% 
% crnrs(mnXi).Metric = mxM;
% crnrs(mnYi).Metric = mxM;
% crnrs(mxXi).Metric = mxM;
% crnrs(mxYi).Metric = mxM;
