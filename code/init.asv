% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

% This is the initialization file. In here, the used matrizes and variables
% are initialized

clear all
clc

% conversion meter to pixel
mtopix = 10; % one meter in reall are 10 pixels in our matrizes

% pedestrian matrix
pedM = zeros(21, 1);

% aid to access to entries of pedestrian matrix
pos = [2 1]';   % CAUTION: Because of the indices of a matrix (for M(i,j), i is the y-coordinate and j is the x-coordinate), we change here the order of the indices to address coordinates in a vector 
velo = [4 3]';
acc = [6 5]';
ftarg = [8 7]';
fwall = [10 9]';
fped = [12 11]';
ftot = [14 13]';
vmax = 15;
layer = 16;
weight = 17;
radius = 18;
tstart = 19;
tend = 20;
status = 21;

% intialization of pedestrian matrix
pedM(pos, 1) = [265 5]';
pedM(velo, 1) = zeros(2,1);
pedM(acc, 1) = zeros(2,1);
pedM(ftarg, 1) = zeros(2,1);
pedM(fwall, 1) = zeros(2,1);
pedM(fped, 1) = zeros(2,1);
pedM(ftot, 1) = zeros(2,1);
pedM(vmax, 1) = 1.5 * mtopix;
pedM(layer, 1) = 1;
pedM(weight, 1) = 8;
pedM(radius, 1) = 0.3 * mtopix;
pedM(tstart, 1) = 1;
pedM(tend, 1) = inf;
pedM(status, 1) = 1;    % [0: not started; 1: on the road; 2: on the stairs; 4: finished]

% variables for time iteration
dt = 0.1;
T = 100;
pedM_cell = cell(1, T/dt);
M_cell = cell(1, T/dt);

% variables for loop over pedestrians
nrped = length(pedM(1, :));

% variables for pedestrian interaction force
A_soc = 20 * mtopix;
B_soc = 5;
lambda = 0.2;
A_phys = 30 * mtopix;
B_phys = 5;
d_ped = zeros(2,1);
r_ped = 0;
n_ped = zeros(2,1);
e_ped = zeros(2,1);
phi_ped = 0;

% variables for wall force
intRad_m = 1.5;
intRad_pix = intRad_m * mtopix; % CAUTION: This has to be a whole number!
vect_wall = zeros(2,1);
dist_wall = inf;
n_wall = zeros(2,1);
A_wall = 15 * mtopix;
B_wall = 0.2 * mtopix;

% variables used to calculate the total force
% weigth_fped = 0.01;
% weight_fwall = 0.01;
% weight_ftarget = 0.9999;
% weight_f = ([1 1 100]) / norm([1 1 100]); % weight of the forces in the folowing order: [pedestrian_force wall_force target_force]

% calculate target forces with fast marcching algorithm
M = loadSituation();
[VFX, VFY, I] = computeVF(M);