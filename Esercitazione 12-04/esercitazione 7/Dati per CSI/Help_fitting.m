% FID model definition:

% Definizione di DUE modelli: uno per la parte reale del FID, ed uno per la
% parte immaginaria.
modelFunR =  @(p,t) p(1)*exp(-p(2)*t).*cos(2*pi*p(3)*t) + p(4)...
    *exp(-p(5)*t).*cos(2*pi*p(6)*t);

modelFunI =  @(p,t) p(1)*exp(-p(2)*t).*sin(2*pi*p(3)*t) + p(4)...
    *exp(-p(5)*t).*sin(2*pi*p(6)*t);


% definizione vettori dei valori di partenza (startingvalues), dei minimi 
% (lb) e dei massimi (ub) - uguali per entrambi i modelli
startingVals = [1e6,30,408,1e6,30,436]; % a1,d1,f1,a2,d2,f2
lb = [0,10,400,0,10,420];
ub = [1e8,80,415,1e8,80,452];

% definizione opzioni
options = statset('TolFun', 1e-8,'MaxIter',1e6,'TolX',10,'MaxFunEvals',1e6');
options.Algorithm = 'levenberg-marquardt';

% Stima dei parametri dei modelli
[coefEstsR,resnorm1R] = ...
                    lsqcurvefit(modelFunR,startingVals,tsec,real(mean_sig_metab),lb,ub,options);

[coefEstsI,resnorm1I] = ...
                    lsqcurvefit(modelFunI,startingVals,tsec,imag(mean_sig_metab),lb,ub,options);

% generazione curve dai modelli
fitFID_R = modelFunR(coefEstsR,tsec);
fitFID_I = modelFunI(coefEstsI,tsec);
fitFID = fitFID_R +1j*fitFID_I;
