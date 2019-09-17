function RGB = YUVtoRGB(YUV)

% Conversino matrix
m = [1, 0     ,  1.4022;
     1,-0.3456, -0.7145;
     1, 1.771 ,  0      ];

YUV = double(YUV);

YUV(:, 2 : 3) = YUV(:, 2 : 3) - 127;
RGB = (m *YUV.').';

RGB = uint8(clipValue(RGB, 0, 255));

% Clip value
function val = clipValue(val, valMin, valMax)

for i = 1 : 1 : size(val(:))
	if (val(i) < valMin)
		val(i) = valMin;
    elseif (val(i) > valMax)
		val(i) = valMax;
	end
end