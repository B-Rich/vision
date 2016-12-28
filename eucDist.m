function dist = eucDist(i1, i2,len)
temp = 0;
for idx = 1:1:len
    temp = temp + (i1(idx)-i2(idx))^2;
end
dist = sqrt(temp);
end