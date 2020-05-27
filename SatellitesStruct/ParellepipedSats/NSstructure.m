close all; clear; clc

%% Adding to path
addpath(genpath(fileparts(pwd)))

%% Figure Initialization    
% load('MagellanoColorMap.mat');
% DefaultOrderColor = get(0, 'DefaultAxesColorOrder');
% NewOrderColor = [0.9490    0.4745    0.3137
%                  0.1020    0.6667    0.74120
%                  155/255   155/255   155/255
%                  DefaultOrderColor];  
%              
% set(0,'DefaultFigureColormap', MagellanoColorMap);
% set(0, 'DefaultAxesColorOrder', NewOrderColor);
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
M = 250;                % [kg] Sc mass
faxial = 35;            % [Hz]
flat = 35;              % [Hz]

%% 
L = 1;                  % [m] NS outer-length
l = 0.75;               % [m] in-plane length
LatLoad = 6.8;          % [g] lateral acceleration
AxialLoad = 2.5;        % [g] axial acceleration

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M*L;
I = (flat/0.56)^2/E*M*L^3;

taxial = Aaxial/(4*l);
tlat = 3*I/l^3;

%% Limit Loads
Pa = AxialLoad*M;
Pl = LatLoad*M;
Mb = LatLoad*L/2*M;

%% Equivalent Load
Asection = 4*l*tlat;
sigma_eq = Pa/Asection + Mb*l/2/I;
Peq = sigma_eq*Asection;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*4*l);
tyield = Pyield/(Fty*4*l);

t = max([tult, tyield, taxial, tlat]);

%% Stability
eps = 0.25; % safety margin to instability

[MS0] = MSstabilityPanel(t, l, l, E, v, Pult, eps);

if MS0 < 0 
   tstab = fsolve(@(t)  MSstabilityPanel(t, l, l, E, v, Pult, eps), t);
   [MS] = MSstabilityPanel(tstab, l, l, E, v, Pult, eps);
else
    tstab = t;
    MS = MS0;
end

%% t for stability
t = max([t, tstab]);

%% Primal structure mass
m = (l^2 - (l - 2*t)^2)*L*rho + 2*l^2*t*rho;
