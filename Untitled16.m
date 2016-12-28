% data = [data(:,3), data(:,4)];
% dataNew = [dataNew(:,3), dataNew(:,4)];
k = 3;
distAcc = []; augDist = [];
for idx = 1:1:size(dataNew,1)
    for iIdx = 1:1:size(data,1)
        dist = eucDist(dataNew(idx,:),data(iIdx,:),size(dataNew,2));
        distAcc(iIdx) = dist;
    end
    augDist(idx,:) = distAcc;
end

sortedData = []; sortedIdx = []; closestBuff = [];
for idx = 1:1:size(augDist,1)
    row = augDist(idx,:);
    [sortedData(idx,:), sortedIdx(idx,:)] = sort(row);
    closestBuff(idx,:) = [sortedData(idx,1:k), sortedIdx(idx,1:k)];
end
indicies = closestBuff(:,k+1:end);
newClass = []; classified = [];
for l = 1:1:length(indicies)
    for o = 1:1:k
        idx = indicies(l,o);
        newClass(l,o) = class(idx);
    end
end
for l = 1:1:length(indicies)
    classified(l) = mode(newClass(l,:));
end
newClass = classified(:);
