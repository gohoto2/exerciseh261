function ret = merge(mov, nf)
A = imread('a.png');
f = 0;
h = waitbar(0,'Please wait...', 'Name', 'Merging');
while (f <= nf)
    for i=0:3
        ypos = i*64;
        for j=0:8
            xpos = j*64;
            f = f + 1;
            if (f >nf)
                break;
            end
            mov(f).cdata = Sprite(mov, A, xpos, ypos, f);
            waitbar(f/nf);
        end
    end
end
close(h);
ret = mov;