[imgBinStore, imgStore] = prepareImages();
key = 7;
disp(key);
[N,V,B,C] = getNumOfFlowersM(imgBinStore{key},0); 
%Retain flower
bufferP = B;
compSizeP = getComponentSize(C);

%Sort components by their size
[sortedSizes, srtingIdx] = sort(compSizeP,'descend');

for i = 1:1:C.NumObjects
    if compSizeP(i) ~= sortedSizes(1) %for 7, 2
        bufferP(C.PixelIdxList{i}) = 0;
    end
end
%figure, imshow(bufferP);
% if key == 7
%     bufferP(C.PixelIdxList{2}) = 0;
%     bufferP(C.PixelIdxList{1}) = 1;
% end    
compPT = bwconncomp(bufferP,8);
nOf = compPT.NumObjects; %number of flowers
rC = regionprops(bufferP,'Centroid');%,'MajorAxisLength','MinorAxisLength');
cntr = rC.Centroid;
compSizePT = getComponentSize(compPT);

%EXPERIMENTAL
%20 for 0, 10 for 1, 40 for 2, 7 for 4
Z = [20,10,40,0,7,0,0];
bufferP2 = imerode(bufferP,strel('disk',Z(key),8));
compP2 = bwconncomp(bufferP2,8);
compSizeP2 = getComponentSize(compP2);
% hold on
%imshow(bufferP);
%imshow(bufferP2);
%viscircles(cntr,rdi);
% hold off

[cx cy] = meshgrid(1:size(B,2),1:size(B,1));
mpX = cntr(1);
mpY = cntr(2);
sclF = [1,0.5,1.58,1.6,0.42,1.27,2.8]; %1.6 for image 4
dummy = 0;
%while dummy <= nOf
    removeCenter = sqrt((cx-mpX).^2+(cy-mpY).^2)<=63*sclF(key);
    killEM = and(~removeCenter,bufferP);
    newComp = bwconncomp(killEM,8);
    nOp = newComp.NumObjects*N;
    figure,imshow(killEM)%, hold on
    %%plot(extX,extY,'--')
    %plot(pixX,pixY,'--')
    %hold off;
    %disp(['Using center hole: ', num2str(nOp)]);
    disp(['Number of petals: ', num2str(nOp)]);
%end
