function sImg = restoreImage(imgN)
img = imread(imgN);
if size(img,3) == 3
    grayScale = rgb2gray(img);
else
    grayScale = img;
end
pad = getDFTPad(size(grayScale)); %Pad image as needed
switch imgN
    case 'Fruit.bmp'
        D0 = 0.07*pad(1); %Determine cutoff frequency 
		FreqImg = fft2(double(grayScale),pad(1),pad(2)); %Fourier Transform of image
        AugFilt = bandFilter('Gaussian',pad(1),pad(2),D0,200,'Reject'); %Filter used
    case 'Guess.bmp'
		pad = [256 256];
		FreqImg = fft2(double(grayScale),pad(1),pad(2));
        D0 = 0.02*pad(1);
        str = 'Gaussian';
		G = 1;
        F1 = notchFilt(str,pad(1),pad(2),D0,35,-35);
        F2 = notchFilt(str,pad(1),pad(2),D0,-35,-35);
        F3 = notchFilt(str,pad(1),pad(2),D0,-35,35);
        F4 = notchFilt(str,pad(1),pad(2),D0,35,35);
        F5 = notchFilt(str,pad(1),pad(2),D0,20,0);
        F6 = notchFilt(str,pad(1),pad(2),D0,-20,0);
        F7 = notchFilt(str,pad(1),pad(2),D0,0,20);
        F8 = notchFilt(str,pad(1),pad(2),D0,0,-20);
        F9 = notchFilt(str,pad(1),pad(2),D0,30,30);
        F0 = notchFilt(str,pad(1),pad(2),D0,-30,-30);
        AugFilt = ones(size(F1)).*F0.*F1.*F2.*F3.*F4.*F5.*F6.*F7.*F8.*F9.*G;
    case 'Apollo17.bmp'
        D0 = 0.05*pad(1);
		FreqImg = fft2(double(grayScale),pad(1),pad(2));
        AugFilt = bandFilter('Ideal',pad(1),pad(2),D0*3,450,'Reject','Unshifted',5);
end
filteredImg = FreqImg.*AugFilt; %Apply filter to image
spatialImg = real(ifft2(filteredImg)); %Return image to spatial domain
spatialImg = spatialImg(1:size(grayScale,1),1:size(grayScale,2)); %Trim padding
sImg = [uint8(spatialImg), grayScale];
figure, %Display image before and after restoration
subplot(1,2,1), imshow(uint8(spatialImg),[]);
subplot(1,2,2), imshow(grayScale,[]);
end