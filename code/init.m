% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

% This is the initialization file. In here, the used matrizes and variables
% are initialized

clear all
clc

% conversion meter to pixel
mtopix = 10; % one meter in reality are 10 pixels in our matrizes

% variables for loop over pedestrians
nrped_end = 50;
nrped_mom = 0;

% pedestrian matrix
pedM = zeros(22, nrped_end);

% aid to access to entries of pedestrian matrix
% CAUTION: Because of the indices of a matrix (for M(i,j), i is the 
% y-coordinate and j is the x-coordinate), we change here the order of 
% the indices to address coordinates in a vector 
pos = [2 1]';   
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
% statstairs is 0 or 1, 1 meaning the pedestrian already made his
% decision and 0 meaning he can still change the target
statstairs = 22;

% variables for time iteration
dt = 0.1;
T = 400;

% variables for pedestrian interaction force
c_soc = 0.75 * mtopix;
A_soc = 100 * mtopix;
B_soc = 5;
lambda = 0.3;
A_phys = 30 * mtopix;
B_phys = 2;
d_ped = zeros(2,1);
r_ped = 0;
n_ped = zeros(2,1);
e_ped = zeros(2,1);
phi_ped = 0;

% constant to reduce speed on stairs
c_onstairs = 0.55;

% variables for wall force
c_wall = 0.12 * mtopix;
intRad_m = 1.5;
intRad_pix = intRad_m * mtopix; % CAUTION: This has to be a whole number!
vect_wall = zeros(2,1);
dist_wall = inf;
n_wall = zeros(2,1);
A_wall = 15 * mtopix;
B_wall = 0.2 * mtopix;

% variables used to calculate the total force
weight_fsoc = 1.1;    % weight of the social force
weight_fwall = 250;  % weight of the wall force
weight_ftarg = 3650; % weight of the target force

% calculate target forces with fast marching algorithm
[M, Layer, Train] = getMap();
[Vectorfields] = generateVectorfields(M, Layer);

% stairselected is the number of pedestrians heading to each target at the
% moment
[stairselected] = zeros(size(Vectorfields,1),1);

% find possible starting points
s_area = searchStartingpoints(M);

% cells to save pedM for each person and each timestep. Is the base for
% the video.
pedM_cell = cell(1, T/dt);
stair_cell = cell(1, T/dt);
for i=1:T/dt
    pedM_cell{1,i} = zeros(22, nrped_end);
    stair_cell{1,i} = zeros(size(Vectorfields,1),1);
end    