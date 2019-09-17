% Encode a frame
% Paramter:
%           f:          frame
%           ftype:      I or P
%           fm:         reference frame for motion estimation
%           fileID:     for write

function D = encode_frame(f,ftype,fm,fileID)

% Frame dimension
[M,N,~] = size(f);
% The number of macroblock in rows and columns
M = M / 16;
N = N / 16;
% Loop over macroblocks
D = zeros(size(f));
mvy = 0;
mvx = 0;
for m = 1:M
    y = 16*(m-1)+1 : 16*(m-1)+16;
    for n = 1:N
        % Encode one macroblock
        x = 16*(n-1)+1 : 16*(n-1)+16;
        % Check if a new GOB starts
        if rem(m,3) == 1 && n == 1
            % First mb in a new GOB
            GOB = 1;
        else
            GOB = 0;
        end
        [D(y,x,:), mvx, mvy] = encode_mb(f(y,x,:),ftype,fm,x,y,fileID, mvx, mvy, GOB);
    end 
end