function [MS] = SafetyMarginSemiMonoque(t, R, S, I, E, v, b, Pult)

I_skin = pi*R^3*t;
I_str = I - I_skin;

A = I_str/S;

%% Stability
z = b^2/(R*t)*sqrt(1-v^2);    % from https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19930084510.pdf
k = 4*sqrt(3)*z/pi^2;

sigmaCR = k*pi^2*E/(12*(1 - v^2))*(t/b)^2;
PCR = sigmaCR*A;

MS = PCR/Pult - 1;