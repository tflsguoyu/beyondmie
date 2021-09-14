%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all
% name1 = 'validate1_N1_500nm';
% name2 = 'validate2_D1_N100_500nm';
name2 = 'validate3_D2_N100_500nm';
% name4 = 'validate4_D3_N100_500nm';
% name1 = 'validate5_D2_N100_400nm';
% name3 = 'validate7_D2_N100_600nm';
name1 = 'validate8_D2_N20_500nm';
name3 = 'validate10_D2_N500_500nm';
a = 0; b = 13; c=1; costheta = 0.1%cos(linspace(0,90,181)/180*pi);
load(['D:/gyDocuments/4_waveoptics/results/out/' name1 '/data_R.mat']);
fp1 = costheta .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/' name2 '/data_R.mat']);
fp2 = costheta .*  (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/' name3 '/data_R.mat']);
fp3 = costheta .*  (log(c*fp+a)+b);

sum(fp1)
sum(fp2)
sum(fp3)
figure;hold on;
plot(fp1,'Color', [0 0.4470 0.7410]);
plot(fp2,'Color', [0.4660 0.6740 0.1880]);
plot(fp3,'Color', [0.9290 0.6940 0.1250]);
legend('20','100','500')
hold off;

fig2 = figure('Position', [100 400 500 500]);
hold on
polar_plot2([fp1(:)';fp2(:)';fp3(:)'], [[0.4940 0.1840 0.5560];[0.4660 0.6740 0.1880];[0.8500 0.3250 0.0980]], 1);
legend({'N=20', 'N=100','N=500'}, 'Location','northeast', 'FontSize',12,'TextColor','black');legend('boxoff')
hold off
saveas(gca, 'tmp.png');
% im = imread('tmp.png');
% [h,w,~] = size(im);
% a_crop = round(h * 0.15); shift1 = -70; shift2 = -20;
% im = im(a_crop+1+shift1: end-a_crop+shift1,   a_crop+1+shift2: end-a_crop+shift2,:);
% imwrite(im, 'tmp.png');
% close all;

