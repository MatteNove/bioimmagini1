clear all
close all

h=4.14*10^(-15);        %costante di Planck
k=8.6173*10^(-5);       %costante di boltzman
c=2.998*10^(8);         %velocità della luce
%%
%valutare il rapporto tra emissione spontanea ed emissione stimolata, nella banda delle onde EM
%con lunghezza d%onda 300E-9<= l <= .5 metri (cioè tra le onde radio e l’ultravioletto), per una
%temperatura T di 20°C.
T0=20+273.15; %temperatura iniziale di lavoro in Kelvin.
lambda=300*10^(-9):10^(-7):0.5; %creo il vettore della lunghezza d'onda.
v=c./lambda;  %mi ricavo il vettore della frequenza grazie alla funzione lambda*v=c.
Y=exp(h*v./(k*T0))-1; %ricavo il rapporto tra emissione spontanea e emissione stimolata.
Y_log=log10(Y); %faccio il logaritmo tra emissione spontanea e emissione stimolata.
figure; semilogx(lambda, Y_log); grid on;%faccio il grafico, entrambe saranno su assi logaritmici.
set(gca,'xdir','reverse'); %metto dal più grande al più piccolo.
xlabel('lambda[m] (log axis)', FontSize=15);
ylabel('log(A/(B*rho))', FontSize=15);
title('Emissione spontanea/Emissione stimolata');

%%
%mostrare il grafico risultante con assi logaritmici, rilevando per quale valore di lambda, 
% cioè l0 (e quindi
%della frequenza n , cioè n0) le due emissioni si equivalgono (cioè log(spont/stim) =0)
modulo_Y_log=abs(Y_log);%prendo il valore assoluto del logaritmo del rapporto tra emissione spontanea e emissione stimolata
min_Y_log=min(modulo_Y_log); %vado a prendermi il minimo, cioè quello che si avvicina più allo zero 
v0=(k*T0*log(1+exp(min_Y_log)))/h; %formula presente sugli appunti, mi ricavo la frequenza dove si annulla
lamda0=c/v0; %mi trovo la lunghezza d'onda dove si annulla 
%%
% valutare come varia il valore di l0 e/o n0 al variare della temperatura, per 15°C <= T <=40°C.
T=15+273.15:0.5:40+273.15; %faccio la stessa cosa fatta prima ma a temperature differenti
lambda_1=zeros(1,length(T)); %mi creo il vettore dove vado a inserire le lunghezze d'onda
v_1=zeros(1,length(T)); %mi creo il vettore dove vado a inserire le  frequenze
for n=1:length(T)
   Y=exp(h*v./(k*T(n)))-1;   
   Y_log=log10(Y);
   modulo_Y_log=abs(Y_log);
   min_Y_log=min(modulo_Y_log);
   v_1(n)=(k*T(n)*log(1+exp(min_Y_log)))/h;
   lambda_1(n)=c/v_1(n);
end
T1=15:0.5:40; %riporto la temperatura in gradi 
figure; plot(T1,lambda_1); grid on;%grafico la lunghezza d'onda in funzione della temperatura
xlabel('Temperature [C°]', FontSize=15);
ylabel('lunghezza d onda', FontSize=15);
title('lambda for A/(B*rho)=1 vs T');
figure; plot(T1,v_1); grid on; %grafico la frequenza in funzione della temperatura
xlabel('Temperature [C°]', FontSize=15);
ylabel('frequency [Hz]', FontSize=15);
title('frequency for A/(B*rho)=1 vs T');
        











