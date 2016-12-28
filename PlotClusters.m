load data;
load dataNew;
data = [data(:,3), data(:,4)];
dataNew = [dataNew(:,3), dataNew(:,4)];
[class, cent, pts, d] = KmeansCluster(data,3);
%cb = knnX(dataNew,data,cent,1);
%[newClass, dist] = KNNClassify(dataNew,data,cent,3);
%[newClass, cb] = knnX(dataNew,dataBuff,cent,class,3);
Untitled16
figure;
plot(data(class==1,1),data(class==1,2),'ro','MarkerSize',12)
hold on
plot(dataNew(newClass==1,1),dataNew(newClass==1,2),'r*','MarkerSize',12)
plot(data(class==2,1),data(class==2,2),'go','MarkerSize',12)
plot(dataNew(newClass==2,1),dataNew(newClass==2,2),'g*','MarkerSize',12)
plot(data(class==3,1),data(class==3,2),'bo','MarkerSize',12)
plot(dataNew(newClass==3,1),dataNew(newClass==3,2),'b*','MarkerSize',12)
title 'Clusters'
hold off