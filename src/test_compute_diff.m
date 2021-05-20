clear; %close all;
addpath(genpath('D:/gyDocuments/4_waveoptics/codes/src'));

img_folder = 'D:/gyDocuments/4_waveoptics/results/out/color_ec2/tmp_lucy_10000/';
img_700 = exrread([img_folder 'render_' num2str(700) '.exr']);
img_550 = exrread([img_folder 'render_' num2str(547) '.exr']);
% img_600 = exrread([img_folder 'render_' num2str(602) '.exr']);
% img_700 = exrread([img_folder 'render_' num2str(700) '.exr']);
img_err1 = compute_diff(img_700, img_550);
% img_err2 = compute_diff(img_700, img_500);
% img_err3 = compute_diff(img_700, img_400);
% figure;
% subplot(1,3,1)
% imshow(img_err1)
% subplot(1,3,2)
% imshow(img_err2)
% subplot(1,3,3)
% imshow(img_err3)
% colormap(pmkmp(256))
% colorbar
% caxis([0,0.25])
imwrite(img_err1,'color_700-550.jpg')
% imwrite(img_err2,'color_700-500.jpg')
% imwrite(img_err3,'color_700-400.jpg')
