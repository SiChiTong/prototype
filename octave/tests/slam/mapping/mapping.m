addpath('../../../lib/sensor');

% Simulation time
Tmax = 150;
T = 0:Tmax;

% Initial Robot location
x0 = [5 20 0];
% Robot motions
u = [3 0 -3 0;
     0 3 0 -3];
ui = 1;
% Robot sensor rotation command
w = 0.3 * ones(length(T));

% True map
M = 50;
N = 60;
map = zeros(M,N);
map(4:10, 5:10) = 1;
map(30:35, 40:45) = 1;
map(3:6, 40:60) = 1;
map(20:30, 25:29) = 1;
map(40:50, 5:25) = 1;

% Belief map
m = 0.5 * ones(M, N);
L0 = log(m ./ (1 - m));
L = L0;

% Sensor model parameters
meas_phi = [-0.4:0.05:0.4]; % Measurement headings
rmax = 30; % Max range
alpha = 1; % Width of an obstacle (Distance about measurement to fill in)
beta = 0.05; % Width of a beam (Angle beyond which to exclude) 

%State Initialization
x = zeros(3, length(T) + 1);
x(:, 1) = x0;


%% Main simulation
for t = 2:length(T)
    % Robot motion
    move = x(1:2,t-1) + u(:,ui);
    if ((move(1) > M || move(2) > N || move(1) < 1 || move(2) < 1) || (map(move(1), move(2)) == 1))
        x(:, t) = x(:, t - 1);
        ui = mod(ui, 4) + 1;
    else
        x(1:2, t) = move;
    end
    x(3, t) = x(3, t - 1) + w(t);
    
    % Generate a measurement data set
    meas_r = getranges(map, x(:, t), meas_phi, rmax);

    % Map update
    % get inverse measurement model
    invmod = inversescanner( ...
        M,  ...
        N, ...
        x(1,t), ...
        x(2,t), ...
        x(3,t), ...
        meas_phi, ...
        meas_r, ...
        rmax, ...
        alpha, ...
        beta ...
    );
    
    % Calculate updated log odds
    L = L + log(invmod ./ (1 - invmod)) - L0;

    % Calculate probabilities
    m = exp(L) ./ (1 + exp(L));

    % Plot results
    plot_results(t, map, x, meas_r, meas_phi, invmod, m); 
end