fn = 'D:/tmp/color4x_1_old.jpg';
rgbImage = imresize(imread(fn), [256,256]); % Sample image.
windowWidth = 5; % Whatever you want.  More blur for larger numbers.
kernel = ones(windowWidth) / windowWidth ^ 2;
blurredImage = imfilter(rgbImage, kernel); % Blur the image.

subplot(1,2,1);imshow(rgbImage); % Display it.
subplot(1,2,2);imshow(blurredImage); % Display it.
