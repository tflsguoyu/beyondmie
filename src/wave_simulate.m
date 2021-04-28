function [p1A,p1B,p2A,p2B, simul1, simul2] = wave_simulate(data, wavelength, lmax, theta, phi)
    fprintf(1, '\nstart simulation with horizontal incoming wave ...\n')
    simul1 = simulate(data, 'TE', wavelength, lmax, theta, phi);
    fprintf(1, 'done!\n')
    
    fprintf(1, '\nstart simulation with vertical incoming wave ...\n')
    simul2 = simulate(data, 'TM', wavelength, lmax, theta, phi);
    fprintf(1, 'done!\n')

    pwp1 = simul1.output.totalFieldPlaneWavePattern;
    pwp2 = simul2.output.totalFieldPlaneWavePattern;

    p1A = double(gather(pwp1{1}.expansionCoefficients))';
    p1B = double(gather(pwp1{2}.expansionCoefficients))';

    p2A = double(gather(pwp2{1}.expansionCoefficients))';
    p2B = double(gather(pwp2{2}.expansionCoefficients))';

    function simul = simulate(data, polarization, wavelength, lmax, theta, phi)
        %% initialize the CELES class instances

        % initialize particle class instance
        %   - positionArray:        Nx3 array (float) in [x,y,z] format
        %   - refractiveIndexArray: Nx1 array (complex) of complex refractive indices
        %   - radiusArray:          Nx1 array (float) of sphere radii
        particles = celes_particles('positionArray',        data(:,1:3), ...
                                    'radiusArray',          data(:,4), ...
                                    'refractiveIndexArray', data(:,5)+1i*data(:,6) ...
                                    );

        % initialize initial field class instance
        %   - polarAngle:           scalar (float) polar angle of incoming beam/wave,
        %                           in radians. for Gaussian beams, only 0 or pi are
        %                           currently possible
        %   - azimuthalAngle:       scalar (float) azimuthal angle of incoming
        %                           beam/wave, in radians
        %   - polarization:         string (char) polarization of incoming beam/wave
        %                           ('TE' or 'TM')
        %   - beamWidth:            scalar (float) width of beam waist. use 0 or inf
        %                           for plane wave
        %   - focalPoint:           1x3 array (float) focal point
        initialField = celes_initialField('polarAngle',     0, ...
                                          'azimuthalAngle', 0, ...
                                          'polarization',   polarization, ...
                                          'beamWidth',      0, ...
                                          'focalPoint',     [0,0,0] ...
                                          );

        % initialize input class instance
        %   - wavelength:           scalar (float) vacuum wavelength, same unit as
        %                           particle positions and radii
        %   - mediumRefractiveIndex: scalar (complex) refractive index of environment
        %   - particles:            valid instance of celes_particles class
        %   - initialField:         valid instance of celes_initialField class
        input = celes_input('wavelength',                   wavelength, ...
                            'mediumRefractiveIndex',        1, ...
                            'particles',                    particles, ...
                            'initialField',                 initialField ...
                            );

        % initialize preconditioner class instance
        %   - type:                 string (char) type of preconditioner (currently
        %                           only 'blockdiagonal' and 'none' available)
        %   - partitionEdgeSizes    1x3 array (float) edge size of partitioning cuboids
        %                           (applies to 'blockdiagonal' type only)
        precnd = celes_preconditioner('type',               'none', ...
                                      'partitionEdgeSizes', [1200,1200,1200] ...
                                      );

        % initialize solver class instance
        %   - type:                 string (char) solver type (currently 'BiCGStab' or
        %                           'GMRES' are implemented)
        %   - tolerance:            scalar (float) target relative accuracy of solution
        %   - maxIter:              scalar (int) maximum number of iterations allowed
        %   - restart:              scalar (int) restart parameter (applies only to
        %                           GMRES solver)
        %   - preconditioner:       valid instance of celes_preconditioner class
        solver = celes_solver('type',                       'GMRES', ...
                              'tolerance',                  5e-4, ...
                              'maxIter',                    1000, ...
                              'restart',                    200, ...
                              'preconditioner',             precnd);

        % initialize numerics class instance
        %   - lmax:                 scalar (int) maximal expansion order of scattered
        %                           fields around particle center
        %   - polarAnglesArray:     1xN array (float) sampling of polar angles in the
        %                           plane wave patterns, in radians
        %   - azimuthalAnglesArray: sampling of azimuthal angles in the plane wave
        %                           patterns, in radians
        %   - gpuFlag:              scalar (bool) set to false if you experience GPU
        %                           memory problems at evaluation time (translation
        %                           operator always runs on GPU, though)
        %   - particleDistanceResolution: scalar (float) resolution of lookup table for
        %                           spherical Hankel function (same unit as wavelength)
        %   - solver:               valid instance of celes_solver class
        numerics = celes_numerics('lmax',                   lmax, ...
                                  'polarAnglesArray',       theta, ...
                                  'azimuthalAnglesArray',   phi, ...
                                  'gpuFlag',                true, ...
                                  'particleDistanceResolution', 1, ...
                                  'solver',                 solver);

        % define a grid of points where the field will be evaulated
        [x,z] = meshgrid(-8000:1000:8000, -8000:1000:8000); y = zeros(size(x));
        % initialize output class instance
        %   - fieldPoints:          Nx3 array (float) points where to evaluate the
        %                           electric near field
        %   - fieldPointsArrayDims: 1x2 array (int) dimensions of the array, needed to
        %                           recompose the computed field as a n-by-m image
        output = celes_output('fieldPoints',                [x(:),y(:),z(:)], ...
                              'fieldPointsArrayDims',       size(x));

        % initialize simulation class instance
        %   - input:                valid instance of celes_input class
        %   - numerics:             valid instance of celes_input class
        %   - output:               valid instance of celes_output class
        simul = celes_simulation('input',                   input, ...
                                 'numerics',                numerics, ...
                                 'output',                  output);

        %% run simulation
        simul.run;

        % evaluate transmitted and reflected power
        simul.evaluatePower;

        % evaluate field at output.fieldPoints
        % simul.evaluateFields;

    end
    
end

