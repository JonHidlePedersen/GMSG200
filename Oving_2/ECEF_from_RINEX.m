function [X_k,Y_k,Z_k] = ECEF_from_RINEX(t, GM, Omega_e, satellitt_data)
% Leser informasjon fra ei RINEX-fil og reknar ut ECEF-koordinat til 
% satelitten. 
% - t0e er tidsepoken. [y,m,d,h,m,s] Sett til 0 hvis ingen er deffinert.
% - GM er geosentrisk gravitasjonskonstant.
% - Omega_e er jordas rotasjonsrate (rad/sek)
% - satellitt_data inneheld parameterane til satelitten.
% - RINEX-filformat: ftp://igs.org/pub/data/format/rinex210.txt


%% Konstantar henta fra RINEX-fila:
t0e = satellitt_data(19);
A_root = satellitt_data(18);           % Square root of the semi-major axis
delta_n = satellitt_data(13);          % Mean motion difference
M0 = satellitt_data(14);               % Mean anomaly at reference time
eccentricity = satellitt_data(16);     % Eccentricity
omega = satellitt_data(25);            % omega
C_uc = satellitt_data(15);             % Cuc
C_us = satellitt_data(17);             % Cus
C_rc = satellitt_data(24);             % Crc
C_rs = satellitt_data(12);             % Crs
C_ic = satellitt_data(20);             % Cic
C_is = satellitt_data(22);             % CIS
i0 = satellitt_data(23);               % i0
IDOT = satellitt_data(27);             % IDOT, i dot 
OMEGA0 = satellitt_data(21);           % OMEGA
OMEGADOT = satellitt_data(26);         % OMEGA DOT


%% Berekna tid:
tk = t - t0e;                         % Time elapsed since refference epoch


%% Formlar:
A = (A_root)^2;          % Semi-major axis
n0 = sqrt(GM / A^3);     % Computed mean motion
n = n0 + delta_n;        % Corrected mean motion
Mk = M0 + n*tk;          % Mean anomaly ??????????????????????????????????

% Keplers likning for eccentric anomaly
Ek = Mk;
for i = 1:50
    Ek = Mk + eccentricity * sin(Ek);
end

% Finn sann anomali, atan2 for rett kvadrant:
vk_cos = (cos(Ek)-eccentricity)/(1-eccentricity*cos(Ek)); % True anomaly
vk_sin = (sqrt(1-eccentricity^2)*sin(Ek))/(1-eccentricity*cos(Ek)); % True anomaly
vk = atan2(vk_sin , vk_cos); % Sann anomali

Fi_k = vk + omega;      % Argument of latitude

delta_u_k = C_uc*cos(2*Fi_k) + C_us*sin(2*Fi_k); % Argument of lat corr
delta_r_k = C_rc*cos(2*Fi_k) + C_rs*sin(2*Fi_k); % Radius correction
delta_i_k = C_ic*cos(2*Fi_k) + C_is*sin(2*Fi_k); % Inclination correction

u_k = Fi_k + delta_u_k;                 % Corrected argument of latitude
r_k = A*(1 - eccentricity*cos(Ek)) + delta_r_k;     % Corrected radius
i_k = i0 + IDOT*tk + delta_i_k;         % Corrected inclination

X_marked_k = r_k * cos(u_k);    % Position in orbital plane
Y_marked_k = r_k * sin(u_k);    % Position in orbital plane


% Corrected longitude of ascending node
OMEGA_k = OMEGA0 + (OMEGADOT - Omega_e)*tk - Omega_e*t0e;  

% Earth fixed geocentric satellite coordinates
X_k = X_marked_k*cos(OMEGA_k) - Y_marked_k*sin(OMEGA_k)*cos(i_k);   
Y_k = X_marked_k*sin(OMEGA_k) + Y_marked_k*cos(OMEGA_k)*cos(i_k);
Z_k = Y_marked_k*sin(i_k);    