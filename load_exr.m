addpath(genpath('src'));

img_all = [];
for i = [1,1.5,2]
    img_row = [];
   for j = [1,50,100,500]
       img = exrread(['../results/out/multiple_' num2str(j) '_' num2str(i) '/render_R.exr']);
       img = img.^(1/2.2);
       img(img > 1) = 1;
       img_row = [img_row, img];
       guoyu = 1;
   end
   img_all = [img_all; img_row];
end

imwrite(img_all, '../results/out/render.png');
