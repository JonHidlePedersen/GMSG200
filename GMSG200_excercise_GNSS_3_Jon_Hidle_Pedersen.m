%% Excercise GNSS 3, GMSG200
% Jon Hidle Pedersen
% jon.hidle.pedersen@nmbu.no
% Dette programmet 

clear
clc
format long g

%% Leser inn RINEX-fila:
filnavn = 'T827158A.17N';

[header,rinex_body,antall] = les_rinex_nav(filnavn);



%% Konstantar:
t0e = [17, 06, 07, 07, 30, 00.00];   % Refferance epoke, fra oppgavetekst

GM = 3.986005E+14; % m3/s2 geocentric gravitational constant

Omega_e = 7.2921151467E-5; % rad/s Earth rotation rate


% Satelittane me onsker ECEF-koordinat til:
satelitt_nummer = [10, 12, 13, 15];



%% Reknar ut koordinat til kvar satelitt, nermast den bestemte tidsepoken:
ECEF_koord_liste = [];

for sat_num = satelitt_nummer
    
    % Hentar ut alle malingane fra kvar satelitt med likt satellittnummer:
    data_plassering = find(rinex_body(:,1)==sat_num);
    
    satelitt_data = rinex_body(data_plassering,:);
    
    % Velger ut den maling som er nermast den bestemte tidsepoken.
    % Funksjonen hentar ut tidsdifferansen til malingane i sekund og finn
    % deretter den minste verdien samt indeksen til den verdien. Indeksen
    % brukast slik at den nermaste malinga blir brukt i ECEF-funksjonen.
    sek_trans = [31556926, 2629743.83, 86400, 3600, 60, 1]';
    [tids_differanse, indeks] = min(abs((satelitt_data(:,2:7)...
                        *sek_trans - t0e*sek_trans)));
    
    
    % Bereknar ECEF-koordinat
    [X_k,Y_k,Z_k] = ECEF_from_RINEX(t0e, GM, Omega_e, satelitt_data(indeks,:));
    
    % Lagrar koordinatar i ei liste, indeksert med satelitt_nummer
    ECEF_koord_liste = [ECEF_koord_liste; sat_num, X_k,Y_k,Z_k];

end



%% Lagring til fil:
% Opprettar fila:
resultat_fil = fopen('Resultat_Jon_Hidle_Pedersen.txt','wt');

% Skriv til fila:
fprintf(resultat_fil, 'Student: Jon Hidle Pedersen');
fprintf(resultat_fil, '\nGMSG200 Exercise_GNSS_3');
fprintf(resultat_fil, '\nComputer program to compute ECEF coordinates in');
fprintf(resultat_fil, '\nWGS84 from Broadcast Ephemerides given in the ');
fprintf(resultat_fil, '\nRINEX format.');
fprintf(resultat_fil, '\n');
fprintf(resultat_fil, '\n');

fprintf(resultat_fil, '\nEpoke:');
fprintf(resultat_fil, '\ny, m, d, h, m, s');
fprintf(resultat_fil, '\n%d %d %d %d %d %d', t0e);
fprintf(resultat_fil, '\n');

fprintf(resultat_fil, '\n Satelittnummer me onsker koordinatar til:');
fprintf(resultat_fil, '\n %d', satelitt_nummer);
fprintf(resultat_fil, '\n');
fprintf(resultat_fil, '\n');

fprintf(resultat_fil, '\n Berekna ECEF-koordinat:');
fprintf(resultat_fil, '\nSatelittnummer,    X   Y   Z:');
fprintf(resultat_fil, '\n');
fprintf(resultat_fil, [repmat('%.4f\t', 1, size(ECEF_koord_liste, 2)) '\n'], ECEF_koord_liste');

% Lukkar fila:
fclose(resultat_fil);





