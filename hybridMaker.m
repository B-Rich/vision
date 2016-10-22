function hybrid = hybridMaker(img1, img2)
%Hybrid Image maker v2
fimg1 = imgaussfilt(img1,round(std2(img1)));
fimg2 = img2 - imgaussfilt(img2,round(std2(img2)/9));
hybrid = fimg1 + fimg2;
end