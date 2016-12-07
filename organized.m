imgNums = [0,1,2,3,4,6,7];
imgName = cell(size(imgNums));
rgbFlag = 0;
for i = 1:1:size(imgNums,2)
    cImgNm = num2str(imgNums(i));
    imgName{i} = strrep('testcase *.jpg','*',cImgNm);
    %disp(imgName{i})
end
%Create placeholder for input images
imgStore = cell(size(imgNums)); %rgb2hsv(imread(imgName{1}));

%Create placeholder for binary images
imgBinStore = cell(size(imgNums));

%Choose proper channel for processing
for i = 1:1:size(imgNums,2)
    currImg = imgName{i};
    imgStore{i} = rgb2hsv(imread(currImg));
    if rgbFlag
        imgStore{i} = rgb2gray(imread(currImg),graythrash(imread(currImg)));
    end
    switch i
        case 1
            if ~rgbFlag
            imgBinStore{i} = ~im2bw(imgStore{i}(:,:,2));
            end
        case 3
            imgBinStore{i} = im2bw(imgStore{i}(:,:,1));
        otherwise
            if ~rgbFlag
              imgBinStore{i} = im2bw(imgStore{i}(:,:,3));
            else
              imgBinStore{i} = im2bw(imgStore{i});  
            end
    end
end

