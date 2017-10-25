function [ week,tow ] = date2gpstime( year,month,day,hour,min,sec )
% Regner ut GPS-uke nr.(integer) og "time-of-week" fra year,month,day,hour
% min,sec
%   Origo for GPS-tid er 06.01.1980 00:00:00 UTC
% 26.10.2012  : Laget funsksjonen  (OO)
%

% Merknad: denne rutinen gjor bruk av Matlab datenum-funksjonen
t0=datenum(1980,0,6);
t1=datenum(year,month,day);
week_flt = (t1-t0)/7;
week = fix(week_flt);
tow_0 = (week_flt-week)*604800;
tow = tow_0 + hour*3600 + min*60 + sec;

end

