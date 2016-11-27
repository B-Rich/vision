close all;
img = imread('1.png');
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
binImg = im2bw(grayScale,graythresh(grayScale));
invBinImg = ~binImg;
cc = bwconncomp(binImg,8);
cc2 = bwconncomp(invBinImg,8);
%pix = cellfun(@numel,cc.PixelIdxList);
% hash = [];
% for idx = 1:1:cc.NumObjects
%     hash(idx) = prod(size(cc.PixelIdxList{idx}));
% end
% [maxVal idxOfMax] = max(hash);
% hash(idxOfMax) = 0;
% [newMaxVal newIdxOfMax] = max(hash);
Upper = binImg;
Upper(cc.PixelIdxList{1}) = 0;
Upper(cc.PixelIdxList{3}) = 0;
Lower = ~binImg;
Lower(cc2.PixelIdxList{1}) = 1;
Lower(cc2.PixelIdxList{2}) = 0;
invImg = ~Upper;
Buffer = ~Lower;%(~(~Lower.*invImg))-(~binImg); %preserve lower circle
Lower = imdilate(Buffer,strel('disk',2,8));
figure,
subplot(1,3,1), imshow(Lower,[]), title('Yin');
subplot(1,3,2), imshow(Upper,[]), title('Yang');
subplot(1,3,3), imshow(binImg,[]), title('Yinyang');