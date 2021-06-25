%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all
load('D:/gyDocuments/4_waveoptics/results/out/negative_N100_500nm/data_400.mat');
fp1 = fp;

fig2 = figure('Position', [100 400 500 500]);
hold on
% polar_plot(fp1(:)', [0.4940 0.1840 0.5560]);
% polar_plot([fp1(:)';fp2(:)'], [[0.8500 0.3250 0.0980]; [0.4660 0.6740 0.1880]]);
% multi-spectrum
polar_plot7([fp1(:)'], ...
    [[0.4940 0.1840 0.5560]], 1);
% legend({'400nm', '475nm', '550nm', '625nm', '700nm'}, 'Location','northwest', 'FontSize',10,'TextColor','black');legend('boxoff')
hold off
saveas(gca, 'tmp.png');
im = imread('tmp.png');
[h,w,~] = size(im);
crop_x = round(w * 0.10); crop_y = round(h * 0.25); 
shift_x = 10;shift_y = -10; 
im = im(crop_y+1+shift_y: end-crop_y+shift_y, crop_x+1+shift_x: end-crop_x+shift_x,:);
imwrite(im, 'tmp.png');
close all


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear all; close all
% load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_400.mat');
% fp1 = fp;
% load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_473.mat');
% fp2 = fp;
% load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_547.mat');
% fp3 = fp;
% load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_627.mat');
% fp4 = fp;
% load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_700.mat');
% fp5 = fp;
% % plot(log(fp2))
% 
% fig2 = figure('Position', [100 400 500 500]);
% hold on
% % polar_plot(fp1(:)', [0.4940 0.1840 0.5560]);
% % polar_plot([fp1(:)';fp2(:)'], [[0.8500 0.3250 0.0980]; [0.4660 0.6740 0.1880]]);
% % multi-spectrum
% polar_plot6([fp1(:)';fp2(:)';fp3(:)';fp4(:)';fp5(:)'], ...
%     [[0.4940 0.1840 0.5560]; [0 0.4470 0.7410]; [0.4660 0.6740 0.1880];[0.9290 0.6940 0.1250]; [0.8500 0.3250 0.0980]], 1);
% legend({'400nm', '475nm', '550nm', '625nm', '700nm'}, 'Location','northwest', 'FontSize',10,'TextColor','black');legend('boxoff')
% hold off
% saveas(gca, 'tmp.png');
% im = imread('tmp.png');
% [h,w,~] = size(im);
% a_crop = round(h * 0.10); shift1 = -20; shift2 = 10;
% im = im(a_crop+1+shift1: end-a_crop+shift1, a_crop+1+shift2: end-a_crop+shift2,:);
% imwrite(im, 'tmp.png');
% close all
