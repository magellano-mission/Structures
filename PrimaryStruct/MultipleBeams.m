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

%%%%%%%%%%%%%%%%%% 1st beam %%%%%%%%%%%%%%%%%%%%%%%%%%
% stack with RS only

g = 9.81;
Mrs = 150*4;
Mc = 21;
M1 = Mrs + Mc;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 1.5;                % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M1*h;
I = (flat/0.56)^2/E*M1*h^3;
taxial = (2*R - sqrt(4*R^2 - 4*Aaxial/pi))/2;
tlat = I/(pi*R^3);

t = max([taxial, tlat]);

%% Limit Loads
Pa = AxialLoad*M1;
Pl = LatLoad*M1;
Mb1 = LatLoad*h/2*M1;

%% Equivalent Load
Peq = Pa + 2*Mb1/R;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*R*pi);
tyield = Pyield/(Fty*2*R*pi);

t = max([t, tult, tyield]);

%% Stability
eps = 0.2;
[MS0] = SafetyMarginCylinder(t, R, E, v, Pult, eps);

if MS0 < 0 
   t = fsolve(@(t) SafetyMarginCylinder(t, R, E, v, Pult, eps), t);
   t1 = max([t, 2e-3]);
   [MS1] = SafetyMarginCylinder(t1, R, E, v, Pult, eps);
else 
    MS1 = MS0;
end


% Primal structure mass
m1 = 2*pi*rho*h*R*t1;

%%%%%%%%%%%%%%%%%% 2nd beam %%%%%%%%%%%%%%%%%%%%%%%%%%
% stack with RS and ECS

%%
g = 9.81;
Mrs = 150*4;
Mecs = 500*2;
Mc = 21;
M2 = M1 + Mrs + Mecs + Mc;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 1.5;                % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M2*h;
I = (flat/0.56)^2/E*M2*h^3;
taxial = (2*R - sqrt(4*R^2 - 4*Aaxial/pi))/2;
tlat = I/(pi*R^3);

t = max([taxial, tlat]);

%% Limit Loads
Pa = AxialLoad*M2;
Pl = LatLoad*M2;
Mb2 = LatLoad*h/2*M2 + Mb1;

%% Equivalent Load
Peq = Pa + 2*Mb2/R;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*R*pi);
tyield = Pyield/(Fty*2*R*pi);

t = max([t, tult, tyield]);

%% Stability
eps = 0.2;
[MS0] = SafetyMarginCylinder(t, R, E, v, Pult, eps);

if MS0 < 0 
   t = fsolve(@(t) SafetyMarginCylinder(t, R, E, v, Pult, eps), t);
   t2 = max([t, 2e-3]);
   [MS2] = SafetyMarginCylinder(t2, R, E, v, Pult, eps);
else 
    MS2 = MS0;
end

% Primal structure mass
m2 = 2*pi*rho*h*R*t2;

%%
%%%%%%%%%%%%%%%%%%% 3rd beam %%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st NS stack 

%%
g = 9.81;
Mns = 250*7;
Mc = 21;
M3 = M2 + Mns + Mc;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 1;                % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M3*h;
I = (flat/0.56)^2/E*M3*h^3;
taxial = (2*R - sqrt(4*R^2 - 4*Aaxial/pi))/2;
tlat = I/(pi*R^3);

t = max([taxial, tlat]);

%% Limit Loads
Pa = AxialLoad*M3;
Pl = LatLoad*M3;
Mb3 = LatLoad*h/2*M3 + Mb2;

%% Equivalent Load
Peq = Pa + 2*Mb3/R;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*R*pi);
tyield = Pyield/(Fty*2*R*pi);

t = max([t, tult, tyield]);

%% Stability
eps = 0.2;
[MS0] = SafetyMarginCylinder(t, R, E, v, Pult, eps);

if MS0 < 0 
   t = fsolve(@(t) SafetyMarginCylinder(t, R, E, v, Pult, eps), t);
   t3 = max([t, 2e-3]);
   [MS3] = SafetyMarginCylinder(t3, R, E, v, Pult, eps);
else 
    MS3 = MS0;
end

% Primal structure mass
m3 = 2*pi*rho*h*R*t3;

%%
%%%%%%%%%%%%%%%%%%% 4th beam %%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd NS stack 

%%
g = 9.81;
Mns = 250*7;
Mc = 21;
M4 = M3 + Mns + Mc;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 1;                % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M4*h;
I = (flat/0.56)^2/E*M4*h^3;
taxial = (2*R - sqrt(4*R^2 - 4*Aaxial/pi))/2;
tlat = I/(pi*R^3);

t = max([taxial, tlat]);

%% Limit Loads
Pa = AxialLoad*M4;
Pl = LatLoad*M4;
Mb4 = LatLoad*h/2*M4 + Mb3;

%% Equivalent Load
Peq = Pa + 2*Mb4/R;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*R*pi);
tyield = Pyield/(Fty*2*R*pi);

t = max([t, tult, tyield]);

%% Stability
eps = 0.2;
[MS0] = SafetyMarginCylinder(t, R, E, v, Pult, eps);

if MS0 < 0 
   t = fsolve(@(t) SafetyMarginCylinder(t, R, E, v, Pult, eps), t);
   t4 = max([t, 2e-3]);
   [MS4] = SafetyMarginCylinder(t4, R, E, v, Pult, eps);
else 
    MS4 = MS0;
end

% Primal structure mass
m4 = 2*pi*rho*h*R*t4;

%%
%%%%%%%%%%%%%%%%%%% 5th beam %%%%%%%%%%%%%%%%%%%%%%%%%%
% 3rd NS stack 

%%
g = 9.81;
Mns = 250*7;
Mc = 21;
M5 = M4 + Mns + Mc;
faxial = 25;            % [Hz]
flat = 10;              % [Hz]

%% From Falcon Manual
d = 1.575;              % [m] diameter
R = d/2;
h = 1;                % [m] heigth
AxialLoad = 6.8;        % [g]
LatLoad = 2.5;          % [g]

%% Alloy data (7075)
[rho, E, Ftu, Fty, v] = materials('Al7075');

%% Computation
Aaxial = (faxial/0.25)^2/E*M5*h;
I = (flat/0.56)^2/E*M5*h^3;
taxial = (2*R - sqrt(4*R^2 - 4*Aaxial/pi))/2;
tlat = I/(pi*R^3);

t = max([taxial, tlat]);

%% Limit Loads
Pa = AxialLoad*M5;
Pl = LatLoad*M5;
Mb5 = LatLoad*h/2*M5 + Mb4;

%% Equivalent Load
Peq = Pa + 2*Mb5/R;

%% Tensile Strength

% Ultimate and yield Load
Pult = Peq*1.25;
Pyield = Peq*1.1;

% thickness according ultimate and yield loads
tult = Pult/(Ftu*2*R*pi);
tyield = Pyield/(Fty*2*R*pi);

t = max([t, tult, tyield]);

%% Stability
eps = 0.2;
[MS0] = SafetyMarginCylinder(t, R, E, v, Pult, eps);

if MS0 < 0 
   t = fsolve(@(t) SafetyMarginCylinder(t, R, E, v, Pult, eps), t);
   t5 = max([t, 2e-3]);
   [MS4] = SafetyMarginCylinder(t5, R, E, v, Pult, eps);
else 
    MS4 = MS0;
end

% Primal structure mass
m5 = 2*pi*rho*h*R*t5;

