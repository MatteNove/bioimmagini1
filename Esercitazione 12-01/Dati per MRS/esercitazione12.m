%%
load("1H_MRS soleo_NL.mat");
load("1H_MRS soleo_OB.mat");
N=2048;
n=18;
deltaF=5000;
angle=360;
delta_t=1/deltaF;
t=0:delta_t:2048*delta_t-delta_t;
f=-deltaF/2:deltaF/2048:deltaF/2-deltaF/2048;
conv=60.71;
ppm_acqua=4.8;
fppm=(f./conv)+ppm_acqua;
figure; 
imag_1=imag(sig_nl(:,10));
imag_2=imag(sig_obese(:,10));
subplot(2,1,1); plot(t,real(sig_nl(:,10)),'b'); hold on; plot(t,imag_1,'r');
title('FID PAZIENTE SANO n10'); legend('Parte Reale', 'Parte Immaginaria');
subplot(2,1,2); plot(t,real(sig_obese(:,10)),'b'); hold on; plot(t,imag_2,'r');
title('FID PAZIENTE OBESO n10'); legend('Parte Reale', 'Parte Immaginaria');
%%
FT_sig_nl=zeros(N,n); %faccio la trasformata di Fourier del FID nel paziente sano per 
%ottenere lo spettro
FT_sig_obese=zeros(N,n);%faccio la trasformata di Fourier del FID nel paziente obeso per 
%ottenere lo spettro
for i=1:n
    FT_sig_nl(:,i)=fftshift(fft(sig_nl(:,i)));
    FT_sig_obese(:,i)=fftshift(fft(sig_obese(:,i)));
end
real_FT_sig_nl=zeros(N,n);% vado a riempire la matrice con la formula del PROF
real_Ft_sig_obese=zeros(N,n);% vado a riempire la matrice con la formula del PROF
max_sig_nl=zeros(1,angle); %qui andrò ad inserire i massimi ad ogni angolo
max_sig_obese=zeros(1,angle);%qui andrò ad inserire i massimi ad ogni angolo
PHI_0=((1:1:360)*pi)/180;

for i=1:length(PHI_0);
    for k=1:N
        for m=1:n
            real_FT_sig_nl(k,m)=real(FT_sig_nl(k,m).*(cos(PHI_0(i))+j*sin(PHI_0(i))));
            real_Ft_sig_obese(k,m)=real(FT_sig_obese(k,m).*(cos(PHI_0(i))+j*sin(PHI_0(i))));
        end
    end
    max_sig_nl(1,i)=max(max(real_FT_sig_nl)); %metto il massimo del paziente sano
    max_sig_obese(1,i)=max(max(real_Ft_sig_obese));%metto il massimo del paziente obeso
end

max_real_FT_sig_nl=max(max_sig_nl); %cerco il massimo tra tutti
max_real_FT_sig_obese=max(max_sig_obese); %cerco il massimo tra tutti
I1=find(max_sig_nl==max_real_FT_sig_nl); %mi restituisce l'indice dove è vera la condizione
I2=find(max_sig_obese==max_real_FT_sig_obese); %mi restituisce l'indice dove è vera la condizione
PHI_0_CORR_nl=PHI_0(I1); 
PHI_0_CORR_obese=PHI_0(I2);

FT_sig_nl_corretto=(FT_sig_nl.*exp(j*PHI_0_CORR_nl));
FT_sig_obese_corretto=(FT_sig_obese.*exp(j*PHI_0_CORR_obese));

%%
figure;
subplot(2,2,1); plot(f,real(FT_sig_nl(:,10))); title('Water Suppressed-Real Part-No Phase correction'); xlabel('f[Hz]');
subplot(2,2,2); plot(f,imag(FT_sig_nl(:,10))); title('Water Suppressed-Imag Part-No Phase correction'); xlabel('f[Hz]');
subplot(2,2,3); plot(f,real(FT_sig_nl_corretto(:,10))); title('Water Suppressed-Real Part-Phase correction'); xlabel('f[Hz]');
subplot(2,2,4); plot(f,imag(FT_sig_nl_corretto(:,10))); title('Water Suppressed-Imag Part-Phase correction'); xlabel('f[Hz]');

figure;
subplot(2,2,1); plot(f,real(FT_sig_nl(:,1))); title('Water Unsuppressed-Real Part-No Phase correction'); xlabel('f[Hz]');
subplot(2,2,2); plot(f,imag(FT_sig_nl(:,1))); title('Water Unsuppressed-Imag Part-No Phase correction'); xlabel('f[Hz]');
subplot(2,2,3); plot(f,real(FT_sig_nl_corretto(:,1))); title('Water Unsuppressed-Real Part-Phase correction'); xlabel('f[Hz]');
subplot(2,2,4); plot(f,imag(FT_sig_nl_corretto(:,1))); title('Water Unsuppressed-Imag Part-Phase correction'); xlabel('f[Hz]');

%%
media_sig_nl_WS=zeros(N,1);
media_sig_nl_WU=zeros(N,1);
media_sig_obese_WS=zeros(N,1);
media_sig_obese_WU=zeros(N,1);
for i=1:N
    media_sig_nl_WS(i)=mean(FT_sig_nl_corretto(i,3:18));
    media_sig_nl_WU(i)=mean(FT_sig_nl_corretto(i,1:2));
    media_sig_obese_WS(i)=mean(FT_sig_obese_corretto(i,3:18));
    media_sig_obese_WU(i)=mean(FT_sig_obese_corretto(i,1:2));
end
figure;subplot(2,1,1);plot(f,real(media_sig_nl_WS)); xlabel('f[Hz]'); title('Media Water Supressed');
subplot(2,1,2); plot(fppm,real(media_sig_nl_WS)); set(gca,'xdir','reverse'); xlabel('ppm'); title('Media Water Supressed'); 

