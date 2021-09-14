%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all

c1=[0.4940 0.1840 0.5560]; c2=[0 0.4470 0.7410]; c3=[0.4660 0.6740 0.1880]; c4=[0.9290 0.6940 0.1250]; c5=[0.8500 0.3250 0.0980];

% plot_curve = true;
plot_curve = false;

%% IOR
a = 0; b = 13; c=1; d = 0.17;
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm_/bin/data_1.2.mat']);  fp1 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm_/bin/data_1.3.mat']);  fp2 = d .* (log(c*fp+a)+b); 
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm_/bin/data_1.4.mat']);  fp3 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/diffIOR_N100_500nm_/bin/data_1.5.mat']);  fp4 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c2);
    plot(fp2,'Color', c3);
    plot(fp3,'Color', c4);
    plot(fp4,'Color', c5);
    legend('1.2','1.3','1.4','1.5')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)';fp4(:)'], [c2;c3;c4;c5]);
legend({'IOR=1.2', 'IOR=1.3','IOR=1.4','IOR=1.5'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'IOR.png');

%% gaussian radius
a = 0; b = 13; c=1; d = 0.15;
load(['D:/gyDocuments/4_waveoptics/results/out/diffradius_N50_300nm/bin/data_0.02.mat']);  fp1 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/diffradius_N50_300nm/bin/data_0.06.mat']);  fp2 = d .* (log(c*fp+a)+b); 
load(['D:/gyDocuments/4_waveoptics/results/out/diffradius_N50_300nm/bin/data_0.1.mat']);  fp3 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/diffradius_N50_300nm/bin/data_0.2.mat']);  fp4 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c2);
    plot(fp2,'Color', c3);
    plot(fp3,'Color', c4);
    plot(fp4,'Color', c5);
    legend('1.2','1.3','1.4','1.5')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)';fp4(:)'], [c2;c3;c4;c5]);
legend({'a_i~N(300,20)nm', 'a_i~N(300,60)nm', 'a_i~N(300,100)nm','a_i~N(300,200)nm'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'radius_gaussian.png');

%% correlated
a = 0; b = 13; c=1; d = 0.15;
load('D:/gyDocuments/4_waveoptics/results/out/negative_N100_500nm/data_400.mat');  
fp = smoothdata(fp,'gaussian',7);
fp1 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c1);
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)'], [c1]);
saveas(gca, 'negative.png');

load('D:/gyDocuments/4_waveoptics/results/out/positive_N100_500nm/data_400.mat');  
fp = smoothdata(fp,'gaussian',7);
fp1 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c1);
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)'], [c1]);
saveas(gca, 'positive.png');

%% color
a = 0; b = 13; c=1; d = 0.15;
load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_400.mat');  fp1 = d .* (log(c*fp+a)+b);
load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_473.mat');  fp2 = d .* (log(c*fp+a)+b); 
load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_547.mat');  fp3 = d .* (log(c*fp+a)+b);
load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_627.mat');  fp4 = d .* (log(c*fp+a)+b);
load('D:/gyDocuments/4_waveoptics/results/out/color_N1_500nm/data_700.mat');  fp5 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c1);
    plot(fp2,'Color', c2);
    plot(fp3,'Color', c3);
    plot(fp4,'Color', c4);
    plot(fp5,'Color', c5);
    legend('1','2','3','4','5')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)';fp4(:)';fp5(:)'], [c1;c2;c3;c4;c5]);
legend({'400nm','473nm','547nm','627nm','700nm'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'color1.png');

a = 0; b = 13; c=1; d = 0.2;
load('D:/gyDocuments/4_waveoptics/results/out/color_N100_500nm/data_400.mat');  fp1 = d .* (log(c*fp+a)+b);
load('D:/gyDocuments/4_waveoptics/results/out/color_N100_500nm/data_473.mat');  fp2 = d .* (log(c*fp+a)+b); 
load('D:/gyDocuments/4_waveoptics/results/out/color_N100_500nm/data_547.mat');  fp3 = d .* (log(c*fp+a)+b);
load('D:/gyDocuments/4_waveoptics/results/out/color_N100_500nm/data_627.mat');  fp4 = d .* (log(c*fp+a)+b);
load('D:/gyDocuments/4_waveoptics/results/out/color_N100_500nm/data_700.mat');  fp5 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c1);
    plot(fp2,'Color', c2);
    plot(fp3,'Color', c3);
    plot(fp4,'Color', c4);
    plot(fp5,'Color', c5);
    legend('1','2','3','4','5')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)';fp4(:)';fp5(:)'], [c1;c2;c3;c4;c5]);
legend({'400nm','473nm','547nm','627nm','700nm'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'color100.png');

%% number
a = 0; b = 13; c=1; d = 0.15;
load(['D:/gyDocuments/4_waveoptics/results/out/validate8_D2_N20_500nm/data_R.mat']);  fp1 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/validate3_D2_N100_500nm/data_R.mat']);  fp2 = d .* (log(c*fp+a)+b); 
load(['D:/gyDocuments/4_waveoptics/results/out/validate10_D2_N500_500nm/data_R.mat']);  fp3 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c2);
    plot(fp2,'Color', c3);
    plot(fp3,'Color', c5);
    legend('20','100','500')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)'], [c2;c3;c5]);
legend({'N=20', 'N=100','N=500'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'number.png');

%% radius
a = 0; b = 13; c=1; d = 0.15;
load(['D:/gyDocuments/4_waveoptics/results/out/validate5_D2_N100_400nm/data_R.mat']); fp1 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/validate3_D2_N100_500nm/data_R.mat']); fp2 = d .* (log(c*fp+a)+b); 
load(['D:/gyDocuments/4_waveoptics/results/out/validate7_D2_N100_600nm/data_R.mat']); fp3 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c2);
    plot(fp2,'Color', c3);
    plot(fp3,'Color', c5);
    legend('400','500','600')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)'], [c2;c3;c5]);
legend({'a_i=400nm', 'a_i=500nm','a_i=600nm'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'radius.png');
% 
%% distance
a = 0; b = 13; c=1; d = 0.15;
load(['D:/gyDocuments/4_waveoptics/results/out/validate2_D1_N100_500nm/data_R.mat']); fp1 = d .* (log(c*fp+a)+b);
load(['D:/gyDocuments/4_waveoptics/results/out/validate3_D2_N100_500nm/data_R.mat']); fp2 = d .* (log(c*fp+a)+b); 
load(['D:/gyDocuments/4_waveoptics/results/out/validate4_D3_N100_500nm/data_R.mat']); fp3 = d .* (log(c*fp+a)+b);

if plot_curve
    figure;hold on;
    plot(fp1,'Color', c2);
    plot(fp2,'Color', c3);
    plot(fp3,'Color', c5);
    legend('Sparse', 'Intermediate','Dense')
    hold off;
end

figure('Position', [100 400 1000 500]); hold on
polar_plot_all([fp1(:)';fp2(:)';fp3(:)'], [c2;c3;c5]);
legend({'Sparse', 'Intermediate','Dense'}, 'Location','northeast', 'FontSize',14,'TextColor','black');legend('boxoff');hold off
saveas(gca, 'distance.png');
