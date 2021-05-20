clear all; %close all
load('D:/gyDocuments/4_waveoptics/results/out/multiple_N1_500nm/data_R.mat');
fp_log = log(fp)+12;
fp_log = fp_log/sum(fp_log);
fig1 = figure('Position', [400 500 300 300]);
plot(fp_log)
fig2 = figure('Position', [100 500 300 300]);
hold on
polar_plot(fp_log);

