function [e,n,u]=ECEF2enu(lat,lon,dX,dY,dZ)

% Denne funksjonen gjere ECEF koordinat om til ENU koordinat. East, north,
% up.

M = [-sin(lon)          cos(lon)               0 ;   % Matrise som formar om.
    -sin(lat)*cos(lon)  -sin(lat)*sin(lon)     cos(lat);
    cos(lat)*cos(lon)   cos(lat)*sin(lon)      sin(lat)];

dP = [dX ; dY ; dZ];
dP1 = M * dP;

e = dP1(1);
n = dP1(2);
u = dP1(3);