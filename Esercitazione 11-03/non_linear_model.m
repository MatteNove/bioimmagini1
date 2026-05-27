function y = non_linear_model(x,xdata)
% modello di funzione non lineare (bi-esponenziale)
a1 = x(1);
b1 = x(2);
a2 = x(3);
b2 = x(4);

y = a1*exp(-b1*xdata) + a2*exp(-b2*xdata);