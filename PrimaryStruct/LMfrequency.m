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


%% without tanks
l = 6.5;
R = 1.575/2;
t = 11e-3;
I = pi*R^3*t;
E = 71.7e9;
rho = 2800;
k = 3*E*I/l^3;

Ac = pi*(R^2 - (R - t)^2)*rho;
Mc = l*Ac;

m = 2000 + Ac*1;
M1 = 2200 + Ac*1.5;
M2 = 1200 + Ac*1.5;

MM = diag([m, m, m, M1, M2]);

pos(1) = 0.5;
pos(2) = 1.5;
pos(3) = 2.5;
pos(4) = 3.875;
pos(5) = 5.625;

fxy = @(x, y) (((x - y)/l)^3 + (x/l)^2*(3*(y/2) -(x/2)))/2;
fxx = @(x) (x/l)^3;

F = zeros(5);
for i = 1:5
    for j = 1:5
        xi = pos(i);
        yi = pos(j);
        
        if i == j
            F(i, j) = fxx(xi);
        else
            F(i, j) = fxy(xi, yi);
        end
        
    end
end

K = k*inv(F);
[~, D] = eig(K, MM);
w = diag(abs(sqrt(D)));
f = min(w/(2*pi));

%% lumped tanks
l = 6.5;
R = 1.575/2;
t = 13e-3;
I = pi*R^3*t;
E = 71.7e9;
rho = 2800;
k = 3*E*I/l^3;

Ac = pi*(R^2 - (R - t)^2)*rho;
Mc = l*Ac

m = 1400 + Ac*1;
M1 = 1600 + Ac*1.5;
M2 = 600 + Ac*1.5;

t = 550;

% MM = diag([m, t, m, t, m, t, t, M1, t, M2]);
MM = diag([t, m, t, m, t, m, t, M1, t, M2]);

% pos(1) = 0.5;
% pos(2) = 0.6;
% pos(3) = 1.5;
% pos(4) = 1.6;
% pos(5) = 2.5;
% pos(6) = 2.6;
% pos(7) = 3.6;
% pos(8) = 3.875;
% pos(9) = 5.35;
% pos(10) = 5.625;

pos(1) = 0.25;
pos(2) = 0.5;
pos(3) = 1.25;
pos(4) = 1.5;
pos(5) = 2.25;
pos(6) = 2.5;
pos(7) = 3.25;
pos(8) = 3.875;
pos(9) = 5;
pos(10) = 5.625;

fxy = @(x, y) (((x - y)/l)^3 + (x/l)^2*(3*(y/2) -(x/2)))/2;
fxx = @(x) (x/l)^3;

F = zeros(10);
for i = 1:10
    for j = 1:10
        xi = pos(i);
        yi = pos(j);
        
        if i == j
            F(i, j) = fxx(xi);
        else
            F(i, j) = fxy(xi, yi);
        end
        
    end
end

K = k*inv(F);
[V, D] = eig(K, MM);
w = diag(abs(sqrt(D)));
f = min(w/(2*pi))

        
        



