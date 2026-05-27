function Ct = modello_exp(k, time)
% Questa funzione deve prendere in ingresso le 4 costanti del modello 
% compartimentale e il vettore dei tempi,  
% e svolge al suo interno la conversione nel set di variabili ausiliarie 
% per poi calcolare C_t(t) - vedi diapositive 3 e 20. 

K1=k(1);
K2=k(2);
K3=k(3);
K4=k(4);

t=time;

c=sqrt((K2+K3+K4)^2)-4*K2*K4;
beta1=((K2+K3+K4)-c)/2;
beta2=((K2+K3+K4)+c)/2;
a1=K1*(K3+K4-beta1)/(beta2-beta1);
a2=K1*(beta2-K3-K4)/(beta2-beta1);


Ct=a1*exp(-beta1*t)+a2*exp(-beta2*t);
end
















