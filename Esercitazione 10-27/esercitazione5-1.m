%%
% visualizzazione immaigni  di dati PET [15O]H2O  (per analisi di flusso)
clear all
close all
clc
N=19; %numero di immagini
% Fetta n. 15 per 20 time-steps
NomeFile='H2O_Slice15_time';
time=zeros(1,20); %vettore tempo
figure;
for nImm=0:N
    IMM=double(dicomread([NomeFile num2str(nImm) '.dcm']));
    INF=dicominfo([NomeFile num2str(nImm) '.dcm']);
    time(nImm+1)=(INF.ActualFrameDuration/1000);  %durata di acquisizione delle coincidenze per ottenere l'immagine i-sima
    disp(['imm N. ' num2str(nImm),'durata acq: ',num2str(time(nImm+1)), 'sec.']);
    % rescaling dei dati (per avere valori in Bq/ml)
    IMM=(IMM*INF.RescaleSlope+INF.RescaleIntercept);  
    %%% %N.B. senza il rescaling, i valori vanno da 0 a 32767: non sono
    %%% quindi valori assoluti di Bq/ml!!!
    imagesc(IMM),title(['Imm n. ',num2str(nImm)]),colorbar,colormap gray, axis off
    pause(0.3);
end
time = cumsum(time);  %% N.B.: ho così generato l'asse dei tempi per le curve TAC
%% SELEZIONE DELLE ROI
% SELEZIONO LE ROI
for i = 0:19
    IMM = double(dicomread([NomeFile num2str(i) '.dcm']));
    INF = dicominfo([NomeFile num2str(i) '.dcm']);
    if i==1
        figure; imagesc(IMM); title('ROI VASO')
        contour=drawfreehand('color','r'); 
        ROI_vaso=double(contour.createMask()); %ROI relativa ad un immagine comn time basso,
        %quindi una ROI del vaso
    end
    if i==19
        figure; imagesc(IMM); title('ROI TESSUTO');
        contour=drawfreehand('color','r');
        ROI_tessuto=double(contour.createMask()); %ROI relativa ad un immagine comn time alto
        %quindi una Roi tessuto
    end
end
%%
%%CREAZIONE IMMAGINI
IMMAGINI=[]; %mi vado a creare una matrice immagine 
for j=1:20
    IMMAGINI(j).imm= double(dicomread([NomeFile num2str(j-1) '.dcm']));
    IMMAGINI(j).info = dicominfo([NomeFile num2str(j-1) '.dcm']);
    IMMAGINI(j).rescale=(IMMAGINI(j).imm*IMMAGINI(j).info.RescaleSlope + IMMAGINI(j).info.RescaleIntercept); 
end
%%
figure;
for i=1:20
    imagesc(IMMAGINI(i).rescale); colormap('gray'); colorbar; pause(0.2);
end

%% Curve Tempo-Attività
%CURVE TEMPO ATTIVITà
Ca_t=zeros(length(time),1); %vettore tempi Concentrazione arteria
Ct_t=zeros(length(time),1); %vettori tempi concentrazione tessuto
for i=1:length(time)
    maschera_vaso=IMMAGINI(i).rescale.*ROI_vaso;
    %%imagesc(maschera_vaso); colorbar; pause(0.5); 
    maschera_tessuto=IMMAGINI(i).rescale.*ROI_tessuto;
    Ca_t(i)=mean((nonzeros(maschera_vaso)));
    Ct_t(i)=mean((nonzeros(maschera_tessuto)));
end
figure; plot(time,Ca_t,'r'); hold on; plot(time,Ct_t,'b'); legend('C vaso', 'C tessuto'); 
xlabel('time'); ylabel('Bq/ml')
%% Modello Grafico
%visualizzare i dati mediante il modello grafico con un compartimento tissutale, secondo la formula vista a
%lezione.
int_Ca_t=zeros(length(time),1);
int_Ct_t=zeros(length(time),1);
int_Ca_t=cumtrapz(time,Ca_t);
int_Ct_t=cumtrapz(time,Ct_t);
Y=Ct_t./int_Ca_t; %proietto sul piano X-Y
X=int_Ct_t./int_Ca_t; %proietto sul piano X-Y
figure; scatter(X,Y); xlabel('int Ct / int Ca'); ylabel('Ct / int Ca [1/sec]');
%% Fitting lineare
%al grafico costruito, nei punti più “lineari”, eseguire un’operazione di fitting lineare (usare la funzione Matlab:
%p = polyfit(x,y,n) con n=1), per poi calcolarne il coefficiente angolare m e l%intercetta s.
A_=[Y(9),Y(18)]; %vado a prendere i punti più lineari
B_=[X(9),X(18)]; %vado a prendere i punti più lineari
coeff=polyfit(B_,A_,1);
x=0:0.1:0.7;
y=coeff(1)*x+coeff(2);
K1=coeff(2); %K1 è il valore di flusso del tracciante dal vaso al tessuto
K2=coeff(1);
figure; scatter(X,Y); hold on; plot(x,y); xlabel('int Ct / int Ca'); ylabel('Ct / int Ca [1/sec]');


    
    
    
    


