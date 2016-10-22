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

gammaTrns2 = imadjust(img,[],[],1);
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

