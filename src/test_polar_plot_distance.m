%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all
% name1 = 'validate1_N1_500nm';
name1 = 'validate2_D1_N100_500nm';
name2 = 'validate3_D2_N100_500nm';
name3 = 'validate4_D3_N100_500nm';
% name = 'validate5_D2_N100_400nm';
% name = 'validate7_D2_N100_600nm';
% name = 'validate8_D2_N20_500nm';
% name = 'validate10_D2_N500_500nm';

load(['D:/gyDocuments/4_waveoptics/results/out/' name1 '/data_R.mat']);
fp1 = fp;
load(['D:/gyDocuments/4_waveoptics/results/out/' name2 '/data_R.mat']);
fp2 = fp;
load(['D:/gyDocuments/4_waveoptics/results/out/' name3 '/data_R.mat']);
fp3 = fp;

fig2 = figure('Position', [100 400 500 500]);
hold on
polar_plot2([fp1(:)';fp2(:)';fp3(:)'], [[0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880];[0.8500 0.3250 0.0980]], 1);
legend({'Sparse', 'Intermediate','Dense'}, 'Location','northwest', 'FontSize',12,'TextColor','black');legend('boxoff')
hold off
saveas(gca, 'tmp.png');
im = imread('tmp.png');
[h,w,~] = size(im);
a_crop = round(h * 0.15); shift1 = -70; shift2 = -20;
im = im(a_crop+1+shift1: end-a_crop+shift1,   a_crop+1+shift2: end-a_crop+shift2,:);
imwrite(im, 'tmp.png');
close all;
