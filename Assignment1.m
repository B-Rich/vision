file1 = uigetfile({'*.jpg;*.gif;*.bmp;*.tif;*.png;','Image Files'},'Select the first image file');
file2 = uigetfile({'*.jpg;*.gif;*.bmp;*.tif;*.png;','Image Files'},'Select the second image file');
try
img1 = imread(file1);
img2 = imread(file2);
catch
    msgbox('Failed to select image','Error','error');
    return
end

%low pass filter cutoff frequency = 0.707 of total power, 10log(0.5)
%and since the hsize value of the fspecial function for 'gaussian' effect
%cannot be floating point, the cutoff frequency would be 7 = (0.7*10)

kutoffA = str2double(inputdlg('Please insert the first cutoff frequency','First cutoff frequency',[1],{'7'}));
kutoffB = str2double(inputdlg('Please insert the second cutoff frequency','Second cutoff frequency',[1],{'3'}));
krnl1 = fspecial('gaussian',4*kutoffA+1,kutoffA); %1 or 3 would get even numbers
krnl2 = fspecial('gaussian',4*kutoffB+1,kutoffB);
L_1 = imXfilter(img1,krnl1,'replicate');
H_2 = img2 - imXfilter(img2,krnl2,'replicate');
H_X = L_1 + H_2;
figure(1);
title('Hybrid Image');
imshow(H_X);

%high_freq + low_freq = hybrid
%load('-mat','filename') to load function file
%image = imread('cat.jpg');
%val = std2(image);
%FedImageX = imgaussfilt(image,round(std2(image)/6));
%imshow(FedImage)
%size(image,2) , 2 is the size of the second dimension of the matrix, if
%mat = 1024*600 then 2 = 600