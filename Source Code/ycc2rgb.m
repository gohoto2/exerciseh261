function rgb = ycc2rgb(ycc)

[h,w,~] = size(ycc);
rgb = zeros(h,w,3);

for i = 1:w
    for j = 1:h
        rgb(j,i,1) = ycc(j,i,1) + 1.400*ycc(j,i,3);
        rgb(j,i,2) = ycc(j,i,1) - 0.343*ycc(j,i,2) - 0.711*ycc(j,i,3);
        rgb(j,i,3) = ycc(j,i,1) + 1.765*ycc(j,i,2);
    end
end
