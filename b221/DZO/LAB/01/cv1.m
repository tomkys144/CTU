%% download image
I = imread('https://upload.wikimedia.org/wikipedia/en/7/7d/Lenna_%28test_image%29.png');

%display image
figure(1); image(I); axis image
title('Input Image')

%% crop the image by 50 pixels on each side
c = 50

Ic = I(c+1:end-c,c+1:end-c,:);

%display image
figure(2); image(Ic); axis image
title('Cropped image')
size(Ic)


%% convert image to grayscale 

% GrayScale = 0.2989 * R + 0.5870 * G + 0.1140 * B 

% fill your code here
J = 0.2989 * Ic(:,:,1) + 0.5870 * Ic(:,:,2) + 0.1140 * Ic(:,:,3);
J = uint8(J);

% Create 3-channel grayscale images (same value for all channels)

% fill your code here
K=repmat(J,1,1,3);
K = uint8(K);

figure(3); image(K); axis image;
title('Grayscale image')


%% Highlight high/low intensity pixels

%- show high intensity pixels in red (I>200);
%- show low intensity in blue (I<50); 

L = K;

%fill your code here
low = J<50;
high = J>200;

for i = 1:size(L,1)
    for j= 1:size(L,2)
        if high(i,j)
            L(i,j,1)=255;
            L(i,j,2)=0;
            L(i,j,3)=0;
        end
        
        if low(i,j)
            L(i,j,1)=0;
            L(i,j,2)=0;
            L(i,j,3)=255;
        end
    end
end



figure(4); image(L); axis image
title('Intensity highlighted image')

%% Add a yellow 10px-thick border around the resulting image

%fill your code here
b = 10;

tmp=ones(size(L,1)+2*b,size(L,2)+2*b);
M = cat(3,255*tmp, 255*tmp, 0*tmp);
M = uint8(M);

M(b+1:end-b, b+1:end-b, :) = L;

figure(5); image(M); axis image
size(M);
title('Image with a yellow border');

%store the image as JPEG
imwrite(M,'result.jpg')

%read from disk
N = imread('result.jpg');
figure(6); image(N); axis image
title('Image result read from disk')

    