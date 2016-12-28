function[clustBuff, Centroid, numOfPts, Decoy]= KmeansCluster(data, k)

numOfFeats = size(data,2);
numOfObs = size(data,1);

%
%Randomly initialize the centroids per feature
minData = min(data);
maxData = max(data);
diffData = maxData - minData ;
Centroid = ones(k,numOfFeats) .* rand(k,numOfFeats);
for idx=1:1:k
    Centroid(idx,:) = Centroid(idx,:).* diffData;
    Centroid(idx,:) = Centroid(idx,:)+ minData;
end

change = 1;
% Loop until Mold == Mnew
while change > 0.0
    
    %Assignment
    clustBuff = []; Decoy = [];
    %At least one class would exist
    for idx = 1:1:numOfObs;
        minDiff =(data(idx, :) - Centroid(1,:));
        minDiff = minDiff * minDiff';
        curClustAsgn = 1;
        Decoy(idx) = minDiff;
        
        %Class assignment
        for class = 2:1:k;
            diffClass =(data(idx,:) - Centroid(class,:));
            diffClass = diffClass * diffClass';
            if(minDiff >= diffClass)
                curClustAsgn = class;
                minDiff = diffClass;
            end
            Decoy(class) = minDiff;
        end
        
        %Position point in cluster
        clustBuff = [clustBuff; curClustAsgn];
        
    end
    
    oldMeans = Centroid;
    
    % New means
    Centroid = zeros(k, numOfFeats);
    numOfPts = zeros(k, 1);
    
    for idx = 1:1:length(clustBuff);
        Centroid(clustBuff(idx),:) = Centroid(clustBuff(idx),:) + data(idx,:);
        numOfPts(clustBuff(idx),1) = numOfPts(clustBuff(idx),1) + 1;
    end
    
    for class = 1:1:k;
        if(numOfPts(class,1) ~= 0)
            Centroid(class,:) = Centroid(class,:)/numOfPts(class, 1);
        else
            Centroid(class,:) =(rand(1,numOfFeats).* diffData) + minData;
        end
    end
    
    change = sum(sum((Centroid - oldMeans).^2));
    
end
end