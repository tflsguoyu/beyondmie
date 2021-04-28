close all; clear;
warning('off','all');

%% Load particles
data = readmatrix('paras/particles1.txt');

size_scale = 2;
distance_scale = 2;

positionArray = data(:,1:3) * distance_scale;
radiusArray = data(:,4) * size_scale;
refractiveIndexArray = data(:,5)+1i*data(:,6);

plot_spheres(positionArray, radiusArray, refractiveIndexArray);

%%