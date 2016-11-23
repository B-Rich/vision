function sImg = restoreImageX(imgN)
img = imread(imgN);
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
pad = getDFTPad(size(grayScale)); %Pad image as needed
FreqImg = fft2(double(grayScale));%,pad(1),pad(2));
VisFor = log(1+fftshift(abs(FreqImg)));
Peaks = max(VisFor);
Noise = imcomplement(VisFor < min(Peaks));%imresize(log(1+fftshift(abs(FreqImg))),2.5);
Noise = imerode(Noise,strel('disk',3,8));
Noise = imdilate(Noise,strel('disk',6,8));
[c, r] = imfindcircles(Noise,[5 10],'ObjectPolarity','bright','Sensitivity',0.94);
pX = c(:,1);
pY = c(:,2);%Temp = sqrt((x-(size(grayScale,1)/2)).^2 + (y-(size(grayScale,2)/2)).^2)<=
oX = size(Noise,1)/2;
oY = size(Noise,2)/2;
DTest = sqrt((pX-oX).^2 + (pY-oY).^2)<=((size(Noise,2)/2.35)+max(r));
for idx = 1:1:size(DTest,1)
    if(DTest(idx) == 0)
        pX(idx) = 0;
        pY(idx) = 0;
        r(idx) = 0;
    end
end
R = r(r~=0); PX = pX(pX~=0); PY = pY(pY~=0);
figure, imshow(Noise,[]); 
viscircles(c,r,'EdgeColor','b');
DistX = round(PX-oX); DistY = round(PY-oY);
AugFilt = ones(size(Noise)); type = 'Gaussian';
pad2 = size(Noise);
for idx = 1:1:size(DistX,1)
    AugFilt = AugFilt.*notchFilt(type,pad2(1),pad2(2),2*R(idx),DistX(idx),DistY(idx));
end
filteredImg = FreqImg.*AugFilt;
figure(12), imshow(fftshift(log(1+abs(filteredImg))),[]);
spatialImg = real(ifft2(filteredImg));
spatialImg = spatialImg(1:size(grayScale,1),1:size(grayScale,2));
figure(8), 
subplot(1,2,1), imshow(uint8(spatialImg),[]);
subplot(1,2,2), imshow(grayScale,[]);
sImg = [spatialImg, grayScale];
end