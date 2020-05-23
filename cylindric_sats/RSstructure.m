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
M = 150;
faxial = 35;            % [Hz]
flat = 35;              % [Hz]

%% 
L = 0.75;                   % NS length
R = 0.28;                   % [m] heigth
LatLoad = 6.8;              % [g]
AxialLoad = 2.5;            % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M*L;
I = (flat/0.56)^2/E*M*L^3;

taxial = Aaxial/(2*pi*R);
tlat = I/(pi*R^3);

%% Limit Loads
Pa = AxialLoad*M;
Pl = LatLoad*M;
Mb = LatLoad*L/2*M;

t = max([tlat, taxial]);

%% Equivalent Load
Asection = 2*pi*R*t;
Peq = Pa + 2*Mb/R; 

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*pi*R);
tyield = Pyield/(Fty*2*pi*R);

%% Stability
t0 = max([t, tult, tyield]);
[MS0] = SafetyMargin(t0, R, E, v, Pult);

if MS0 < 0 
   t = fsolve(@(t) SafetyMargin(t, R, E, v, Pult), t0);
end

[MS] = SafetyMargin(t, R, E, v, Pult);
    
%% Primal structure mass
tt = 1e-3;
t_base = t;
m = (2*pi*L*R*tt + pi*R^2*tt)*rho;
