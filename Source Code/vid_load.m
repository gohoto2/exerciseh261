% Parameters: 
%           Filename = the file name of an uncompressed video in .Y4m
%           extension
%           width = the width of frames
%           height = the height of frames
%           nof = the number of frames in a video

function mov = vid_load(Filename, type, nof)

if type == 'QCIF'
    width = 176;
    height = 144;
elseif type == 'CIF'
    width = 352;
    height = 288;
else
    fprintf('Not Supported\n');
end

% Open an uncompressed video included
vid = fopen(Filename, 'r');
% Read a file header
header = fgetl(vid);
% Progress bar
h = waitbar(0,'Please wait...', 'Name', 'Video Loading');
for i = 1:nof      
    % Read a frame header
    header = fgetl(vid);  
    % Read Y component
    Y = fread(vid, width * height, 'uint8');
    % Reshape a 1D array into a 2D array
    YUV(:, :, 1) = reshape(Y, width, height).';
    
    % Read U component
    U = fread(vid, width / 2 * height / 2, 'uint8');
    % Reshape a 1D array into a 2D array
    U = reshape(U, width / 2, height / 2).';
    % Upsampling
    YUV(:, :, 2) = kron(U, [1, 1; 1, 1]);
    
    % Read V component
    V = fread(vid, width / 2 * height / 2, 'uint8');
    % Reshape a 1D array into a 2D array
    V = reshape(V, width / 2, height / 2).';
    % Upsampling
    YUV(:, :, 3) = kron(V, [1, 1; 1, 1]);
    
    % Convert YUV to RGB
    RGB = reshape(YUVtoRGB(reshape(YUV, height * width, 3)), height, width, 3);
    % An image to a movie frame
    mov(i) = im2frame(RGB);
    
    waitbar(i/nof);
end

close(h);
fclose(vid);
