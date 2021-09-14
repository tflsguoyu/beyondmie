%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all

load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm/bin/data_1.2.mat']);
fp1 = fp;
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm/bin/data_1.3.mat']);
fp2 = fp;
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm/bin/data_1.4.mat']);
fp3 = fp;
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm/bin/data_1.5.mat']);
fp4 = fp;



sum(fp1)
sum(fp2)
sum(fp3)
sum(fp4)
figure;hold on;
plot(log(fp1),'Color', [0 0.4470 0.7410]);
plot(log(fp2),'Color', [0.4660 0.6740 0.1880]);
plot(log(fp3),'Color', [0.9290 0.6940 0.1250]);
plot(log(fp4),'Color', [0.8500 0.3250 0.0980]);
hold off;
legend('1.2','1.3','1.4','1.5')


fig2 = figure('Position', [100 400 500 500]);
hold on
polar_plot3([fp1(:)';fp2(:)';fp3(:)';fp4(:)'], [[0 0.4470 0.7410]; [0.4660 0.6740 0.1880];[0.9290 0.6940 0.1250]; [0.8500 0.3250 0.0980]], 1);
legend({'IOR=1.2+0i', 'IOR=1.3+0i', 'IOR=1.4+0i','IOR=1.5+0i'}, 'Location','northeast', 'FontSize',12,'TextColor','black');legend('boxoff')
hold off
saveas(gca, 'IOR.png');
% im = imread('tmp.png');
% [h,w,~] = size(im);
% a_crop = round(h * 0.16); shift1 = -70; shift2 = -35;
% im = im(a_crop+1+shift1: end-a_crop+shift1,   a_crop+1+shift2: end-a_crop+shift2,:);
% imwrite(im, 'tmp.png');
% close all;

