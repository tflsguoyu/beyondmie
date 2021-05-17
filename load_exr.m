addpath(genpath('src'));

%%
% sigmaT_list = [];
% sigmaS_list = [];
% theta_i = [0:90];
% for i = theta_i
%     load(['../results/out/disk_N1000_0.3um_2/data_R_' num2str(i) '.mat']);
%     pt = particles(:,1:3);
% %     R = max(abs(pt(:)))
%     R = 2e-4;
%     N = 1;
%     V = 4/3*pi*R^3;
%     pho = N/V;
%     sigmaT = pho * Ct;
%     sigmaT_list = [sigmaT_list; sigmaT];
%     sigmaS = pho * Cs;
%     sigmaS_list = [sigmaS_list; sigmaS];
%     
% end
% figure; 
% hold on;
% plot(theta_i, sigmaT_list, 'r-');
% plot(theta_i, sigmaS_list, 'b-');
% legend('sigma t', 'sigma s')

%%
folder = 'rainbow_1_0.5nm/';
wl_list = linspace(0.4,0.7,50)*1000;
sRGB = spectrumRGB(wl_list, 'Judd_Vos');
sR = sRGB(:,:,1)/sum(sRGB(:,:,1));
sG = sRGB(:,:,2)/sum(sRGB(:,:,2));
sB = sRGB(:,:,3)/sum(sRGB(:,:,3));

figure; hold on
plot(wl_list, sR, 'r'); 
plot(wl_list, sG, 'g'); 
plot(wl_list, sB, 'b'); 
hold off;

img_R = 0;
img_G = 0;
img_B = 0;
i = 0;
sigmaT_list = [];
sigmaS_list = [];
for wl = wl_list
    i = i + 1;
    img_this = exrread(['../results/out/' folder 'render_' num2str(round(wl)) '.exr']);
    img_R = img_R + img_this(:,:,1) * sR(i);
    img_G = img_G + img_this(:,:,2) * sG(i);
    img_B = img_B + img_this(:,:,3) * sB(i);
    load(['../results/out/' folder 'data_' num2str(round(wl)) '.mat']);
    N = 500/height(particles);
    R = 86.1*1e-6;
    V = 4/3*pi*R^3;
    pho = N/V;
    sigmaT = pho * Ct;
    sigmaT_list = [sigmaT_list; sigmaT];
    sigmaS = pho * Cs;
    sigmaS_list = [sigmaS_list; sigmaS];
end
[h,w] = size(img_R);
img = zeros(h,w,3);
img(:,:,1) = img_R;
img(:,:,2) = img_G;
img(:,:,3) = img_B;
exrwrite(img, ['../results/out/' folder 'render_all.exr']);
img = img.^(1/2.2);
img(img > 1) = 1;
imwrite(img, ['../results/out/' folder 'render_all.png']);
% 
% figure; 
% hold on;
% plot(wl_list, sigmaT_list, 'b:');
% plot(wl_list, sigmaS_list, 'b-');
% legend('sigma t', 'sigma s')
% title('1 particle in a cluster')

img_R = exrread(['../results/out/' folder 'render_700.exr']);
img_G = exrread(['../results/out/' folder 'render_547.exr']);
img_B = exrread(['../results/out/' folder 'render_437.exr']);
img = cat(3, img_R(:,:,1), img_G(:,:,1), img_B(:,:,1));
exrwrite(img, ['../results/out/' folder 'render_rgb.exr']);

%%
% img_all = [];
% img = exrread(['../results/out/aniso_hg/render_aniso_hg_x.exr']);
% img = img.^(1/2.2);
% img(img > 1) = 1;
% img_all = [img_all, img];
% img = exrread(['../results/out/aniso_hg/render_aniso_hg_y.exr']);
% img = img.^(1/2.2);
% img(img > 1) = 1;
% img_all = [img_all, img];
% img = exrread(['../results/out/aniso_hg/render_aniso_hg_z.exr']);
% img = img.^(1/2.2);
% img(img > 1) = 1;
% img_all = [img_all, img];
% img = exrread(['../results/out/aniso_hg/render_hg.exr']);
% img = img.^(1/2.2);
% img(img > 1) = 1;
% img_all = [img_all, img];
% imwrite(img_all, '../results/out/aniso_hg/render_xyz.png');

%%
% img_all = [];
% for i = [1,1.5,2]
%     img_row = [];
%    for j = [1,50,100,500]
%        img = exrread(['../results/out/multiple_' num2str(j) '_' num2str(i) '/render_R.exr']);
%        img = img.^(1/2.2);
%        img(img > 1) = 1;
%        img_row = [img_row, img];
%        guoyu = 1;
%    end
%    img_all = [img_all; img_row];
% end
% 
% imwrite(img_all, '../results/out/render.png');
