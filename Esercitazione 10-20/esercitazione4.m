%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%%         Esercitazione: ML-EM PET reconstruction 
%%%         Esercitazione: OS-EM PET reconstruction 
%%% 
%%%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%% Caricamento fantoccio

%disp('Caricamento fantoccio cerebrale ...');
load('brain');
% il file brain.mat contiene 
% brain: fantoccio cerebreale

phantom=double(brain); %importo il fantoccion
cmap=pmkmp(256, 'LinearL'); %costruisce una mappa di colori utilizzata della PET
figure; imagesc(phantom); colormap(cmap); title('Fantoccio');


%% Parametri

N=size(phantom,1); %una dimensione dell'immagine (111)
imgsize=[N,N]; %dimensioni dell'immagini 111X111
pixels=prod(imgsize); %sono i numeri di punti dell'immagine (12321)

N_projections=180; %numero di colonne del sinogramma (proiezioni)
N_positions=159; %numero di righe del sinogramma 
sinosize=[N_positions,N_projections]; %dimensioni del sinogramma
bins=prod(sinosize); %numero di punti del sinogramma

iter_mlem=50; %50 iterazione di MLEM
iter_osem=16;  %16 iterazioni di OSEM
nblock=25; %numero di blocchi

%% Simulazione scansione 


%disp('Creazione del sinogramma simulato ...');

% SYSTEM MATRIX
H = Calcolo_A(N_projections,N_positions,N,N); % funzione già utilizzata per 
                                              % l'esercitazione sulla ART
% forward projection
X0=reshape(phantom,pixels,1); %ottengo un vettore 1231x1
ideal_sinogram=H*X0;

figure;
imagesc(reshape(ideal_sinogram,sinosize));
colormap(cmap);  
title('Sinogramma non rumoroso')


%% Generazione artefatti

%disp('Simulazione artefatti e aggiunta rumore ...');

RF=0.2;  %random factor (accidental coincidences)
SF=0.1;  % scatter factor
AF=0.03; % attenuation factor

% ATTENUAZIONE
u=zeros(imgsize);
u(brain>0)=AF;
attenuation=exp(-H*u(:));  

% EFFETTI ADDITIVI DI BACKGROUND (RANDOM COUNTS)
M=mean(attenuation(:).*ideal_sinogram(:)); 
random=M*RF*ones(bins,1); 

% EFFETTI ADDITIVI DI BACKGROUND (SCATTERING)
xgauss=linspace(-1,1,N_positions);
scatter=(exp(-(xgauss).^2)./(2*.0208))'; 
scatter=(scatter-min(scatter))/(max(scatter)-min(scatter)); 
scatter=reshape(repmat(scatter*SF*M,1,N_projections),bins,1);

background_effects=random+scatter;
    
% AGGIUNGERE LE COMPONENTI DI DISTURBO AL SINOGRAMMA
sinogram=attenuation.*ideal_sinogram + random + scatter; 
sinogram=poissrnd(sinogram);

figure
imagesc(reshape(sinogram,sinosize));
colormap(cmap); 
title('Sinogramma rumoroso')

% MAPPA DI SENSITIVITA' 
% (cfr. primo termine a denominatore della formula ML-EM ed OS-EM)
sensitivity=H'*ones(bins,1);

%% Ricostruzione MLEM
% Implementare l'algoritmo ML-EM per la ricostruzione del sinogramma
% rumoroso generato ai punti precedenti. Valutare la qualità della
% ricostruzione a seconda che vengano corretti o meno i disturbi simulati.
% Salvare l'immagine intermedia ricostruita ad ogni iterazione in un
% vettore 3D (N,N,iter_mlem) 
time=[]; %in questo vettore vado a salvarmi i tempi di calcolo della ML-EM e della OS-EM

%disp('Ricostruzione immagine con MLEM ..');
% Per salvare le ricostruzioni intermedie
MLEM=zeros(N,N,iter_mlem); %Matrice dove vado a salvarmi i dati ottenuti ad ogni iterazione
%stima iniziale uniforme dell'immagine:
activity=ones(pixels,1); % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
vect1=ones(bins,1);
for iter = 1:iter_mlem
    proiezione=H*activity(:); %sinogramma stimato
    rapp=sinogram./proiezione; %confronto tra sinogramma misurato e 
    %sinogramma stimato mediante il rapporto
    ei=H'*rapp; %torno nel dominio dell'immagine
    sens=H'*vect1; %calcolo la matrice di senitività
    num=activity.*ei; %calcolo il numeratore che andrò a dividere per la 
    %sensitività
    activity=num./sens; %aggiorno l'immagine
    imm=reshape(activity,[N,N]); %torno nelle dimensioni dell'immagine
    for i=1:N
        for j=1:N
            MLEM(i,j,iter)=imm(i,j); %vado a salvarla al passo iter
        end
    end