%% A.3
%Stimare, utilizzando il modello visto a lezione, i parametri sui dati sperimentali ottenuti dal
%FID mediato del punto precedente e corretto in fase (NB. Qui si tratta del FID mediato).
% - Farlo sui dati contenuti nel file 1H_MRS_soleo_NL.mat 
% - Farlo sui dati contenuti nel file 1H_MRS_soleo_OB.mat 
S1=sig_nl;
S2=sig_obese;
mean_sig_t1=zeros(1,N); %sano
mean_sig_t2=zeros(1,N); %obeso
S1=S1';
S2=S2';
mean_sig_t1=mean(S1(3:end,:));
mean_sig_t2=mean(S2(3:end,:));
%% Fit sul soggetto Sano

mean_FT_t1=fftshift(fft(mean_sig_t1));
mean_FT_t2=fftshift(fft(mean_sig_t2));
realfft1=zeros(N,1);
realfft2=zeros(N,1);
 
max_sig11=zeros(1,length(PHI_0));
max_sig22=zeros(1,length(PHI_0));
 
for i=1:length(PHI_0)
    for k=1:2048
            realfft1(k,1)=real(mean_FT_t1(1,k).*(cos(PHI_0(i))+1i*sin(PHI_0(i))));
            realfft2(k,1)=real(mean_FT_t2(1,k).*(cos(PHI_0(i))+1i*sin(PHI_0(i))));         
    end
    max_sig11(1,i)=max(max(realfft1));
    max_sig22(1,i)=max(max(realfft2));
end
max_real_FT_sig1=max(max_sig11);
max_real_FT_sig2=max(max_sig22);
I1=find(max_sig11==max_real_FT_sig1);
I2=find(max_sig22==max_real_FT_sig2);
PHI_0_CORR1=PHI_0(I1);
PHI_0_CORR2=PHI_0(I2);
 
corr_FT_sig1=zeros(N,1);
corr_FT_sig2=zeros(N,1);
 
for k=1:2048
        corr_FT_sig1(k,1)=mean_sig_t1(1,k)*(cos(PHI_0_CORR1)+1i*sin(PHI_0_CORR1));
        corr_FT_sig2(k,1)=mean_sig_t2(1,k)*(cos(PHI_0_CORR2)+1i*sin(PHI_0_CORR2));        
end
 
 
% FID model definition:
 
% Definizione di DUE modelli: uno per la parte reale del FID, ed uno per la
% parte immaginaria.
modelFunR =  @(p,time) p(1)*exp(-p(2)*time).*cos(2*pi*p(3)*time) + p(4)...
    *exp(-p(5)*time).*cos(2*pi*p(6)*time);
 
modelFunI =  @(p,time) p(1)*exp(-p(2)*time).*sin(2*pi*p(3)*time) + p(4)...
    *exp(-p(5)*time).*sin(2*pi*p(6)*time);
 
 
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
                    lsqcurvefit(modelFunR,startingVals,t,real(corr_FT_sig1'),lb,ub,options);
 
[coefEstsI,resnorm1I] = ...
                    lsqcurvefit(modelFunI,startingVals,t,imag(corr_FT_sig1'),lb,ub,options);
 
% generazione curve dai modelli
fitFID_R = modelFunR(coefEstsR,t);
fitFID_I = modelFunI(coefEstsI,t);
fitFID = fitFID_R +1i*fitFID_I;
%fitFID_R1=fftshift(fft(fitFID_R));
%fitFID_I1=fftshift(fft(fitFID_I));
fitFID1=fftshift(fft(fitFID));
 
figure, plot(f, real(fitFID1)), hold on, plot(f, real(media_sig_nl_WS)); legend('fit','segnale reale'); title('Fit Soggetto Sano-Real Part');
figure, plot(f, imag(fitFID1) ), hold on, plot(f, imag(media_sig_nl_WS)); legend('fit','segnale immaginario'); title('Fit Soggetto Sano-Imag Part');
 
%% Fit sul soggetto obeso
startingVals = [1e6,30,408,1e6,30,436]; % a1,d1,f1,a2,d2,f2
lb = [0,10,400,0,10,420];
ub = [1e8,80,415,1e8,80,452];
 
% definizione opzioni
options = statset('TolFun', 1e-8,'MaxIter',1e6,'TolX',10,'MaxFunEvals',1e6');
options.Algorithm = 'levenberg-marquardt';
 
% Stima dei parametri dei modelli
[coefEstsR,resnorm1R] = ...
                    lsqcurvefit(modelFunR,startingVals,t,real(corr_FT_sig2'),lb,ub,options);
 
[coefEstsI,resnorm1I] = ...
                    lsqcurvefit(modelFunI,startingVals,t,imag(corr_FT_sig2'),lb,ub,options);
 
% generazione curve dai modelli
fitFID_R = modelFunR(coefEstsR,t);
fitFID_I = modelFunI(coefEstsI,t);
fitFID = fitFID_R +1i*fitFID_I;
%fitFID_R1=fftshift(fft(fitFID_R));
%fitFID_I1=fftshift(fft(fitFID_I));
fitFID1=fftshift(fft(fitFID));
 
figure, plot(f, real(fitFID1)), hold on, plot(f, real(media_sig_obese_WS)); legend('fit','segnale reale'); title('Fit Soggetto Obeso-Real Part');
figure, plot(f, imag(fitFID1) ), hold on, plot(f, imag(media_sig_obese_WS)); legend('fit','segnale immaginario'); title('Fit Soggetto Obeso-Imag Part');