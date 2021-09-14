clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% visualize particles
x = linspace(-6.5,5,6);
[X,Y,Z] = meshgrid(x);
data = [X(:), Y(:), Z(:)];

[N, ~] = size(data);
for i = N: -1:1
    R = data(i,1)^2+data(i,2)^2+data(i,3)^2;
    if R > 33
        data(i,:) = [];
    end
end

[N, ~] = size(data);
rd = 0.84
data(:,1:3) = rotate_particles(data(:,1:3), rd);

particle_size = 0.3; sigma = 0.2;
data(:,4) = max(0.001, min(2*particle_size, normrnd(particle_size,sigma,[N,1])));
data(:,5) = 1.3;
data(:,6) = 0;

positionArray = data(:,1:3);
radiusArray = data(:,4);
refractiveIndexArray = data(:,5)+1i*data(:,6);

figure('Position', [100 0 1000 1000]);
plot_spheres(gca, positionArray, radiusArray, refractiveIndexArray);
max_r =6;
xlim([-max_r max_r])
ylim([-max_r max_r])
zlim([-max_r max_r])
axis off

%% visualize particles
% data = readmatrix('paras/particles_50.txt');
% [N, ~] = size(data);
% 
% particle_size = 0.3; sigma = 0.1;
% distance_scale = 0.1;
% 
% data(:,1:3) = data(:,1:3) * distance_scale;
% data(:,4) = max(0.001, min(2*particle_size, normrnd(particle_size,sigma,[N,1])));
% 
% positionArray = data(:,1:3);
% radiusArray = data(:,4);
% refractiveIndexArray = data(:,5)+1i*data(:,6);
% 
% figure;
% plot_spheres(gca, positionArray, radiusArray, refractiveIndexArray);

%% visualize particles 2
% figure; hold on;
% 
% data = readmatrix('paras/particles_500.txt');
% plot3(data(:,1),data(:,2),data(:,3),'k.');
% 
% data = readmatrix('paras/particles_100.txt');
% plot3(data(:,1),data(:,2),data(:,3)*0.1,'b.'); axis equal
% 
% data = readmatrix('paras/particles_50.txt');
% plot3(data(:,1),data(:,2),data(:,3),'m.');
% 
% data = readmatrix('paras/particles_20.txt');
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
%     if size(data, 1) <= 20
%        break; 
%     end
% end
% 
% writematrix(data, 'paras/particles_20.txt');


%% 
% data1 = readmatrix('paras/particles_100.txt');
% 
% N = 100;
% mu = [0,0,0]; sigma = [15,15,1]/10;
% data2 = [normrnd(mu(1),sigma(1),[N,1]), ...
%         normrnd(mu(2),sigma(2),[N,1]) ...
%         normrnd(mu(3),sigma(3),[N,1])];
% 
% figure; hold on
% plot3(data1(:,1)*0.1,data1(:,2)*0.1,data1(:,3)*0.1,'r.');
% plot3(data2(:,1),data2(:,2),data2(:,3),'g.'); 
% axis equal;

function particles = rotate_particles(particles, Rand)
    rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)] ;
    roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)] ;
    rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1] ;
    particles = (rotx(Rand*2*pi) * particles')';
    particles = (roty(Rand*2*pi) * particles')';
    particles = (rotz(Rand*2*pi) * particles')';
end