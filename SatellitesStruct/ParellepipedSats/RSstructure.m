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
M = 150;                % [kg] Sc mass
faxial = 35;            % [Hz]
flat = 35;              % [Hz]

%% 
L = 0.5;                % [m] NS outer-length
l1 = 0.9;               % [m] in-plane length
l2 = 1.5;               % [m] in-plane length
LatLoad = 6.8;          % [g] lateral acceleration
AxialLoad = 2.5;        % [g] axial acceleration

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M*L;
I = (flat/0.56)^2/E*M*L^3;

taxial = Aaxial/(2*(l1 + l2));
[tlat, lcase] = max([2*I/(l2^2*(l2/3 + l1)), 2*I/(l1^2*(l1/3 + l2))]);                           % I = 1/2*l2^2*t*(l2/3 + l1);

t = max([tlat, taxial]);

%% Limit Loads
Pa = AxialLoad*M;
Pl = LatLoad*M;
Mb = LatLoad*L/2*M;

%% Equivalent Load
Asection = 2*(l1 + l2)*t;
if lcase == 1
    I = 1/2*l2^2*t*(l2/3 + l1);
elseif lcase == 2
    I = 1/2*l1^2*t*(l1/3 + l2);
end
ynav = max([l1, l2])/2;
sigma_eq = Pa/Asection + Mb*ynav/I;
Peq = sigma_eq*Asection;

%% Tensile Strength
% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*(l1 + l2));
tyield = Pyield/(Fty*2*(l1 + l2));

t = max([tult, tyield, taxial, tlat]);

%% Stability
eps = 0.25; % safety margin to instability

[MS0] = MSstabilityPanel(t, l1, l2, E, v, Pult, eps);

if MS0 < 0 
   tstab = fsolve(@(t)  MSstabilityPanel(t, l1, l2, E, v, Pult, eps), t);
   [MS] = MSstabilityPanel(tstab, l1, l2, E, v, Pult, eps);
else
    tstab = t;
    MS = MS0;
end

%% t for stability
t = max([t, tstab]);

%% Primal structure mass
m = (l1*l2 - (l1 - 2*t)*(l2 - 2*t))*L*rho + 2*l1*l2*t*rho;