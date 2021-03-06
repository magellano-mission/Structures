close all; clear; clc

%% Adding to path
addpath(genpath(fileparts(pwd)))

%% Figure Initialization    
load('MagellanoColorMap.mat');
DefaultOrderColor = get(0, 'DefaultAxesColorOrder');
NewOrderColor = [0.9490    0.4745    0.3137
                 0.1020    0.6667    0.74120
                 155/255   155/255   155/255
                 DefaultOrderColor];  
             
set(0,'DefaultFigureColormap', MagellanoColorMap);
set(0, 'DefaultAxesColorOrder', NewOrderColor);
set(0,'DefaultLineLineWidth', 2)
set(0,'DefaultLineMarkerSize', 10)
set(0, 'DefaultFigureUnits', 'normalized');
set(0, 'DefaultFigurePosition', [0 0 1 1]);
set(0, 'DefaultTextFontSize', 18);
set(0, 'DefaultAxesFontSize', 18);
set(0, 'DefaultAxesXGrid', 'on')
set(0, 'DefaultAxesYGrid', 'on')
set(0, 'defaultLegendInterpreter', 'latex');
set(0, 'defaultAxesTickLabelInterpreter', 'latex');

%%
% run('config.m')

%% constants
g = 9.81;

%% Spacecraft
M = 12e3;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 7;                  % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M*h;
I = (flat/0.56)^2/E*M*h^3;

taxial = (2*R - sqrt(4*R^2 - 4*Aaxial/pi))/2;
tlat = I/(pi*R^3);

%% Limit Loads
Pa = AxialLoad*M;
Pl = LatLoad*M;
Mb = LatLoad*h/2*M;

%% Equivalent Load
Peq = Pa + 2*Mb/R;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*R*pi);
tyield = Pyield/(Fty*2*R*pi);

%% Stability
% sizing for higher thickness?

phi = 1/16*sqrt(R/tlat);
gamma = 1 - 0.901*(1 - exp(-phi));
sigmaCR = gamma*E/(sqrt(3*(1 - v^2)))*tlat/R;
A = pi*R^2 - pi*(R - tlat)^2;
PCR = sigmaCR*A;

MS = PCR/Pult - 1;

%% Primal structure mass
m = 2*pi*rho*h*R*tlat;