end
figure; subplot(2,2,1); imagesc(MLEM(:,:,1)); title('1 iterazione'); colormap(cmap);
subplot(2,2,2); imagesc(MLEM(:,:,20)); title('20 iterazione'); colormap(cmap);
subplot(2,2,3); imagesc(MLEM(:,:,40)); title('40 iterazione'); colormap(cmap);
subplot(2,2,4); imagesc(MLEM(:,:,50)); title('50 iterazione'); colormap(cmap);
%% Sinogramma non rumoroso
MLEM = zeros(N,N,iter_mlem); %Matrice dove vado a salvarmi i dati ottenuti ad ogni iterazione
%stima iniziale uniforme dell'immagine:
activity = ones(pixels,1);  % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
vect1=ones(28620,1);
tic;
for iter = 1:iter_mlem
    proiezione=H*activity(:); %sinogramma stimato
    rapp=ideal_sinogram./proiezione; %confronto tra sinogramma misurato e 
    %sinogramma stimato mediante il rapporto
    ei=H'*rapp; %torno nel dominio dell'immagine
    sens=H'*vect1; %calcolo la matrice di senitività
    num=activity.*ei; %calcolo il numeratore che andrò a dividere per la 
    %sensitività
    activity=num./sens;  %aggiorno l'immagine
    imm=reshape(activity,[N,N]); %torno nelle dimensioni dell'immagine
    for i=1:N
        for j=1:N
            MLEM(i,j,iter)=imm(i,j); %vado a salvarla al passo iter
        end
    end
end
time(1)=toc;
figure; subplot(2,2,1); imagesc(MLEM(:,:,1)); title('1 iterazione'); colormap(cmap);
subplot(2,2,2); imagesc(MLEM(:,:,20)); title('20 iterazione'); colormap(cmap);
subplot(2,2,3); imagesc(MLEM(:,:,40)); title('40 iterazione'); colormap(cmap);
subplot(2,2,4); imagesc(MLEM(:,:,50)); title('50 iterazione'); colormap(cmap);



%% Ricostruzione OSEM - CALCOLO DEI BLOCCHI DELLA MATRICE DI SISTEMA

% Creare una funzione esterna (partire dal file Calcolo_Hblock.m fornito)
% per l'estrazione dei blocchi della matrice di sistema con cui ricostruire
% i singoli subset del sinogramma.

% La descrizione della funzione è fornita nel file dedicato, è importante
% assicurarsi che restituisca in output 'nblock' segmenti della matrice di
% sistema A e, per ciascuno di essi, tenga traccia delle proiezioni che 
% fanno parte del subset a cui è associato un determinato blocco.
blocchi=1;
struttura=Calcolo_Hblock(H,blocchi,N_positions,N_projections);

%% Ricostruzione OSEM
% Implementare l'algoritmo OS-EM per la ricostruzione del sinogramma
% rumoroso generato ai punti precedenti. Valutare la qualità della
% ricostruzione a seconda che vengano corretti o meno
OSEM1=zeros(N,N,iter_osem*blocchi); %dove vado a salvarmi le immagini parziali 
activity=ones(pixels,1); % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
count=1;
for iter=1:iter_osem 
    for iset=1:blocchi
        H_iset=struttura(iset).block; %prendo la H dell'iesimo-set                                         
        g_new=H_iset*activity; %calcolo il sinogramma stimato                                             
        for j=1:size(g_new,1) %devo andare a mettere ad 1 i valori del sinogramma misurato
            %dove i valori sono zero, questo perchè il confronto si fa
            %mediante rapporto
            if g_new(j)==0
                g_new(j)=1;
            end
        end
        inizio=struttura(iset).ind_start; %indice iniziale
        fine=struttura(iset).ind_end; %indice finale
        errore=ideal_sinogram(inizio:fine)./g_new;  %vado a fare il confronto mediante rapporto                                   
        retro_proiezione=H_iset'*errore; %torno nel dominio dell'immagine                                   
        prod_immagini=activity.*retro_proiezione; %vado ad aggiornare il numeratore                          
        sensitivity_it=H_iset'*ones(size(H_iset,1),1); %calcolo la sensitività                      
        activity=prod_immagini./sensitivity_it; %aggiorno l'immagine                           
        OSEM1(:,:,count)=reshape(activity,[111 111]); %torno nel dominio dell'immagine
        count=count+1;
    end
