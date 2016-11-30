function [Yin, Yang] = SplitYinYang(Image)

%Function that splits Yinyang image using morphology

img = imread(Image);
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
binImg = im2bw(grayScale,graythresh(grayScale));
invBinImg = ~binImg;
cc = bwconncomp(binImg,8);
cc2 = bwconncomp(invBinImg,8);

switch Image
    case '1.png'
        Yang = binImg;
        Yang(cc.PixelIdxList{1}) = 0;
        Yang(cc.PixelIdxList{3}) = 0;
        
        Yin = ~binImg;
        Yin(cc2.PixelIdxList{1}) = 1;
        Yin(cc2.PixelIdxList{2}) = 0;
        
        invImg = ~Yang;
        Buffer = ~Yin;
        Yin = imdilate(Buffer,strel('disk',2,8));
    case {'2.jpg','3.jpg'}
        %Extract Yang part
        Yang = binImg;
        Yang(cc.PixelIdxList{1}) = 1;
        Yang(cc.PixelIdxList{2}) = 0;
        
        %Create mask for Yang part
        BufferU = ~binImg;
        BufferU(cc2.PixelIdxList{1}) = 1;
        BufferU(cc2.PixelIdxList{2}) = 0;
        BufferU = immorphgrad(binImg,strel('disk',5,8));
        BufferU = bwmorph(BufferU,'fill');
        BufferU = imfill(BufferU,'holes');
        
        %Apply mask to image to extract Yang
        Yang = and(BufferU,Yang);
        Yang = imerode(Yang,strel('disk',4,8));
        
        
        %Extract Yin
        Yin = ~binImg;
        Yin(cc2.PixelIdxList{1}) = 1;
        Yin(cc2.PixelIdxList{2}) = 0;
        BufferL = ~Yin;
        Yin = imdilate(BufferL,strel('disk',2,8));
    case '4.jpg'
        Yang = binImg;
        Yang(cc.PixelIdxList{1}) = 1;
        Yang(cc.PixelIdxList{2}) = 0;
        Yang(cc.PixelIdxList{3}) = 1;
        Yang(cc.PixelIdxList{4}) = 0;
        Yang = imdilate(~Yang,strel('disk',10,8));
        
        %Extract circle to use as mask
        BufferU = binImg;
        BufferU(cc.PixelIdxList{1}) = 1;
        BufferU(cc.PixelIdxList{2}) = 1;
        BufferU(cc.PixelIdxList{3}) = 0;
        BufferU(cc.PixelIdxList{4}) = 0;
        
        Mask = find(BufferU == 1);
        Yang(Mask) = 1;
        
        Yin = ~binImg;
        Yin(cc2.PixelIdxList{1}) = 1;
        Yin(cc2.PixelIdxList{2}) = 0;
        invImg = ~Yang;
        BufferL = ~Yin;
        Yin = imdilate(BufferL,strel('disk',25,8));
        
        Yang = ~Yang.*Yin; %lower with dark
        Yang = imdilate(Yang,strel('disk',15,8));
end

figure,
subplot(1,3,1), imshow(Yin,[]), title('Yin');
subplot(1,3,2), imshow(Yang,[]), title('Yang');
subplot(1,3,3), imshow(binImg,[]), title('Yinyang');
end