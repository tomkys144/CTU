%% img2spec
% img -- fft2 --> spec -- fftshift --> spec
% fftshift prohazuje kvadranty, tak aby roh byl uprostřed (3 x 1 a 4 x 2)

%% spec2img
% spec -- ifftshift --> spec -- ifft2 --> img