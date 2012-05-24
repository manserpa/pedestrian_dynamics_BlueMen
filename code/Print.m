% Modeling and Simulating Social Systems with MATLAB
% BlueMen - Pedestrian Dynamics
% Dominic Hänni, Patrick Manser, Stefan Zoller

% this file - as the name says - is for printing the situation. Necessary
% to make the print working is the input matrix M (M), the matrix Layer 
% (containg all targets) and the input cell pedM_cell. Output will be a 
% nice simulation and a .avi file containing the video.

% get size of the map to intialize a figure with that size
[m,n] = size(M);
h=figure('Position',[ 0,180,2*n,2*m]);

% Implement the fast marching toolbox
path(path, 'fast_marching/');
path(path, 'fast_marching/toolbox/');
path(path, 'fast_marching/data/');

hold on

% generate a movie of the iteration. Make sure that you are not moving the
% window because videowriter actually makes a screenshot of each frame. It
% wont work if you move the window. The while loop is to not overwrite
% existing files.
save_vid = 1;
while save_vid < 20
    vid = 'video_V1-';
    version = num2str(save_vid);
    data_type = '.avi';
    if exist([vid version data_type]) == 0
        vidObj = VideoWriter([vid version data_type]);
        break
    end
    save_vid = save_vid + 1;
end
vidObj.FrameRate =  8;
open(vidObj);

% get the number of layers
m = size(Layer,3);

% ends is a help-cell in which vectors with the locations of all targets
% are saved.
ends = {1,m};

% Plo is a help-matrix containing the colors of all the elements appearing
% in the final plot
Plo = M;
% locate the slow-areas
slowarea = find(M == 3);
% locate the starts
starts = find(M == 2);
% locate the ends
for i=1:m
    ends{1,i} = find(Layer(:,:,i) == inf);
end
% slowareas are white
Plo(slowarea) = 1;
% starts are a 70% grey
Plo(starts) = 0.7;
% ends are a 30% grey
for i=1:m
    Plo(ends{1,i})=0.3;
end

% plot the image into the figure
imageplot(Plo);

% if a trainmap exists, he appears in the map
trainiter = size(Train,2);
if trainiter > 1
    trainloop = 0;
    k = 0;
    while trainloop <= trainiter
        % clear the last iteration step
        clf
        hold on

        Plo(165:219,1:trainloop) = Train(165:219,(trainiter+1-trainloop):...
            trainiter);

        % plot the map
        imageplot(Plo);

        % save the current frame and write it into the video file
        currFrame = getframe(h);
        writeVideo(vidObj, currFrame);

        % function to brake the train
        breakfunc = -(16/trainiter)*trainloop + 20;
        k = floor(breakfunc);
        trainloop = trainloop + k;

        % the smaller the pause the faster the print
        pause(0.03)
    end

    % small break after the train arrives
    for i=1:20
        currFrame = getframe(h);
        writeVideo(vidObj, currFrame);

        pause(0.02)
    end
end

% stop criterion for the video: the video keeps going until the last
% pedestrian reached his target
StopIter = 1;
while StopIter < T/dt
    % pedM_cell has matrices in it, which are zero when every pedestrian
    % has disappeared
    if pedM_cell{1,StopIter}(1,1) == 0
        break
    else
        StopIter = StopIter + 1;
    end
end

% iteration in which the pedestrians are moving with every step. The
% informations about velocities, positions and so on are saved in the 
% pedM_cell
for i = 1 : StopIter
    % clear the last iteration step
    clf
    hold on

    % plot the map
    imageplot(Plo);
    
    % text frame containing the current time
    mom_time = num2str(i*dt);
    time = 'current time: ';
    text(5, 38, [time mom_time]);
    
    % text frame containing the current number of passengers
    mom_ped = num2str(length(find(pedM_cell{1,i}(status,:)==1)));
    numb_ped = 'number of pedestrians: ';
    text(5, 18, [numb_ped mom_ped]);
    
    % plot every pedestrian who is moving around. pedestrians who reached
    % the target wont be plotted
    for j=1:nrped_mom
        if pedM_cell{1,i}(status,j) ~= 4
            drawPedestrian(pedM_cell{1,i}(pos,j),pedM_cell{1,i}(radius,j))
        end
    end

    % save the current frame and write it into the video file
    currFrame = getframe(h);
    writeVideo(vidObj, currFrame);   
    
    % the smaller the pause the faster the print
    pause(0.03)
    
end

% video is done and saved in the same folder as the Print.m file.
close(vidObj);
