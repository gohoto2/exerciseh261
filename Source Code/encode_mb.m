% Encode a macroblock
% Parameter:
%               cmb:    current macroblock
%               ftype:  I or P
%               fm:     reference frame
%               x:      x coordinate (16 points)
%               y:      y coordinate (16 points)
%               fileID: for write to a file
%               pmvx:   mvx for the previous mb
%               pmvy:   mvy for the previous mb
%               GOB:    1 if first mb in a GOB, 0 if not
%               
function [dmb, mvx, mvy] = encode_mb(cmb,ftype,fm,x,y,fileID, pmvx, pmvy, GOB)
% I type frames have no motion vectors
mvx = 0;
mvy = 0;
% Find motion vectors
if ftype == 'P'
    % Y components of current block and reference frame
    fmy = fm(:,:,1); 
    cmby = cmb(:,:,1);
    % Find motion vectors for the Y component only
    [mvx, mvy] = motion_estimation(cmby,fmy,x,y);  
    % Get prediction error for all components
    % For CrCb components, get prediction errors from the motion vector ...
    % from the Y component, and they will get subsampled later on 
    cmb = cmb - fm(y+mvy,x+mvx,:);
    
end

if GOB == 1 % The first macroblock in each GOB
    fwrite(fileID, mvx, 'int8');
    fwrite(fileID, mvy, 'int8');
else
    % Send MVD = MVpreceed - MVcurrent to output stream
    mvdx = pmvx - mvx;
    mvdy = pmvy - mvy;
    fwrite(fileID, mvdx, 'int8');
    fwrite(fileID, mvdy, 'int8');
end
    
% Get lum and chrom blocks
b = zeros([8, 8, 6]);

% Four lum blocks
b(:,:,1) = cmb( 1:8,  1:8,  1);
b(:,:,2) = cmb( 1:8,  9:16, 1);
b(:,:,3) = cmb( 9:16, 1:8,  1);
b(:,:,4) = cmb( 9:16, 9:16, 1);

% Subsampling CbCr blocks
b(:,:,5) = subsample(cmb(:,:,2));
b(:,:,6) = subsample(cmb(:,:,3));
% zigzag order
zigzag = [ 1,  2,  9, 17, 10,  3,  4, 11, ...
          18, 25, 33, 26, 19, 12,  5,  6, ...
          13, 20, 27, 34, 41, 49, 42, 35, ...
          28, 21, 14,  7,  8, 15, 22, 29, ...
          36, 43, 50, 51, 58, 51, 44, 37, ...
          30, 23, 16, 24, 31, 38, 45, 52, ...
          59, 60, 53, 46, 39, 32, 40, 47, ...
          54, 61, 62, 55, 48, 56, 63, 64];

% Encode blocks
% Constant step_size to keep simplicity: step_size = 62
scale = 31;
for i = 1:6
    % 2D DCT
    coef = b(:,:,i);
    coef = dct(dct(coef.').');
    % Quantization
    if ftype == 'P'
        for s = 1:8
            for k = 1:8
                if coef(s,k) > 0
                    coef(s,k) = floor(coef(s,k) / (2*scale) );
                else
                    coef(s,k) = ceil(coef(s,k) / (2*scale) );
                end
            end
        end
    else
        coef = round(coef ./ 8);
    end
    c(:,:,i) = coef;
    coef = reshape(coef',1,64);
    % Zigzag scan
    for j = 1:64
        const = (coef(zigzag(j)));
        fwrite(fileID, const, 'int16');
    end
end
% Decode this macroblock for reference by a future P frame
dmb = decode_mb(c,fm,x,y,ftype,mvx,mvy);
