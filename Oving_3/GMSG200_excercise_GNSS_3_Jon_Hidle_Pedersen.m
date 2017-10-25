%% Excercise GNSS 3, GMSG200
% Jon Hidle Pedersen
% jon.hidle.pedersen@nmbu.no
% Computation of azimuth and elevation angles to GPS-satellites.
clear
clc
format long g

%% Oving a):


%% Leser inn RINEX-fila:
filnavn = 'T827158A.17N';

[header,rinex_body,antall] = les_rinex_nav(filnavn);


%% Konstantar:
t0e = [17, 06, 07, 07, 30, 00.00];   % Refferanse epoke

GM = 3.986005E+14;              % m3/s2 geocentric gravitational constant

Omega_e = 7.2921151467E-5;      % rad/s Earth rotation rate

% Reciver coordinates:
T837_coordinates = [3179085.143, 603490.567, 5478049.283]; % X,Y,Z coodrinates in ECEF?

% Satelittane me onsker ECEF-koordinat til:
satellitt_nummer = [10, 12, 13, 15];


%% Reknar ut koordinat til kvar satellitt, nermast den bestemte tidsepoken:
ECEF_koord_liste = [];

for sat_num = satellitt_nummer
    
    % Hentar ut alle malingane fra kvar satelitt med likt satellittnummer:
    data_plassering = find(rinex_body(:,1)==sat_num);
    
    satellitt_data = rinex_body(data_plassering,:);
    
    % Velger ut den maling som er nermast den bestemte tidsepoken.
    % Funksjonen hentar ut tidsdifferansen til malingane i sekund og finn
    % deretter den minste verdien samt indeksen til den verdien. Indeksen
    % brukast slik at den nermaste malinga blir brukt i ECEF-funksjonen.
    sek_trans = [31556926, 2629743.83, 86400, 3600, 60, 1]';
    [tids_differanse, indeks] = min(abs((satellitt_data(:,2:7)...
                                   *sek_trans - t0e*sek_trans)));
    
    
    % Bereknar ECEF-koordinat
    [X_k,Y_k,Z_k] = ECEF_from_RINEX(t0e, GM, Omega_e,...
                                    satellitt_data(indeks,:));
    
    % Lagrar koordinatar i ei liste, indeksert med satelitt_nummer
    ECEF_koord_liste = [ECEF_koord_liste; sat_num, X_k,Y_k,Z_k];

end



%% Compute azimut and elevation angles to each satellite:
% 3.196, side 128.
% http://www.sattvengg.com/2013/10/azimuth-and-elevation-angle-antenna.html






%% Oving b):




