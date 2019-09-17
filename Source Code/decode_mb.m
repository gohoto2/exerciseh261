% This fuction decodes each macroblock
% Input:
%       mb:     current macroblock to decode
%       fm:     refernce frame
%       x:      x cooridnates of mb in a target frame
%       y:      y coordinates "
%       ftype:  frame type
%       mvx:    horizontal motion vector for mb
%       mvy:    vertical motion vector for mb

function ret = decode_mb(mb,fm,x,y,ftype,mvx,mvy)
P = zeros(16, 16, 3);
if ftype == 'P'
    % Prediction
    P = fm(y+mvy,x+mvx,:);
end
b = zeros(8,8,6);
coef = zeros(8,8);
% Decode blocks
scale = 31;
for i = 1:6
    if ftype == 'P'
        for s = 1:8
            for k = 1:8
                % Quantized DCT coeficients of P type were floored
                % toward zeros (center dead zone). Add +- 0.5 back to coef 
                if mb(s,k,i) == 0
                    coef(s,k) = 0;
                elseif mb(s,k,i) > 0
                    coef(s,k) = (mb(s,k,i) + 0.5) * 2*scale;
                else
                    coef(s,k) = (mb(s,k,i) - 0.5) * 2*scale;
                end
            end
        end
        
    else
        % I typoe coef
        coef = mb(:,:,i) .* 8;
    end
    % Peform IDCT
    b(:,:,i) = idct(idct(coef.').');
end

ret = zeros([16, 16, 3]);

% Four Y blocks
ret( 1:8,  1:8,  1) = b(:,:,1);
ret( 1:8,  9:16, 1) = b(:,:,2);
ret( 9:16, 1:8,  1) = b(:,:,3);
ret( 9:16, 9:16, 1) = b(:,:,4);

% Upsampling CbCr blocks
ret(:,:,2) = kron(b(:,:,5),[1, 1;1 ,1]);
ret(:,:,3) = kron(b(:,:,6),[1, 1;1 ,1]);
% Restore mb for future frames
ret = ret + P;