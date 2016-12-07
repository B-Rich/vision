function componentSize = getComponentSize(comp)
compSize = zeros(size(comp.NumObjects));
for idx = 1:1:comp.NumObjects
     compSize(idx) = numel(comp.PixelIdxList{idx});
end
componentSize = compSize;
end