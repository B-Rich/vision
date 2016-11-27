%bwhitmiss, imopen, imclose, imtophat, imbothat, bwperim
close all;
img = imread('4.jpg');
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
binImg = im2bw(grayScale,graythresh(grayScale));
invBinImg = ~binImg;
cc = bwconncomp(binImg,8);
cc2 = bwconncomp(invBinImg,8);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Upper = binImg; 
Upper(cc.PixelIdxList{1}) = 1;
Upper(cc.PixelIdxList{2}) = 0;
Upper(cc.PixelIdxList{3}) = 1;
Upper(cc.PixelIdxList{4}) = 0;
Upper = imdilate(~Upper,strel('disk',10,8));
%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Extract circle to use as mask
BufferU = binImg; 
BufferU(cc.PixelIdxList{1}) = 1;
BufferU(cc.PixelIdxList{2}) = 1;
BufferU(cc.PixelIdxList{3}) = 0;
BufferU(cc.PixelIdxList{4}) = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
Mask = find(BufferU == 1);
Upper(Mask) = 1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%figure, imshow(Upper);
%Upper = imdilate(Upper,strel('disk',50,8));
Lower = ~binImg;
Lower(cc2.PixelIdxList{1}) = 1;
Lower(cc2.PixelIdxList{2}) = 0;
invImg = ~Upper;
BufferL = ~Lower;
Lower = imdilate(BufferL,strel('disk',25,8));
%Upper = Upper.*~Lower; %Yields upper inverted
Upper = ~Upper.*Lower; %lower with dark
Upper = imdilate(Upper,strel('disk',15,8));%imdilate(~Upper,strel('disk',20,8));
%%%%%%%%%%%%
%%%%%%%%%%%%
figure,
subplot(1,3,1), imshow(Lower,[]), title('Yin');
subplot(1,3,2), imshow(Upper,[]), title('Yang');
subplot(1,3,3), imshow(binImg,[]), title('Yinyang');