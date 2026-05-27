%% Dati relativi al soggetto 1
clear all


load('DATI_SUBJ1.mat'); %dati relativi al paziente 1
%time (tempo in secondi)
%LV:curva tempo attività della cavità nel ventricolo sx C*p(t)
%lat: curva tempo-attvità relativa ad una regione della parete laterale
%(mid lat)
%ant: curva tempo-attività relativa ad una regione della parete anteriore
%(mid sept)

%% VISUALIZZARE LE CURVE TEMPO ATTIVITà DI TUTTI I SEGMENTI
figure; plot(time,LV,'r'); 
hold on; plot(time,lat,'g'); 
hold on; plot(time,sept,'b'); legend('ventricolo sx',' parete laterale','setto');
xlabel('time [s]'); ylabel('conteggi/(s*voxel)');
%% VISUALIZZARE I DATI IN UN GRAFICO DI PATLACK
int_Cp=cumtrapz(time,LV);
Y1=lat./LV;
Y2=sept./LV;
X=int_Cp./LV;
figure; scatter(X,Y1,'b'); hold on; scatter(X,Y2,'r'); legend('parete laterale','setto');
xlabel('int Cp / Cp'); ylabel('Ct / Cp [adimensionale]');

%% OPERAZIONE DI FITTING LINEARE
A1=[Y1(20),Y1(22)];
A2=[Y2(19),Y2(22)];
B1=[X(20),X(22)];
B2=[X(19),X(22)];
coeff_1=polyfit(B1,A1,1);
coeff_2=polyfit(B2,A2,1);
x=0:1000:6000;
y1=coeff_1(1)*x+coeff_1(2);
y2=coeff_2(1)*x+coeff_2(2);
figure; scatter(X,Y1,'b'); hold on; scatter(X,Y2,'r');
hold on; plot(x,y1,'b'); hold on; plot(x,y2,'r');
xlabel('int Cp / Cp'); ylabel('Ct / Cp [adimensionale]');

%% DAI DATI PRECEDENTI VALUTARE LA VELOCITà DI UTILIZZO Ri
m_setto=coeff_1(1);
m_lat=coeff_2(1);
LC=0.67;
Cp=55.2805;

R_laterale=m_lat*(Cp/(LC));
R_setto=m_setto*(Cp/(LC)); 

%% Dati relativi al soggetto 2
clear all


load('DATI_SUBJ2.mat');
%%time (tempo in secondi)
%LV:curva tempo attività della cavità nel ventricolo sx C*p(t)
%lat: curva tempo-attvità relativa ad una regione della parete laterale
%(mid lat)
%ant: curva tempo-attività relativa ad una regione della parete anteriore
%(mid sept

%% VISUALIZZARE LE CURVE TEMPO ATTIVITà DI TUTTI I SEGMENTI
figure; plot(time,LV,'r'); 
hold on; plot(time,lat,'g'); 
hold on; plot(time,ant,'b'); legend('ventricolo sx','laterale','parete anteriore');
xlabel('time [s]'); ylabel('conteggi/(s*voxel)')

%% VISUALIZZARE I DATI IN UN GRAFICO DI PATLACK
int_Cp=cumtrapz(time,LV);
Y1=lat./LV;
Y2=ant./LV;
X=int_Cp./LV;
figure; scatter(X,Y1,'b'); hold on; scatter(X,Y2,'r'); legend('parete laterale','parete anteriore');
xlabel('int Cp / Cp'); ylabel('Ct / Cp [adimensionale]');
%% OPERAZIONE DI FITTING LINEARE
A1=[Y1(16),Y2(25)];
A2=[Y1(19),Y1(22)];
B1=[X(16),X(25)];
B2=[X(19),X(22)];
coeff_1=polyfit(B1,A1,1);
coeff_2=polyfit(B2,A2,1);
x=0:1000:6000;
y1=coeff_1(1)*x+coeff_1(2);
y2=coeff_2(1)*x+coeff_2(2);
figure; scatter(X,Y1,'b'); hold on; scatter(X,Y2,'r');
hold on; plot(x,y1,'r'); hold on; plot(x,y2,'b');
xlabel('int Cp / Cp'); ylabel('Ct / Cp [adimensionale]');
%% DAI DATI PRECEDENTI VALUTARE LA VELOCITà DI UTILIZZO Ri
m_setto=coeff_1(1);
m_lat=coeff_2(1);
LC=0.67;
Cp=55.2805;

R_laterale=m_lat*(Cp/(LC));
R_setto=m_setto*(Cp/(LC)); 







