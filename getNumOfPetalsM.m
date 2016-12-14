function [nOp, petalImg] = getNumOfPetalsM(key,dFlag)
[imgBinStore, imgStore] = prepareImages();
[N,V,B,C] = getNumOfFlowersM(imgBinStore{key},0); 

%Buffer for petal processing
bufferP = B;
compSizeP = getComponentSize(C);

%Sort components by their size
[sortedSizes, srtingIdx] = sort(compSizeP,'descend');

%Retain a single flower only
for i = 1:1:C.NumObjects
    if compSizeP(i) ~= sortedSizes(1)
        bufferP(C.PixelIdxList{i}) = 0;
    end
end
 
%Get center of flower
rC = regionprops(bufferP,'Centroid');
cntr = rC.Centroid;

[cx cy] = meshgrid(1:size(B,2),1:size(B,1));
mpX = cntr(1);
mpY = cntr(2);
sclF = [1,0.5,1.58,1.6,0.42,1.27,2.8];
dummy = 0;
%while dummy <= nOf
    removeCenter = sqrt((cx-mpX).^2+(cy-mpY).^2)<=63*sclF(key);
    petalImg = and(~removeCenter,bufferP);
    newComp = bwconncomp(petalImg,8);
    nOp = newComp.NumObjects*N;
	if dFlag
		figure,imshow(petalImg);
	end
    disp(['Number of petals: ', num2str(nOp)]);
end
