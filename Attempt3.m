close all;
img = imread('3.jpg');
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
binImg = im2bw(grayScale,graythresh(grayScale));
invBinImg = ~binImg;
cc = bwconncomp(binImg,8);
cc2 = bwconncomp(invBinImg,8);

%Extract Yang part
Upper = binImg; 
Upper(cc.PixelIdxList{1}) = 1;
Upper(cc.PixelIdxList{2}) = 0;

%Create mask for Yang part
BufferU = ~binImg; 
BufferU(cc2.PixelIdxList{1}) = 1;
BufferU(cc2.PixelIdxList{2}) = 0;
BufferU = immorphgrad(binImg,strel('disk',5,8));
BufferU = bwmorph(BufferU,'fill');
BufferU = imfill(BufferU,'holes');

%Apply mask to image to extract Yang
Upper = and(BufferU,Upper);
Upper = imerode(Upper,strel('disk',4,8));


%Extract Yin
Lower = ~binImg;
Lower(cc2.PixelIdxList{1}) = 1;
Lower(cc2.PixelIdxList{2}) = 0;
BufferL = ~Lower;
Lower = imdilate(BufferL,strel('disk',2,8));

figure,
subplot(1,3,1), imshow(Lower,[]), title('Yin');
subplot(1,3,2), imshow(Upper,[]), title('Yang');
subplot(1,3,3), imshow(binImg,[]), title('Yinyang');