clear;
warning('off','all');
addpath(genpath('src'));

%% visualize particles
% data = readmatrix('paras/particles_500.txt');
% 
% size_scale = 21/3;
% distance_scale = 1;
% 
% positionArray = data(:,1:3) * distance_scale;
% radiusArray = data(:,4) * size_scale;
% refractiveIndexArray = data(:,5)+1i*data(:,6);
% 
% figure;
% plot_spheres(positionArray, radiusArray, refractiveIndexArray);

%% visualize particles 2
% figure; hold on;
% 
% data = readmatrix('paras/particles_500.txt');
% plot3(data(:,1),data(:,2),data(:,3),'k.');
% 
data = readmatrix('paras/particles_100.txt');
plot3(data(:,1),data(:,2),data(:,3)*0.1,'b.'); axis equal
% 
% data = readmatrix('paras/particles_50.txt');
% plot3(data(:,1),data(:,2),data(:,3),'m.');
% 
% data = readmatrix('paras/particles_10.txt');
% plot3(data(:,1),data(:,2),data(:,3),'g.');
% 
% data = readmatrix('paras/particles_1.txt');
% plot3(data(:,1),data(:,2),data(:,3),'r.');
% 
% hold off;


%% create different particles
% data = readmatrix('paras/particles_500.txt');
% 
% R_list = sqrt(data(:,1).^2+data(:,2).^2+data(:,3).^2);
% R = max(R_list)
% 
% for r = R:-0.01:0
%     data_flag = sqrt(data(:,1).^2+data(:,2).^2+data(:,3).^2) > r;
%     data(data_flag, :) = [];
%     size(data, 1)
%     if size(data, 1) <= 50
%        break; 
%     end
% end
% 
% writematrix(data, 'paras/particles_50.txt');


%% 
% N = 100;
% mu = [0,0,0]; sigma = [15,15,1];
% data = [normrnd(mu(1),sigma(1),[N,1]), ...
%         normrnd(mu(2),sigma(2),[N,1]) ...
%         normrnd(mu(3),sigma(3),[N,1])];
% plot3(data(:,1),data(:,2),data(:,3),'k.'); axis equal;