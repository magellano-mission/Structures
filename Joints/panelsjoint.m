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
[rhoAl, EAl, FtuAl, FtyAl, FbearAl, FshearAl, vAl] = materials('Al7075');
[rhoA, EA, FtuA, FtyA, FbearA, FshearA, vA] = materials('A286');

%% parametri geometrici
ts = 0.0125;        % spessore stack
tj = 0.003;         % spessore joint
Rr = 0.002;         % d rivetti
L = 0.5;            % lato stack e joint

%% Resistenza lamiera non forata
M = 250;
F = 6.8*9.81*M*2;
MS = tj*L*FtyAl - F; 

%% Resistenza a taglio rivetti
n1 = ceil(F/(pi*Rr^2*FshearA));

%% Resistenza a bearing delle joint(e stack)
n2 = ceil(F/(pi*2*Rr*FbearAl));

%% Resistenza a bearing delle rivetti
n3 = ceil(F/(pi*2*Rr*FbearA));

%% Resistenza a trazione delle lamiere forate
nmax = floor((L - F/(tj*FtyAl))/(2*Rr));

%% lacerazione Stack e joint forate
n = max([n1, n2, n3]);

ds = F/(n*2*ts*FshearAl);
dj = F/(n*2*tj*FshearAl);

Rs = 1.575/2;
th = asin(L/(2*Rs));
Asc = (Rs)^2*th;
Atri = (Rs*sin(th))*(Rs*cos(th));
A = Asc - Atri;

h = Rs*(1-cos(th)) + tj;
Vc = h*L^2 - A*L;
M = (rhoAl*Vc + 3.5)*7;



