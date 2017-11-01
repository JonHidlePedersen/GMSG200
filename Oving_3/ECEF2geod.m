function [lat,lon,h] = ECEF2geod(a,b,X,Y,Z)

    e2 = (a^2 - b^2)/a^2;
    ro = sqrt(X^2 + Y^2); %hjelpevariabel

    lat1 = 0;
    lat2 = atan(Z/ro); 
    while abs(lat1 - lat2) > eps
        lat1 = lat2;
        lat2 = atan(Z/ro + Nrad(a,b,lat1)*e2*sin(lat1)/ro);
    end
    lat = lat1;

    lon = atan(Y/X);

    %For h se radiopositioning, ca s 56
    h = ro*cos(lat) + Z*sin(lat) - Nrad(a,b,lat)*(1 - e2*sin(lat)^2);