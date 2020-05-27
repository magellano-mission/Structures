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
M = 16.5e3;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 6.4;                  % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho,E,Ftu,Fty,v] = materials('Al7075');

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

%% 10 stringers
N = 10;
b = d*pi/N;
th = 0:360/N:(360-360/N);

h_str = abs(R*sind(th));
S = sum(h_str.^2);

%% 
t_acustic = 0.00127;              % [cm]
[MS] = SafetyMargin(t_acustic, R, S, I, E, v, b, Pult); % < 0 cycle to get MS = 0

%% find the zero of the MS function
t_opt = fsolve(@(t) SafetyMargin(t, R, S, I, E, v, b, Pult), t_acustic);

%% mass computation
Askin = pi*R^2 - pi*(R - t_opt)^2;
mskin = Askin*h*rho;


I_skin = pi*R^3*t_opt;
Istr = I - I_skin;
Astr = Istr/S;
mstr = N*Astr*h*rho;

m = (mskin + mstr)*1.25;




