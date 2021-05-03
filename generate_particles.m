clear;
warning('off','all');
addpath(genpath('src'));

%% visualize particles
% data = readmatrix('paras/particles_10.txt');
% 
% size_scale = 1;
% distance_scale = 1;
% 
% positionArray = data(:,1:3) * distance_scale;
% radiusArray = data(:,4) * size_scale;
% refractiveIndexArray = data(:,5)+1i*data(:,6);
% 
% figure;
% plot3(data(:,1),data(:,2),data(:,3),'.');
% %plot_spheres(positionArray, radiusArray, refractiveIndexArray);


%% create different particles
data = readmatrix('paras/particles_500.txt');

R_list = sqrt(data(:,1).^2+data(:,2).^2+data(:,3).^2);
R = max(R_list)

for r = R:-0.01:0
    data_flag = sqrt(data(:,1).^2+data(:,2).^2+data(:,3).^2) > r;
    data(data_flag, :) = [];
    size(data, 1)
    if size(data, 1) <= 50
       break; 
    end
end

writematrix(data, 'paras/particles_50.txt');