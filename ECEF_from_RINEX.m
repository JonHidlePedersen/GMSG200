function [X_k,Y_k,Z_k] = ECEF_from_RINEX(t0e, GM, Omega_e, satelitt_maling)
% Leser informasjon fra ei RINEX-fil og reknar ut ECEF-koordinat til 
% satelitten. 
% - t0e er tidsepoken. [y,m,d,h,m,s] Sett til 0 hvis ingen er deffinert.
% - GM (lille my) er geosentrisk gravitasjonskonstant.
% - Omega_e er jordas rotasjonsrate (rad/sek)
% - satelitt_data inneheld parameterane til satelitten.



% Konstantar henta fra RINEX-fila:
t = satelitt_maling(2:7);
A_root = satelitt_maling(18);            % Square root of the semi-major axis
delta_n = satelitt_maling(13);           % Mean motion difference
M0 = satelitt_maling(14);                % Mean anomaly at reference time
eccentricity = satelitt_maling(16);       % Eccentricity
omega = satelitt_maling(25);               % omega
C_uc = satelitt_maling(15);               % Cuc
C_us = satelitt_maling(17);               % Cus
C_rc = satelitt_maling(24);               % Crc
C_rs = satelitt_maling(12);               % Crs
C_ic = satelitt_maling(20);               % Cic
C_is = satelitt_maling(22);               % CIS
i0 = satelitt_maling(23);               % i0
IDOT = satelitt_maling(27);               % IDOT, i dot 
OMEGA0 = satelitt_maling(21);               % OMEGA
OMEGADOT = satelitt_maling(26);               % OMEGA DOT


%% Berekna tid:
t = t * [31556926, 2629743.83, 86400, 3600, 60, 1]'; % Einheit sekund
t0e = t0e * [31556926, 2629743.83, 86400, 3600, 60, 1]'; % Einheit sekund

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
vk = atan2(vk_cos , vk_sin); % Sann anomali


Fi_k = vk + omega;      % Argument of latitude

delta_u_k = C_uc*cos(2*Fi_k) + C_us*sin(2*Fi_k); % Argument of latitude correction
delta_r_k = C_rc*cos(2*Fi_k) + C_rs*sin(2*Fi_k); % Radius correction
delta_i_k = C_ic*cos(2*Fi_k) + C_is*sin(2*Fi_k); % Inclination correction

u_k = Fi_k + delta_u_k;     % Corrected argument of latitude
r_k = A*(1 - eccentricity*cos(Ek)) + delta_r_k;     % Corrected radius
i_k = i0 + IDOT*tk + delta_i_k;     % Corrected inclination

X_marked_k = r_k * cos(u_k);    % Position in orbital plane
Y_marked_k = r_k * sin(u_k);    % Position in orbital plane

OMEGA_k = OMEGA0 + (OMEGADOT - Omega_e)*tk - Omega_e*t0e;   % Corrected longitude of ascending node


X_k = X_marked_k*cos(OMEGA_k) - Y_marked_k*sin(OMEGA_k)*cos(i_k);    % Earth fixed geocentric satellite coordinates
Y_k = X_marked_k*sin(OMEGA_k) + Y_marked_k*cos(OMEGA_k)*cos(i_k);    % Earth fixed geocentric satellite coordinates
Z_k = Y_marked_k*sin(i_k);    % Earth fixed geocentric satellite coordinates


