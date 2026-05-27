%% 
%clear all;
%close all;
%%Far girare il file BRAINeVediImmagini.m
%%
load("AIF.mat"); %curva tempo intensità arteria
%% Accedere ai diversi campi dell'header del files DICOM
Nome_sequenza_acquisizione=INF.ScanningSequence;
TE=INF.EchoTime;
TR=INF.RepetitionTime;
FA=INF.FlipAngle;
%%
NomeFile = 'bp_Slice9_Time';
for nImm = 1:39
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    time = INF.TriggerTime;
    imagesc(IMM),colormap gray, title(['imm N. ', num2str(nImm),' time: ', num2str(time),' ms' ]), axis off
    %pause(.5);
end
%% Costruire il vettore  deintempi
vettore_tempi_acquisizione=zeros(39,1);
trigger_time=zeros(39,1);
for nImm = 1:39
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    %a = (INF.AcquisitionTime);
    b= INF.TriggerTime;
    %vettore_tempi_acquisizione(nImm)=str2num(a);
    trigger_time(nImm)=b;
end
t0=trigger_time(1);
time=trigger_time-t0;
time=time./1000;
%% Curva tempo intensità relativa ad una ROI di 9 voxel
Maschera=zeros(length(IMM));
for i=1:128
    for j=1:128
        if (i>=50 && i<=52) && (j>=80 && j<=82); %punti attorno a (51,81);
            Maschera(i,j)=1;
        end
    end
end
Matrice_immagini=zeros(128,128,39);
for nImm=1:39
    IMM = dicomread([NomeFile num2str(nImm)]);
    INF = dicominfo([NomeFile num2str(nImm)]);
    Matrice_immagini(:,:,nImm)=IMM;
end
%%
Vettore_medie=zeros(39,1);
for i=1:39
    Imm=Matrice_immagini(:,:,i);
    ROI=Imm.*Maschera;
    Vettore_medie(i)=mean(nonzeros(ROI));
end
S_t=Vettore_medie;
S_A=C_A;
figure; plot(time,Vettore_medie,'r'); hold on; plot(time,C_A,'b'); grid on; legend('St','Sa');
xlabel('time [s]'); ylabel('Segnale [a.u]'); 
%%
C_t=zeros(39,1);
C_a=zeros(39,1);
for i=1:39
    C_t(i)=(-1/TE)*log(S_t(i)/S_t(1))*1000
    C_a(i)=(-1/TE)*log(S_A(i)/S_A(1))*1000
end
figure; plot(time,C_t,'r'); hold on; plot(time,C_a,'b'); grid on; legend('Ct','Ca');
xlabel('time [s]'); ylabel('Concentrazione [a.u]'); 
%%
CA=fft(C_a);
CT=fft(C_t);
DECONV=(CT./CA);
delta=ifft(DECONV)*time(39); %risposta impulsiva
figure; plot(time,delta);
f=fit(time,delta,'exp2');
a=f.a;
b=f.b;
c=f.c;
d=f.d;
fitt=zeros(length(delta));
for i=1:length(delta)
    fitt(i)=a*exp(b*time(i))+c*exp(d*time(i));
end
figure; plot(time,delta); hold on; plot(time,fitt); grid on; legend('r','fit');
xlabel('time [s]'); ylabel('flusso*R(t) [a.u]'); 
%%
%lambda=trapz(time,C_t)/trapz(time,C_a);
%MTT=trapz(time,delta);
%figure; plot(time,C_t,'r'); hold on; plot(time,C_a,'b');
A=[C_a(11),C_a(12)];
B=[time(11),time(12)];
coeff=polyfit(B,A,1);
CBF=coeff(1);
CBV=trapz(C_t)/trapz(C_a);
MTT=CBV/CBF;


