% Do motion estimation and return motion vectors
% Parameter:
%           cmb:    current macroblock
%           fmy:    Y component of the reference framce 
%           x:      x coordinate
%           y:      y coordinate

function [mvx, mvy] = motion_estimation(cmby,fmy,x,y)

% Get a motion vector for a Y component


[M,N] = size(fmy);

% Logarithmic search
% Window search range: p = 15
% Initial step size is ceil(15/2) = 8
offset = 8;
saved_mad = inf;
center = [0, 0];
while offset >= 1
    min_mad = inf;
    for i = -offset:offset:offset
        ny = y + i + center(1);
        if (ny(1) < 1 || M < ny(end))
            continue;
        end
        for j = -offset:offset:offset
            nx = x + j + center(2);
            if (nx(1) < 1 || N < nx(end))
                continue;
            end
            if (i == 0 && j ==0 && offset ~= 8)
                mad = saved_mad;
            else
                
             mad = MAD(cmby,fmy,nx,ny);
            
            end
            if mad < min_mad
                min_mad = mad;
                hit = [i,j];
            end            
        end
    end
    saved_mad = min_mad;
    center = center + hit;
    offset = offset / 2;
end

mvy = center(1);
mvx = center(2);



function err = MAD(cmby, fmy, nx, ny)

% Mean Absolute Difference  
err = sum(sum(abs(cmby-fmy(ny,nx))))/(16*16);