end
%%
blocchi=4;
struttura=Calcolo_Hblock(H,blocchi,N_positions,N_projections);
OSEM4=zeros(N,N,iter_osem*blocchi); %dove vado a salvarmi le immagini parziali 
activity=ones(pixels,1); % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
count=1;
for iter=1:iter_osem 
    for iset=1:blocchi
        H_iset=struttura(iset).block; %prendo la H dell'iesimo-set                                         
        g_new=H_iset*activity; %calcolo il sinogramma stimato                                             
        for j=1:size(g_new,1) %devo andare a mettere ad 1 i valori del sinogramma misurato
            %dove i valori sono zero, questo perchè il confronto si fa
            %mediante rapporto
            if g_new(j)==0
                g_new(j)=1;
            end
        end
        inizio=struttura(iset).ind_start; %indice iniziale
        fine=struttura(iset).ind_end; %indice finale
        errore=ideal_sinogram(inizio:fine)./g_new;  %vado a fare il confronto mediante rapporto                                   
        retro_proiezione=H_iset'*errore; %torno nel dominio dell'immagine                                   
        prod_immagini=activity.*retro_proiezione; %vado ad aggiornare il numeratore                          
        sensitivity_it=H_iset'*ones(size(H_iset,1),1); %calcolo la sensitività                      
        activity=prod_immagini./sensitivity_it; %aggiorno l'immagine                           
        OSEM4(:,:,count)=reshape(activity,[111 111]); %torno nel dominio dell'immagine
        count=count+1;
    end
end
%%
blocchi=20;
struttura=Calcolo_Hblock(H,blocchi,N_positions,N_projections);
OSEM20=zeros(N,N,iter_osem*blocchi); %dove vado a salvarmi le immagini parziali 
activity=ones(pixels,1); % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
count=1;
for iter=1:iter_osem 
    for iset=1:blocchi
        H_iset=struttura(iset).block; %prendo la H dell'iesimo-set                                         
        g_new=H_iset*activity; %calcolo il sinogramma stimato                                             
        for j=1:size(g_new,1) %devo andare a mettere ad 1 i valori del sinogramma misurato
            %dove i valori sono zero, questo perchè il confronto si fa
            %mediante rapporto
            if g_new(j)==0
                g_new(j)=1;
            end
        end
        inizio=struttura(iset).ind_start; %indice iniziale
        fine=struttura(iset).ind_end; %indice finale
        errore=ideal_sinogram(inizio:fine)./g_new;  %vado a fare il confronto mediante rapporto                                   
        retro_proiezione=H_iset'*errore; %torno nel dominio dell'immagine                                   
        prod_immagini=activity.*retro_proiezione; %vado ad aggiornare il numeratore                          
        sensitivity_it=H_iset'*ones(size(H_iset,1),1); %calcolo la sensitività                      
        activity=prod_immagini./sensitivity_it; %aggiorno l'immagine                           
        OSEM20(:,:,count)=reshape(activity,[111 111]); %torno nel dominio dell'immagine
        count=count+1;
    end
end
%%
blocchi=30;
struttura=Calcolo_Hblock(H,blocchi,N_positions,N_projections);
OSEM30=zeros(N,N,iter_osem*blocchi); %dove vado a salvarmi le immagini parziali 
activity=ones(pixels,1); % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
count=1;
for iter=1:iter_osem 
    for iset=1:blocchi
        H_iset=struttura(iset).block; %prendo la H dell'iesimo-set                                         
        g_new=H_iset*activity; %calcolo il sinogramma stimato                                             
        for j=1:size(g_new,1) %devo andare a mettere ad 1 i valori del sinogramma misurato
            %dove i valori sono zero, questo perchè il confronto si fa
            %mediante rapporto
            if g_new(j)==0
                g_new(j)=1;
            end
        end
        inizio=struttura(iset).ind_start; %indice iniziale
        fine=struttura(iset).ind_end; %indice finale
        errore=ideal_sinogram(inizio:fine)./g_new;  %vado a fare il confronto mediante rapporto                                   
        retro_proiezione=H_iset'*errore; %torno nel dominio dell'immagine                                   
        prod_immagini=activity.*retro_proiezione; %vado ad aggiornare il numeratore                          
        sensitivity_it=H_iset'*ones(size(H_iset,1),1); %calcolo la sensitività                      
        activity=prod_immagini./sensitivity_it; %aggiorno l'immagine                           
        OSEM30(:,:,count)=reshape(activity,[111 111]); %torno nel dominio dell'immagine
        count=count+1;
    end
