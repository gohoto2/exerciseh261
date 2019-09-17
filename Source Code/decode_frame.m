% this function decodes each frame
% Input:
%       fileID: binary file to read
%       ftype:  frame type (I or P)
%       fm:     reference frame
%       w:      width of frame
%       h:      height of frame

function fr = decode_frame(fileID,ftype,fm,w,h)

zigzag = [1,  2,  9, 17,  10,  3,  4, 11, ...
          18, 25, 33, 26, 19, 12,  5,  6, ...
          13, 20, 27, 34, 41, 49, 42, 35, ...
          28, 21, 14,  7,  8, 15, 22, 29, ...
          36, 43, 50, 51, 58, 51, 44, 37, ...
          30, 23, 16, 24, 31, 38, 45, 52, ...
          59, 60, 53, 46, 39, 32, 40, 47, ...
          54, 61, 62, 55, 48, 56, 63, 64];
      
% Loop over macroblocks
fr = zeros(h,w,3);
mb = zeros(8,8,6);
temp = zeros(1,64);

M = h / 16;
N = w / 16;

for m = 1:M
    y = 16*(m-1)+1 : 16*(m-1)+16;
    for n = 1:N
        
        mvx = double(fread(fileID, 1, 'integer*1'));
        mvy = double(fread(fileID, 1, 'integer*1'));
        
        if rem(m,3) == 1 && n == 1                          
            pmvx = mvx;
            pmvy = mvy;
        else
            mvx = pmvx - mvx;
            mvy = pmvy - mvy;
            pmvx = mvx;
            pmvy = mvy;
        end              
        
        for k = 1:6
            raw = double(fread(fileID, 64, 'int16'));
            for jj = 1:64
                temp(zigzag(jj)) = raw(jj);
            end
            wow = reshape(temp, [8, 8]);
            mb(:,:,k) = wow';
        end
        x = 16*(n-1)+1 : 16*(n-1)+16;
        fr(y,x,:) = decode_mb(mb,fm,x,y,ftype,mvx,mvy);       
    end 
end