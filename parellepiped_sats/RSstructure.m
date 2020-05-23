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
h = 0.45;                   % [m] heigth
LatLoad = 6.8;              % [g]
AxialLoad = 2.5;            % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M*L;
I = (flat/0.56)^2/E*M*L^3;

taxial = Aaxial/(4*L);
tlat = 3*I/h^3;

%% Limit Loads
Pa = AxialLoad*M;
Pl = LatLoad*M;
Mb = LatLoad*L/2*M;

%% Equivalent Load
Asection = 4*L*tlat;
sigma_eq = Pa/Asection + Mb*h/2/I;
Peq = sigma_eq*Asection;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*4*L);
tyield = Pyield/(Fty*4*L);

%% Stability
% sizing for higher thickness?
k = 0.5;
sigmaCR = k*pi^2*E/(1 - v^2)*(tlat/h)^2;

A = 4*L*tlat;
PCR = sigmaCR*A;

MS = PCR/Pult - 1;

%% t for stability
t = nthroot(Pult*h^2*(1-v^2)/(4*k*pi^2*E*L) , 3);

%% Primal structure mass
m_beam = (h^2 - (h-2*t)^2)*L*rho;
m = (L^3 - (L - 2*t)^3)*rho;