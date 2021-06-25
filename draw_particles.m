addpath(genpath('celes/src'));
addpath(genpath('src'));

particle_size = 0.5;
unit = 1e-6;
N_particle = 500;
rd_list = linspace(0,0.25,91)*2*pi;
rd = rd_list(1);
mu = [0,0,0]; sigma = [15,15,1]/2;
particles = zeros(N_particle, 6);
particles(:,1:3) = [normrnd(mu(1),sigma(1),[N_particle,1])* unit, ...
                    normrnd(mu(2),sigma(2),[N_particle,1])* unit ...
                    normrnd(mu(3),sigma(3),[N_particle,1])* unit];
particles(:,1:3) = rotate_particles(particles(:,1:3), rd);
particles(:,4) = particle_size * unit;
particles(:,5) = 1.331721;
particles(:,6) = 0;
fig2 = figure('Position', [100 0 1000 1000]);
plot_spheres(gca, particles(:,1:3), particles(:,4), particles(:,5)+1i*particles(:,6));
axis equal;
hold on
r= unit *50; x=0; y=0;
th = 0:pi/50:2*pi;
xunit = r * cos(th) + x;
yunit = r * sin(th) + y;
% fill(xunit,yunit,'b', 'FaceAlpha', 0.2, 'LineWidth', 1, 'EdgeColor', 'b', 'EdgeAlpha', 0.2);
hold off;

axis([-2*r, 2*r , -2*r, 2*r , -2*r, 2*r])

pt = particles(:,1:3);
max_r = max(abs(pt(:)));
if max_r == 0
    max_r = 1e-6;
end
xlim([-max_r max_r])
ylim([-max_r max_r])
zlim([-max_r max_r])

% fn_particles = 'paras/particles_1.txt';
% particles = readmatrix(fn_particles); % (x,y,z,radius,ior_real,ior_image)
%     distance_scale = 0.1;
%     size_scale = 3/3;
%     unit = 1e-6;
% particles(:,1:4) = particles(:,1:4) * unit;
% particles(:,1:3) = particles(:,1:3) * distance_scale;
% particles(:,4) = particles(:,4) * size_scale;
% 
% %     distance_scale = 10;
% %     particle_size = 0.5;
% %     unit = 1e-6;
% %     load('paras/correlated/positive/positive_0500_part_0035.mat'); % (x,y,z,radius,ior_real,ior_image)
% %     N = size(Px, 1);
% %     particles = zeros(N,6);
% %     particles(:,1:3) = Px * distance_scale;
% %     particles(:,4) = particle_size;
% %     particles(:,5) = 1.331721;
% %     particles(:,6) = 0;
% %     particles(:,1:4) = particles(:,1:4) * unit;
% 
% fig2 = figure('Position', [100 0 800 800]);
% plot_spheres(gca, particles(:,1:3), particles(:,4), particles(:,5)+1i*particles(:,6));
% axis([-2e-6,2e-6,-2e-6,2e-6])
% axis off;
% saveas(gca, 'tmp.png');
% im = imread('tmp.png');
% [h,w,~] = size(im);
% crop_x = round(w * 0.25); crop_y = round(h * 0.25); 
% shift_x = 10;shift_y = -10; 
% im = im(crop_y+1+shift_y: end-crop_y+shift_y, crop_x+1+shift_x: end-crop_x+shift_x,:);
% imwrite(im, 'tmp.png');
% close all

function particles = rotate_particles(particles, rd)
    rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)] ;
    roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)] ;
    rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1] ;
    particles = (rotx(-rd) * particles')';
%     particles = (roty(rand*2*pi) * particles')';
%     particles = (rotz(rand*2*pi) * particles')';
end