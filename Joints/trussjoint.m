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

%% leghe
[rho, E, Ftu, Fty, Fbear, Fshear, v] = materials('Al7075');


%% falcon
g = 9.81;
M = 15e3;
h = 6.5;
Pa = 6.8*g*M;
Mb = 2.5*g*M*h/2;
R = 1.575/2;

%% NS f-f beam stability
k = 0.65;

Peq = (Pa + 2*Mb/R)*1.25;
t = sqrt(Peq/(pi^2*E)*k^2*12);

t = max([0.01, t]); 
L = 0.76;
L2 = 0.76;

Mtrusses = 8*t^2*L*rho + 14*t^2*L2*rho;
Mframes = 2*pi*(R^2 - (R - t)^2);

MNS = Mtrusses + Mframes;

%% RS+ECS f-f beam stability
L = 1.5;
l = 0.9;
Mtrusses = 7*t^2*L*rho + 12*t^2*L2*rho;
Mframes = 2*pi*(R^2 - (R - t)^2);

MECS = Mtrusses + Mframes;

%% RS only f-f beam stability (same design)
MRS = MECS; 






