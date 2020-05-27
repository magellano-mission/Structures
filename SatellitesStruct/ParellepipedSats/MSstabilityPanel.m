function [MS] = MSstabilityPanel(t, l1, l2, E, v, Pult, eps)

k = 0.5;
sigmaCR = min([k*pi^2*E/(1 - v^2)*(t/l1)^2, k*pi^2*E/(1 - v^2)*(t/l2)^2]);

A = 2*(l1 + l2)*t;
PCR = sigmaCR*A;
MS = PCR/Pult - 1 - eps;