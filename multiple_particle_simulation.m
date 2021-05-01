disp('')
disp('=============== New script ===============')
% close all; clear;
warning('off','all');
addpath(genpath('celes/src'));
addpath(genpath('src'));

%% User defined parameters
particles = readmatrix('paras/particles1.txt'); % (x,y,z,radius,ior_real,ior_image)
size_scale = 2;

switch flag   
    case 'red'
        %%% input %%%
        wavelength = 0.70; %(um)
        %%% output %%%
        fn_mat = 'data_R.mat';
        fn_plot = 'farfield_R.jpg';
        fn_plot_particles = 'particles.jpg';    
    
    case 'green'
        %%% input %%%
        wavelength = 0.53; %(um)
        %%% output %%%
        fn_mat = 'data_G.mat';
        fn_plot = 'farfield_G.jpg';
        fn_plot_particles = 'particles.jpg';
        
    case 'blue'
        %%% input %%%
        wavelength = 0.46; %(um)
        %%% output %%%
        fn_mat = 'data_B.mat';
        fn_plot = 'farfield_B.jpg';
        fn_plot_particles = 'particles.jpg';
       
end

%% Pre defined parameters
unit = 1e-6; % Convert um to m
wavelength = wavelength * unit;
particles(:,1:4) = particles(:,1:4) * unit;
particles(:,1:3) = particles(:,1:3) * distance_scale;
particles(:,4) = particles(:,4) * size_scale;

radius_max = max(particles(:,4));
lmax = ceil(6*radius_max/wavelength+1.5);
disp('');
disp(['lmax:' num2str(lmax)]);

k = 2*pi/wavelength;
polar_angles = 0:pi/180:pi;
azimuthal_angles = 0:pi/180:2*pi;

num_simul = 100;

if ~exist(out_dir, 'dir')
   mkdir(out_dir)
end

%%% ------------- %%%
plot_spheres(rotate_particles(particles(:,1:3)), particles(:,4), particles(:,5)+1i*particles(:,6));
saveas(gcf, [out_dir fn_plot_particles]);
close(gcf); 
%%% ------------- %%%



%% Simulation
for i = 1:num_simul
    disp(['----------- similation ' num2str(i) ' of ' num2str(num_simul) ' ...']);
    particles(:,1:3) = rotate_particles(particles(:,1:3));
    [p1A,p1B,p2A,p2B, ~,~] = wave_simulate(particles, wavelength, lmax, polar_angles, azimuthal_angles);
    continue
    T_per2_NM = abs(p1A).^2 + abs(p2A).^2;
    T_par2_NM = abs(p1B).^2 + abs(p2B).^2;
    T_NM_ = (T_per2_NM + T_par2_NM)./2;

    T_per2_N1 = mean(T_per2_NM, 2);
    T_par2_N1 = mean(T_par2_NM, 2);
    T_N1 = mean(T_NM_, 2);

    % T_per_N1 = sqrt(T_per2_N1(1));
    T_per_N1_tmp = mean(p1A, 2);
    T_per_N1 = mean((p1A + p2A)./2, 2);
    T_par_N1 = mean((p1B + p2B)./2, 2);
    RT = abs(real(T_per_N1(1)));

    fp_per_N1 = T_per2_N1./max(T_N1);
    fp_par_N1 = T_par2_N1./max(T_N1);
    fp_ = T_N1;

    bintgrnd = trapz(azimuthal_angles,T_NM_');
    intgrl = trapz(polar_angles, bintgrnd.*sin(polar_angles));
    Cs_ = intgrl/(k^2);
    Ct_ = 4*pi/(k^2)*RT;

    Cs_ = Cs_ * 39.482; % magic number
    Ct_ = Ct_ * 4536.5;

    %%% ------ averaging ------ %%%
    if i == 1
        Cs = Cs_;
        Ct = Ct_;
        fp = fp_;
        T_NM = T_NM_;
    else
        Cs = (i-1)/i*Cs + 1/i*Cs_;
        Ct = (i-1)/i*Ct + 1/i*Ct_;
        fp = (i-1)/i*fp + 1/i*fp_;
        T_NM = (i-1)/i*T_NM + 1/i*T_NM_;
    end
    %%% ----------------------- %%%

    %% Save to disk
    save([out_dir, fn_mat], 'particles', 'wavelength', 'lmax', 'p1A','p1B','p2A','p2B', 'fp', 'Cs', 'Ct');
    save_plot([out_dir fn_plot], T_NM, fp./max(fp));

end


function particles = rotate_particles(particles)
    rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)] ;
    roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)] ;
    rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1] ;
    particles = (rotx(rand*2*pi) * particles')';
    particles = (roty(rand*2*pi) * particles')';
    particles = (rotz(rand*2*pi) * particles')';
end

function save_plot(fn, T_NM, fp_N1)
    figure('Position', [10 10 1500 500]);

    subplot(1,3,1)
    polarplot3d(log(T_NM(1:91, :)));
    view([0,90]);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis([-1.1,1.1,-1.5,1.5]); axis('off');
    caxis([-inf,max(log(T_NM(:)))]);
    title('forward intensity (log)')

    subplot(1,3,2)
    polarplot3d(log(T_NM(end:-1:91, :)));
    view([0,90]);
    set(gca,'DataAspectRatio',[1,1,1]);
    axis([-1.1,1.1,-1.5,1.5]); axis('off');
    caxis([-inf,max(log(T_NM(:)))]);
    title('backward intensity (log)')

    subplot(1,3,3)
    hold on;
    plot(log(fp_N1),'r','LineWidth',2, 'DisplayName','CELES-Unpolarised'); 
    hold off;
    axis([0 180 -inf 0])
    title('intensity')
    xlabel('polar angle')
    ylabel('log of normalized')
    legend

    saveas(gcf, fn);
    close(gcf); 
end

