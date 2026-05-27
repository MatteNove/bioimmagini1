%Dati:
%1. Fantocci 1, 2, 3 e 4 dell%esercitazione del 06/10/2023 (1: fantoccio con singolo punto; 2: fantoccio
%implementato in Matlab 128x128 punti; 3: fantoccio implementato in Matlab 32x32 punti; 4: fantoccio
%circolare con rumore.
%2. Sinogrammi dei fantocci del punto precedente (calcolati nell%esercitazione precedente)
%- Funzione %R0 = FiltroConico(nx,ny)‘ per la costruzione di un filtro conico (File: “FiltroConico.m”)
%- Funzione %A = Calcolo_A(na,nb,nx,ny)‘ per la generazione della matrice di sistema
%(file:"Calcolo_A.m”)
%Fare girare l'esercitazione precedente!!!
%Svolgere:
%% A
% (laminogrammi) Calcolare i laminogrammi per i sinogrammi del punto 2. (funzione ‘iradon’ senza
%filtraggio, interpolazione “linear”, comando Matlab: iradon(I,teta,%linear’,’none’) ). Visualizzare i risultati
laminogramma1=iradon(sinogramma1,-180:1:180,'linear','none'); %laminogramma del punto
laminogramma2=iradon(sinogramma2,-180:1:180,'linear','none'); %laminogramma del fantoccio 128X128
laminogramma3=iradon(sinogramma3,-180:1:180,'linear','none'); %laminogramma del fantoccio 32X32
laminogramma4=iradon(sinogramma_finale,-180:1:180,'linear','none'); %laminogramma del fantoccio circolare
%con rumore
figure; subplot(4,2,1); imagesc(fantoccio1); colormap('gray'); title('punto');
subplot(4,2,2); imagesc(laminogramma1); colormap('gray'); title('laminogramma punto');
subplot(4,2,3); imagesc(fantoccio2); colormap('gray'); title('fantoccio 128X128');
subplot(4,2,4); imagesc(laminogramma2); colormap('gray'); title('laminogramma fant 128X128');
subplot(4,2,5); imagesc(fantoccio3); colormap('gray'); title('fantoccio 32X32');
subplot(4,2,6); imagesc(laminogramma3); colormap('gray'); title('laminogramma fant 32X32')
subplot(4,2,7); imagesc(C1); colormap('gray'); title('fantoccio circolare con rumore')
subplot(4,2,8); imagesc(laminogramma4); colormap('gray'); title('laminogramma fant.circolare con rumore');

%% B
% Ricostruire le immagini dai sinogrammi del punto 2., mediante l’algoritmo BPF, utilizzando come filtro la
%rampa 2D (cono) opportunamente costruita mediante la funzione data (file: "FiltroConico.m”) e i
%laminogrammi calcolati nel punto precedente.
tl1=fftshift(fft2(laminogramma1)); %faccio la trasformata 2D di Fourier del laminogramma e la shifto
%NB: ho già calcolato i laminogrammi al punto precedente.
tl1filtrata=tl1.*FiltroConico(66,66); %applico la filtrazione, operazione puntuale
BPF1=abs(ifft2(tl1filtrata)); %prendo il modulo perchè siamo nel piano complesso. Il modulo 
%dell'inversa della trasformata di Fourier 2D
figure; subplot(2,2,1); imagesc(BPF1); colormap('gray'); title('punto con BPF');

tl2=fftshift(fft2(laminogramma2));%faccio la trasformata 2D di Fourier del laminogramma e la shifto
tl2filtrata=tl2.*FiltroConico(130,130);%applico la filtrazione, operazione puntuale
BPF2=abs(ifft2(tl2filtrata));%prendo il modulo perchè siamo nel piano complesso. Il modulo 
%dell'inversa della trasformata di Fourier 2D
subplot(2,2,2); imagesc(BPF2); colormap('gray'); title('fantoccio 128X128 con BPF');

tl3=fftshift(fft2(laminogramma3));%faccio la trasformata 2D di Fourier del laminogramma e la shifto
tl3filtrata=tl3.*FiltroConico(34,34);%applico la filtrazione, operazione puntuale
BPF3=abs(ifft2(tl3filtrata));%prendo il modulo perchè siamo nel piano complesso. Il modulo 
%dell'inversa della trasformata di Fourier 2D
subplot(2,2,3); imagesc(BPF3); colormap('gray'); title('fantoccio 32X32 con BPF');

tl4=fftshift(fft2(laminogramma4));%faccio la trasformata 2D di Fourier del laminogramma e la shifto
tl4filtrata=tl4.*FiltroConico(130,130);%applico la filtrazione, operazione puntuale
BPF4=abs(ifft2(tl4filtrata));%prendo il modulo perchè siamo nel piano complesso. Il modulo 
%dell'inversa della trasformata di Fourier 2D
subplot(2,2,4); imagesc(BPF4); colormap('gray'); title('fantoccio circolare con rumore con BPF');

%% C
% Ricostruire le immagini dai sinogrammi del punto 2., mediante l’algoritmo FBP, utilizzando come filtro la
%rampa (funzione iradon del Matlab, interpolazione %linear’, con filtro ‘Ram-Lak’).
%Visualizzare i risultati.
FBP1=iradon(sinogramma1,-180:1:180,'linear','Ram-Lak'); %ricostruzione immagini con FBP
figure; subplot(2,2,1); imagesc(FBP1); colormap('gray'); title('punto con FBP');
FBP2=iradon(sinogramma2,-180:1:180,'linear','Ram-Lak');%ricostruzione immagini con FBP
subplot(2,2,2); imagesc(FBP2); colormap('gray');title('fantoccio 128X128 con FBP');
FBP3=iradon(sinogramma3,-180:1:180,'linear','Ram-Lak');%ricostruzione immagini con FBP
subplot(2,2,3); imagesc(FBP3); colormap('gray');title('fantoccio 32X32 FBP');
FBP4=iradon(sinogramma_finale,-180:1:180,'linear','Ram-Lak');%ricostruzione immagini con FBP
subplot(2,2,4); imagesc(FBP4); colormap('gray');title('fantoccio circolare con rumore con FBP');

%% Visualizzazione
figure; colormap gray;
subplot(4,3,1); imagesc(fantoccio1); title('Single Point'); 
subplot(4,3,2); imagesc(BPF1); title('BPF'); 
subplot(4,3,3); imagesc(FBP1); title('FBP');
subplot(4,3,4); imagesc(fantoccio2); title('128x128');
subplot(4,3,5); imagesc(BPF2); title('BPF');
subplot(4,3,6); imagesc(FBP2); title('FBP');
subplot(4,3,7); imagesc(fantoccio3); title('32x32');
subplot(4,3,8); imagesc(BPF3); title('BPF');
subplot(4,3,9); imagesc(FBP3); title('FBP');
subplot(4,3,10); imagesc(C1); title('Fantoccio con attenuazione');
subplot(4,3,11); imagesc(BPF4); title('BPF');
subplot(4,3,12); imagesc(FBP4); title('FBP');

%% D
% (valutazione dei filtri per ricostruzione FBP su dati con rumore) Ricostruire mediante algoritmo FBP
%l%immagine dal fantoccio n. 4 (fantoccio circolare con rumore), utilizzando i seguenti filtri:
%E.1 rampa (Ram-Lak, già implementato nel punto precedente)
%E.2 "shepp-logan”
%E.2 Coseno
%E.3 Hamming
%E.4 Hanning
%Visualizzare i risultati
FBP4=iradon(sinogramma_finale,-180:1:180,'linear','Ram-Lak');%ricostruzione immagini con FBP con filtro Ram-Lak
figure; subplot(5,2,1); imagesc(FBP4); colormap('gray'); title('con filtro Ram-Lak');
subplot(5,2,2); plot(FBP4(length(FBP4)/2,:)); title('Central Row');
FBP4_shepp_logan=iradon(sinogramma_finale,-180:1:180,'linear','Shepp-Logan');%ricostruzione immagini con FBP con filtro 
%Sheep-Logan
subplot(5,2,3); imagesc(FBP4_shepp_logan); colormap('gray'); title('con filtro Sheep-Logan');
subplot(5,2,4); plot(FBP4_shepp_logan(length(FBP4_shepp_logan)/2,:)); title('Central Row');
FBP4_Coseno=iradon(sinogramma_finale,-180:1:180,'linear','Cosine');%ricostruzione immagini con FBP con filtro coseno
subplot(5,2,5); imagesc(FBP4_Coseno); colormap('gray'); title('con filtro coseno');
subplot(5,2,6); plot(FBP4_Coseno(length(FBP4_Coseno)/2,:)); title('Central Row');
FBP4_Hamming=iradon(sinogramma_finale,-180:1:180,'linear','Hamming');%ricostruzione immagini con FBP con filtro Hamming
subplot(5,2,7); imagesc(FBP4_Hamming); colormap('gray'); title('con filtro Hamming');
subplot(5,2,8); plot(FBP4_Hamming(length(FBP4_Hamming)/2,:)); title('Central Row');
FBP4_Hanning=iradon(sinogramma_finale,-180:1:180,'linear','Hann');%ricostruzione immagini con FBP con filtro Hanning
subplot(5,2,9); imagesc(FBP4_Hanning); colormap('gray'); title('con filtro Hanning');
subplot(5,2,10); plot(FBP4_Hanning(length(FBP4_Hanning)/2,:)); title('Central Row');
%% E.1
% Ricostruire le immagini da sinogrammi mediante l%algoritmo ART (vedi diapositive), con il numero di
%iterazioni pari al numero di proiezioni.
%Fantocci da utilizzare: a. fantoccio Matlab 32x32 per 0°£ q <180°, con: Dq= 1°; b. (facoltativo) fantoccio
%circolare con rumore, 128x128 per 0°£ q <180°, con: Dq= 1°
%Visualizzare le immagini risultanti
g=radon(fantoccio3,0:1:180); %g è il sinogramma calcolato del fantoccio 3, quindi dimensioni del sinogramma
f=zeros(size(fantoccio3)); %f ha le dimensione dell'immagine
A=Calcolo_A(181,49,32,32); %Il calcolo della matrice A è stato fornito dalla Professoressa
% a cui dobbiamo passare colonne sinogramma, righe sinogramma, righe
% immagine, colonne immagine
for j=1:181
   for i=1:181
       inizio=49*(i-1)+1;
       fine=49*i;
       A_p=A(inizio:fine,:);%Ad ogni iterazione devo considerare una sotto matrice di A fatta di 
       %49 righe e 1024 colonne
       rapp=(g(:,i)-A_p*f(:))./1024;
       x=A_p'*rapp;
       f=f(:)+x;
        %f(:) perchè da una matrice devo ottenere 
       %ottenere un vettore per far tornare le dimensioni
        %dal vettore devo riottenere la matrice
        f=reshape(f,[32,32]);
   end 
end %il tutto lo ripetiamo per il numero di colonne del sinogramma g
figure; subplot(1,2,1); imagesc(fantoccio3);  colormap('gray'); title('starting image');
subplot(1,2,2); imagesc(f); colormap('gray'); title('ART reconstructed image');
%% E.2
%Ripeto per l'immagine finale, lascio come commento perchè ci vuole tanto
%tempo a farlo girare
g=sinogramma_finale;
f=zeros(size(C1));
A=Calcolo_A(361,185,128,128);
for j=1:361
  for i=1:361
       f_precedente=f;
       A_p=A((185*(i-1)+1):(185*i),:);
       f=f_precedente(:)+((A_p'*(g(:,i)-A_p*f_precedente(:)))/(1024)); 
       f=reshape(f,[128,128]);
  end
end 
figure; subplot(1,2,1); imagesc(C1);  colormap('gray'); title('starting image');
subplot(1,2,2); imagesc(f); colormap('gray'); title('ART reconstructed image'); 




   









    








