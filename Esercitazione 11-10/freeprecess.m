function [Efp,Bfp]=freeprecess(dt,T1,T2,df)


%T: durata della “free precession” in ms (tempo di ‘intervallo’ dt oppure, 
% alternativamente, tempo t, dipende da come si vuole aggiornare l’iterazione) 
%T1 e T2: tempi di rilassamento in ms 
%df: frequenza di risonanza in Hz (off-resonance frequency)
t=1/1000;
Bfp=[0;0;(1-exp(-dt/T1))];
phi=2*pi*df*t;
R=zrot(phi);
E=[exp(-dt/T2),0,0;
    0,exp(-dt/T2),0;
    0,0,exp(-dt/T1)];
Efp=E*R;
end