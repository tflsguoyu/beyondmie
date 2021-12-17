function particles = rotate_particles(particles)
    % particles takes N by 3 matrix
    rotx = @(t) [1 0 0; 0 cos(t) -sin(t) ; 0 sin(t) cos(t)] ;
    roty = @(t) [cos(t) 0 sin(t) ; 0 1 0 ; -sin(t) 0  cos(t)] ;
    rotz = @(t) [cos(t) -sin(t) 0 ; sin(t) cos(t) 0 ; 0 0 1] ;
    particles = (rotx(rand*2*pi) * particles')';
    particles = (roty(rand*2*pi) * particles')';
    particles = (rotz(rand*2*pi) * particles')';
end
