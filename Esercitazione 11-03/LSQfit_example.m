%% Esempio di fitting non lineare in MATLAB
% Utilizzo della funzione lsqcurvefit per il fitting di modelli non lineari
% a dati misurati

clear
close all
clc

t = linspace(0,2,50); 
p = [ 3   10.5    8    1.4];
y_true = non_linear_model(p,t);
rng(1);
ydata = y_true + 0.3*randn(size(y_true));

figure,
plot(t,y_true,'r-',t,ydata,'b*')
legend('curva simulata','misura')
%%

x0 = [1 1 1 0];

% We run the solver and plot the resulting fit.
[p_est,resnorm,~,exitflag,output] = lsqcurvefit(@non_linear_model,x0,t,ydata)
y_fit = non_linear_model(p_est,t);

hold on
plot(t,y_fit,'-k')
legend('curva simulata','misura','curva stimata')
hold off

%%
% aggiunta di opzioni
options	= optimset('Display', 'none');
options.TolFun 	= 1e-6;
options.TolX 	= 1e-6;
options.MaxFunEvals	= 1e6;
options.MaxIter	= 1e6;
lb    	= [0.  5.  5.   0.];
ub    	= [5.  15.  10.   3.]; 


figure,
plot(t,y_true,'r-',t,ydata,'b*')
legend('curva simulata','misura')


x0 = [1 1 1 0];
fun = @(x,xdata)non_linear_model(x,xdata);

[p1_est,resnorm1,~,exitflag,output] = ...
                    lsqcurvefit(fun,x0,t,ydata,lb,ub,options);
y_fit = non_linear_model(p1_est,t);

hold on
plot(t,y_fit,'-k')
legend('curva simulata','misura','curva stimata')
hold off

disp(['Valori dei parametri: ',num2str(p)]);
disp(' PRIMO FITTING: ');
disp(['  Parametri: ',num2str(p_est),'    ResNorm: ',num2str(resnorm)]);

disp(' SECONDO FITTING: ');
disp(['  Parametri: ',num2str(p1_est),'    ResNorm: ',num2str(resnorm1)]);