function [MS] = SafetyMarginCylinder(t, R, E, v, Pult, eps)

phi = 1/16*sqrt(R/t);
gamma = 1 - 0.901*(1 - exp(-phi));
sigmaCR = gamma*E/(sqrt(3*(1 - v^2)))*t/R;
A = pi*R^2 - pi*(R - t)^2;
PCR = sigmaCR*A;

MS = PCR/Pult - eps;