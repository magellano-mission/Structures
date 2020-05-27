function [rho, E, Ftu, Fty, Fbear, Fshear, v] = materials(material)
% 'Al7075' 'Al6061', 'AlBeMet', 'Steel', 'Ti6Al4V'
% rho [kg/m3] : density
% E   [Pa]    : Young modulus
% Ftu [Pa]    : Ultimate stress
% Fty [Pa]    : Yield stress
% v   [-]     : Poisson ratio

switch material
    case 'A286'
        Fty = 1400e6;
        Ftu = 620e6;
        Fbear = 760e6;
        Fshear = 760e6;
        E = 170e9;
        v = 0.33;
        rho = 7.92e3;
    case 'Al6061'
        % Al 6061-T6
        rho = 2.72e3;
        E = 68.9e9;
        Ftu = 290e6;
        Fty = 241e6;
        v = 0.33;
    case 'Al7075'
        % Al 7075-T6
        Fbear = 600e6;
        Fshear = 330e6;
        rho = 2.8e3;
        E = 71.7e9;
        Ftu = 538e6;
        Fty = 483e6;
        v = 0.33;
    case 'AlBeMet'
        % AlBeMet 162 rolled sheet
        rho = 2.071e3; %[kg/m^3]
        E = 193e9;    %[Pa]
        Ftu = 386e6;
        Fty = 276e6;
        v = 0.17;
    case 'Steel'
        % Steel 17-4PH H1150z
        rho = 7.86e3;
        E = 196e9;
        Ftu = 860e6;
        Fty = 620e6;
        v = 0.33;
    case 'Ti6Al4V'
        % Titanium Ti6Al4V
        rho = 4.43e3;
        E = 110e9;
        Ftu = 900e6;
        Fty = 855e6;
        v = 0.33;
end


end