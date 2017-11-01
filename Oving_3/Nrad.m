function [N] = Nrad(a,b,lat)

    e2=(a^2 - b^2)/(a^2);
    N=a/((1 - e2*((sin(lat))^2))^(1/2));