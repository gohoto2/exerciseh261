function ret = subsample(mb)
[M, N] = size(mb);
ret = zeros(8,8);
k = 1;
s = 1;
for i = 1:8
    for j = 1:8
        a = mb(k,s);
        s = s + 1;
        b = mb(k,s);
        k = k + 1;
        s = s - 1;
        c = mb(k,s);
        s = s + 1;
        d = mb(k,s);
        k = k - 1;
        s = s + 1;
        ret(i,j) = (a+b+c+d)/4;
    end
    k = k + 2;
    s = 1;
end