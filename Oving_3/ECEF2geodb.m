function [lat,lon,h]=ECEF2geodb(a,b,X,Y,Z)
% Bowrings metode.

e2 = (a^2 - b^2) / a^2;  % Første eksentrisitet.
ee2 = (a^2 - b^2) / b^2;  % Andre eksentrisitet.
p = sqrt(X^2 + Y ^2);      
u = atan2(Z * a , p * b);   % Verdi som trengs.


lat = atan2(Z + ee2 * b * sin(u)^3 , p - e2 * a * cos(u)^3 );


N = Nrad(a,b,lat);  % Brukar for å rekne lon og h.

lon = atan2(Y , X); 
h = p * cos(lat) + Z * sin(lat) - N * (1 - e2 * sin(lat)^2);





