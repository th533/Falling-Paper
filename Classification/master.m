%% Main script for classifying falling behaviours

%Large Scale Automated Investigation of Free-Falling Paper Shapes via
%Iterative Physical Experimentation
%Toby Howison, Josie Hughes & Fumiya Iida

%% Circle experiments
load dataCircle 
load humanClassificationCircle
classifyBehaviour
assignClusterLabels
save('dataCircleClassified','behaviourAuto','dx','dy','dz','pathLength','time','radius','width')

%% Hexagon experiments
load dataHexagon
load humanClassificationHexagon
classifyBehaviour
assignClusterLabels
save('dataHexagonClassified','behaviourAuto','dx','dy','dz','pathLength','time','radius','width')

%% Square experiments
load dataSquare
load humanClassificationSquare
classifyBehaviour
assignClusterLabels
save('dataSquareClassified','behaviourAuto','dx','dy','dz','pathLength','time','radius','width')

%% Cross experiments
load dataCross
load humanClassificationCross
classifyBehaviour
assignClusterLabels
save('dataCrossClassified','behaviourAuto','dx','dy','dz','pathLength','time','radius','width')

%% Plot output in behavioural Re-I* parameter space
plotBehaviour