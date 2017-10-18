function [h,n,antall] = les_rinex_nav(filnavn)
% Leser navigasjonsmelding fra GPS kringkastet efemeride i RINEX-format.
% - header informasjon ligg i h
% - navigasjonsmelding ligg i n

%% Opnar/undersokar fil:
disp('Leser GPS navigasjonsfil i RINEX-format:');

% Opnar fil, kun lese-tilgong:
filnr = fopen(filnavn, 'r');

% Sjekkar at fila eksisterar og let seg opna:
if filnr == -1
    error(['RINEX navigasjonsfila <' filnamn '> kan ikkje opnast.']);
end


%% Les header/hode;
% Les forste linje:
linje = fgets(filnr);    

% Lokke er ei og ei linje leses inntil headeren passeres. feof blir brukt
% for a forhindre at det ikkje leses forbi slutten av fila. isempty brukes
% for a sjekke om 'END OF HEADER' finnes i linje.

while (feof(filnr) == 0) & isempty(findstr(linje,'END OF HEADER'));
    linje = fgets(filnr);
end

% Dersom 'END OF HEADER' ikkje finnes, avbrytes kallet:
if feof(filnr) == 1;
    error(['Det er inger header i Nav-fila:' filnavn]);
end

% I oppgave1-GMSG210 brukes ikkje informajson fraa header, tildelar med
% dummy-verdi.
h = 'Header inneheld ingen verdiar.';


%% Leser ei og ei navigasjonsmelding inntil slutten av fila. 
% Akkumulerar inn i ei felles matrise, n, der det er ei linje for kvar
% melding. Merk at kvar melding utgjor ei blokk i fila og at samme satelitt
% kan ha fleire medlingar, da som regel med ein times forskjellig
% refferansetidspunktet toe.

% Initialiserar ei tom matrise:
n = [];

% Tellevariabel fo antall medlinger:
antall = 0;

while (feof(filnr) == 0)
    antall = antall + 1;
    
    % Leser forste linje for navigasjonsmeldinga:
    linje = fgets(filnr);
    
    % Erstattar 'D' med 'E' ('D' er fortran syntax for eksponensiell form).
    % Indeksane i parantes angir forste:intervall:siste.
    linje(38:19:80) = 'E';
    
    % Les n_sat fra tejststrengen linje, merk transponert tegnet '
    n_sat = sscanf(linje, '%d%d%d%d%d%d%f%f%f%f')';
    
    % Lokke over dei neste 7-linjene for vedkommande medling:
    for i = 1:7
        linje = fgets(filnr);
        
        % Erstattar 'D' med 'E':
        linje(19:19:80) = 'E';
        
        % Les linjevektoren nl fra tekststrengen linje og legg til
        % navigasjonsmeldinga for vedkommande satelitt n_sat. Det blir ein
        % lang linjevektor for vedkommande melding og satelitt.
        nl = sscanf(linje,'%f%f%f%f')';
        n_sat = [n_sat nl];
        
    end
    
    % Ferdig med vedkommende satelitt om melding, legg til linja i
    % hovedmatrisa, n, for alle satelittar og meldingar.
    n = [n ; n_sat];
    
end

fclose(filnr)




