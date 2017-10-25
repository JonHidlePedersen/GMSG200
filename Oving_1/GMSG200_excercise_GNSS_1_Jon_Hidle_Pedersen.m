%% Excercise GNSS 3, GMSG200
% Jon Hidle Pedersen
% jon.hidle.pedersen@nmbu.no
% Dette programmet reknar ut eksentrisk anomali og sann anomali til ein
% GPS-satelitt ut fra parameterane i ei RINEX-fil.

clear
clc
format long g

%% Leser inn RINEX-fila:
filnavn = 'T827158A.17N';

[header,body,antall] = les_rinex_nav(filnavn);

%% Konstantar:
sat_num = 4;

t = [17, 06, 07, 07, 30, 00.00];   % Tid, fra oppgavetekst

GM = 3.986005E+14; % m3/s2 geocentric gravitational constant

Omega_e = 7.2921151467E-5; % rad/s Earth rotation rate

% Konstantar henta fra RINEX-fila:
t0e = body(sat_num,19);
A_root = body(sat_num,18);            % Square root of the semi-major axis
delta_n = body(sat_num,13);           % Mean motion difference
M0 = body(sat_num,14);                % Mean anomaly at reference time
eccentricity = body(sat_num,16);       % Eccentricity


%% Berekna tid:
[week_t,t] = date2gpstime(2000 + t(1),t(2),t(3),t(4),t(5),t(6))%Hugs ar2000
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


disp('------------------------')
disp('Utrekningar:')
disp('------------------------')
disp('Satelitt nummer:')
disp(sat_num)
disp('Tidspunkt t0e :')
disp(t0e)
disp('Midlere anomali:')
disp(Mk)
disp('Eksentrisk anomali:')
disp(Ek)
disp('Sann anomali:')
disp(vk)








