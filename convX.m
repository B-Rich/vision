function convoluted = convX(img,kernel,sigma,gridsz)
%Function that pads an image applies convolution to it with a given kernel

%Get number of rows and columns of original image
[row col depth] = size(img);

paddingSize = [row+2 col+2 depth];

%making a dummy (buffer) matrix to allow zero padding the image
paddedImage = zeros(paddingSize); 

%Default meshgrid size; Gaussian Curve mimic
if nargin < 4
    gridsz = 4;
end

%Default Sigma
if nargin < 3
    sigma = 0.5;
end

%Create Gaussian Kernel
[x,y]=meshgrid(-gridsz:gridsz,-gridsz:gridsz);
gaussKernel = round((exp(-(x.^2+y.^2)/(2*sigma*sigma))/(2*pi*sigma*sigma)),4);

%Normalize the kernel
gaussKernel = gaussKernel / sum(gaussKernel(:));

ngk = gaussKernel(gridsz:gridsz+2,gridsz:gridsz+2); %Gaussian Kernel
lpk = [1 1 1; 1 -8 1; 1 1 1]; %Laplacian Kernel with diagonal detection

for idxDepth = 1:1:size(img,3)
    for idx = 1:1:size(img,1) 
    
    %Copy contents of the original image to the padded image
    paddedImage(idx+1,2:size(paddedImage,2)-1,idxDepth) = img(idx,:,idxDepth);
    
    end
end

SoP = 0; %Sum of products variable to store new point value
if nargin < 2
    disp('No kernel provided, using default filter, identity filter')
    kernel = double([0 0 0; 0 1 0; 0 0 0]);
end
if strcmp(kernel,'gaussian')
    kernel = ngk;
end
if strcmp(kernel,'laplacian')
    kernel = lpk;
end
output = zeros(size(img));
for idxDepth = 1:1:size(paddedImage,3)
    for idxRow = 1:1:size(paddedImage,1)-2
        for idxCol = 1:1:size(paddedImage,2)-2
            temp = paddedImage(idxRow:idxRow+2,idxCol:idxCol+2,idxDepth);
            SoP = dot(temp(:),kernel(:));
            output(idxRow,idxCol,idxDepth) = SoP;
        end
    end
end 
convoluted = uint8(output);
end