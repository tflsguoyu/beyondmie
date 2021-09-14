load('sRGB.mat');
wl_list = linspace(0.4,0.7,31);
img_R = 0;img_G = 0;img_B = 0;
id = 0;
for wl = wl_list
    id = id + 1;
    img_this = exrread(['render_' num2str(wl*1000) '.exr']);
    img_R = img_R + img_this(:,:,1) * sR(id);
    img_G = img_G + img_this(:,:,2) * sG(id);
    img_B = img_B + img_this(:,:,3) * sB(id);
end
exrwrite(cat(3, img_R, img_G, img_B), 'render.exr');