end

%% vado a graficare
subplot(4,4,1); imagesc(OSEM1(:,:,1)); title('iter:1 subset:1'); colormap(cmap);
subplot(4,4,5); imagesc(OSEM1(:,:,4)); title('iter:4 subset:1'); colormap(cmap);
subplot(4,4,9); imagesc(OSEM1(:,:,8)); title('iter:8 subset:1'); colormap(cmap);
subplot(4,4,13); imagesc(OSEM1(:,:,16)); title('iter:16 subset:1'); colormap(cmap);
subplot(4,4,2); imagesc(OSEM4(:,:,4)); title('iter:1 subset:4'); colormap(cmap);
subplot(4,4,6); imagesc(OSEM4(:,:,16)); title('iter:4 subset:4'); colormap(cmap);
subplot(4,4,10); imagesc(OSEM4(:,:,32)); title('iter:8 subset:4'); colormap(cmap);
subplot(4,4,14); imagesc(OSEM4(:,:,64)); title('iter:16 subset:4'); colormap(cmap);
subplot(4,4,3); imagesc(OSEM20(:,:,20)); title('iter:1 subset:20'); colormap(cmap);
subplot(4,4,7); imagesc(OSEM20(:,:,80)); title('iter:4 subset:20'); colormap(cmap);
subplot(4,4,11); imagesc(OSEM20(:,:,160)); title('iter:8 subset:20'); colormap(cmap);
subplot(4,4,15); imagesc(OSEM20(:,:,320)); title('iter:16 subset:20'); colormap(cmap);
subplot(4,4,4); imagesc(OSEM30(:,:,30)); title('iter:1 subset:30'); colormap(cmap);
subplot(4,4,8); imagesc(OSEM30(:,:,120)); title('iter:4 subset:30'); colormap(cmap);
subplot(4,4,12); imagesc(OSEM30(:,:,240)); title('iter:8 subset:30'); colormap(cmap);
subplot(4,4,16); imagesc(OSEM30(:,:,480)); title('iter:16 subset:30'); colormap(cmap);

%% Vado a valutare il tempo
iter_mlem=360;
MLEM = zeros(N,N,iter_mlem); %Matrice dove vado a salvarmi i dati ottenuti ad ogni iterazione
%stima iniziale uniforme dell'immagine:
activity = ones(pixels,1);  % inizializzo l'immagine come tutti 1. NB l'immagine 
%è vettorizzata.
vect1=ones(28620,1);
tic;
for iter = 1:iter_mlem
    proiezione=H*activity(:); %sinogramma stimato
    rapp=sinogram./proiezione; %confronto tra sinogramma misurato e 
    %sinogramma stimato mediante il rapporto
    ei=H'*rapp; %torno nel dominio dell'immagine
    sens=H'*vect1; %calcolo la matrice di senitività
    num=activity.*ei; %calcolo il numeratore che andrò a dividere per la 
    %sensitività
    activity=num./sens;  %aggiorno l'immagine
    imm=reshape(activity,[N,N]); %torno nelle dimensioni dell'immagine
    for i=1:N
        for j=1:N
            MLEM(i,j,iter)=imm(i,j); %vado a salvarla al passo iter
        end
    end
end
time(1)=toc;
iter_osem=40;
blocchi=9;
struttura=Calcolo_Hblock(H,blocchi,N_positions,N_projections);
OSEM = zeros(N,N,iter_osem*blocchi);
activity = ones(pixels,1);                                                  
count=1;
tic
for iter = 1:iter_osem
    for iset=1:blocchi
        H_iset=struttura(iset).block;                                          
        g_new=H_iset*activity;                                              
        for j=1:size(g_new,1)
            if g_new(j)==0
                g_new(j)=1;
            end
        end
        inizio=struttura(iset).ind_start;
        fine=struttura(iset).ind_end;
        errore=ideal_sinogram(inizio:fine)./g_new;                                    
        retro_proiezione=H_iset'*errore;                                    
        prod_immagini=activity.*retro_proiezione;                           
        sensitivity_it=H_iset'*ones(size(H_iset,1),1);                      
        activity=prod_immagini./sensitivity_it;                             
        OSEM(:,:,count)=reshape(activity,[111 111]);
        count=count+1;
    end
end
time(2)=toc; 
time_=[0,0,0,time(1),0,0,0,time(2),0,0,0];
figure; stem(time_); title('ML-EM vs OS-EM');


    







