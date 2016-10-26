function fImg = imXfilter(img, krnl, paddingType)

%Custom imfilter function

%In case of 4x5 or any even size matrix 

if(mod((size(krnl,1)*size(krnl,2)),2) == 0) %~mod(n*m,2)
    msgbox('Filter matrix must be odd','Error','error');
    error('Filter matrix must be odd');
end    

%buffer (temp) matrix with size of image all filled with zeros

buffer = zeros(size(img)); 

%padsize need by padarray() 
%where the first number represents number of elements of padding to the end of the first dimension of the array 
%and the second number represents number of elements of padding to the end of the second dimension of the array

padsize = [((size(krnl,1)-1)/2) ((size(krnl,2)-1)/2)]; 

%To allow default value for paddingType, default = zero padding

if nargin < 3 
  paddingType = 'zero';
end
 
%To allow default value for krnl(filter), deafult = identity filter

if nargin < 2
  krnl = fspecial('gaussian',1,1);
end

%To support grayscale and colored images 
%if grayscale, size(image,3) = 1
%if color image, size(image,3) = 3

for idx = 1:size(img,3)
    if strcmp(paddingType, 'zero')
        paddedImg = padarray(img(:, :, idx), padsize);
    end    
    if strcmp(paddingType, 'replicate') || strcmp(paddingType, 'duplicate')
        paddedImg = padarray(img(:, :, idx), padsize, 'symmetric');
    end
    
    %dot product the padded image (in the form of a vector) with the kernel/filter
    
    columned = double(krnl(:))'*double(im2col(paddedImg, size(krnl), 'sliding'));
    buffer(:,:,idx) = double(col2im(double(columned), [1 1], [size(img,1) size(img,2)], 'sliding'));
end
fImg = buffer;
end
