img = imread('Final.jpg');
l=0:.001:1;
neg = imcomplement(l); %Negative filter effect
negIm = imcomplement(img);
%plot(x,y)
figure(1)
plot(neg,l);
xlabel('Input');
ylabel('Output');
figure(2)
imshow(negIm);

%the [] in their positions are for normalization (clipping) using full range
%[low_in; high_in], [low_out; high_out]
%if val < low_in, val = low_out & if val > high_in, val = high_out

gammaTrns1 = imadjust(img,[],[],0.4);
gTrns1 = imadjust(l,[],[],0.4);
figure(3)
subplot(2,2,1)
plot(l,gTrns1)
title('\Gamma = 0.4')
figure(4)
subplot(2,2,1)
imshow(gammaTrns1);
title('\Gamma = 0.4')

gammaTrns2 = imadjust(img,[k],[],1);
gTrns2 = imadjust(l,[],[],1);
figure(3)
subplot(2,2,2)
plot(l,gTrns2)
title('\Gamma = 1.0')
figure(4)
subplot(2,2,2)
imshow(gammaTrns2);
title('\Gamma = 1.0')

gammaTrns3 = imadjust(img,[],[],1.6);
gTrns3 = imadjust(l,[],[],1.6);
figure(3)
subplot(2,2,3)
plot(l,gTrns3)
title('\Gamma = 1.6')
figure(4)
subplot(2,2,3)
imshow(gammaTrns3);
title('\Gamma = 1.6')

gammaTrns4 = imadjust(img,[],[],3.2);
gTrns4 = imadjust(l,[],[],3.2);
figure(3)
subplot(2,2,4)
plot(l,gTrns4)
title('\Gamma = 3.2')
figure(4)
subplot(2,2,4)
imshow(gammaTrns4);
title('\Gamma = 3.2')

avg = mean2(img);
i2 = im2double(img);
%contr1 = 1./(1+(avg./(i2+eps)).^4)
contr1 = 1./(1+(mean2(im2double(img))./((im2double(img)+eps)).^4));
figure(8)
imshow(contr1);

imgZ = zeros(128,128);
imgZ(32:96,32:96) = 255;
[g,t]=edge(imgZ,'sobel','vertical');
[g1,t1]=edge(imgZ,'sobel','horizontal');
[g2,t2]=edge(imgZ,'canny',[],1);

figure(9)
imshow(g)

figure(10)
imshow(g1)

figure(11)
imshow(g2)

% for idx = 1:50:255
%     temp=im2double(img);
%     J = idx*log(1+temp);
%     figure(idx+9);
%     imshow(J);
% end    
%imshow((log(1+im2double(img))),[]); normalized output in imshow using
%imshow(image,[])

for idx = 1:9
    filt = {'gaussian', 'sobel', 'prewitt', 'laplacian', 'log', 'average', 'unsharp', 'disk', 'motion'};
    if strcmp(char(filt{idx}),'motion')
      krnl = fspecial(char(filt{idx}),20,45);  
    end  
    krnl = fspecial(char(filt{idx}));
    flt = imfilter(img,krnl);
    figure(20+idx);
    imshow(flt);
end
%for log transform, output = c*log(1+double(input)), 1 is added to handle
%log(0) issues

% gammaTrns5 = imadjust(l,[],[],5);
% subplot(2,2,5)
% plot(l,gammaTrns5)
% title('Fifth subplot')


%for g = 1:.4:6
%gammaTrns = imadjust(l,[],[],g);
%figure
%subplot(2,1,g)  
%plot(gammaTrns,g)
%title(strcat('Subplot',num2str(g)))
%end

%subplot(1,2,1); imshow(imfilter(img,fspecial('prewitt'))); subplot(1,2,2); imshow(imfilter(img,fspecial('sobel')));

