% Encode video frames
% Parameter:
%           mov - whole video frames

function h261 = compress(mov,nf)

% Frame dimension
[h, w, ~, ~] = size(mov);
% Frame type pattern
fpat = 'IPPP';
% frame memory for motion estimation
fm = [];

% Write
fileID = fopen('cmpt365.mrg','w');

% Save frame dimension
fwrite(fileID, w, 'uint8');
fwrite(fileID, h, 'uint8');
% Save # of frames
fwrite(fileID, nf, 'uint8');

k = 0;
s = length(fpat);
% Loop over frames
h = waitbar(0,'Please wait...', 'Name', 'Encoding');
l = size(mov,4);
for i = 1:nf 
    % Get frame
    f = double(mov(:,:,:,i));
    % Convert frame to YCbCr
    f = rgb2ycc(f);
    % Get frame type
    ftype = fpat(mod(k,s)+1);
    k = k + 1;
    % Add a frame type in a frame header
    fwrite(fileID,ftype,'char*1');
    % Encode each frame
    fm = encode_frame(f,ftype,fm,fileID);
    waitbar(i/l);
end
close(h);
fclose(fileID);