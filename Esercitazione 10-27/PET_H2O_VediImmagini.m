
%%
% visualizzazione immaigni  di dati PET [15O]H2O  (per analisi di flusso)
%%
clear all
close all
clc

% Fetta n. 15 per 20 time-steps
NomeFile = 'H2O_Slice15_time';
time = zeros(1,20); %vettore tempo
figure;
for nImm = 0:19
    IMM = double(dicomread([NomeFile num2str(nImm) '.dcm']));
    INF = dicominfo([NomeFile num2str(nImm) '.dcm']);
    
    time(nImm+1) = (INF.ActualFrameDuration/1000);  %durata di acquisizione delle coincidenze per ottenere l'immagine i-sima
    disp(['imm N. ' num2str(nImm),'durata acq: ',num2str(time(nImm+1)), 'sec.']);
    %% rescaling dei dati (per avere valori in Bq/ml)
    IMM=(IMM*INF.RescaleSlope + INF.RescaleIntercept);  
    %%% %N.B. senza il rescaling, i valori vanno da 0 a 32767: non sono
    %%% quindi valori assoluti di Bq/ml!!!
    imagesc(IMM),title(['Imm n. ',num2str(nImm)]),colorbar,colormap gray, axis off
    pause(0.3);
   
end
time = cumsum(time);  %% N.B.: ho così generato l'asse dei tempi per le curve TAC