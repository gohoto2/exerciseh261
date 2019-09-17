% Merge sprite with a frame
% Input:
%       mov:    frame collection
%       A:      sprite sheet
%       xpos:   x coordinate of a sprite to merge 
%       ypos:   y coordinate
%       n:      frame # to merge


function F =  Sprite(mov, A, xpos, ypos, n)

% Get a srite from the sprite sheet
RGB = imcrop(A, [xpos, ypos, 64, 64]);
B = RGB;
[r c z] = size(RGB);

% Get a frame from video
F = mov(n).cdata;
[R C Z] = size(F);

% x,y positions where each sprite is merged (center)
x1 = floor(R/2 - r/2);
y1 = floor(C/2 - c/2);
x2 = x1 + r;
y2 = y1 + c;

% Create Mask
for i=1:r
    for j=1:c
        if (RGB(i,j,1)== 0 && RGB(i,j,2)== 0 && RGB(i,j,3)== 0)
            RGB(i,j,1)= 255;
            RGB(i,j,2)= 255;
            RGB(i,j,3)= 255;
        else
            RGB(i,j,1)=0; RGB(i,j,2)=0; RGB(i,j,3)=0;
        end
    end
end

% Merge frames
for i=1:R
    for j=1:C
        if (i >x1 && i <= x2 && j >y1 && j <= y2)
            % Merge a frame and the mask by AND operation
            F(i,j,:) = bitand(F(i,j,:), RGB(i-x1,j-y1,:));
            % Merge the masked frame and sprite by OR operation
            F(i,j,:) = bitor(F(i,j,:), B(i-x1,j-y1,:));
        end
    end
end
