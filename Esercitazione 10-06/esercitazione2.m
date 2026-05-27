%% Generare:
%1. Fantoccio con singolo punto non nullo, su matrice 64x64 (posizionare il pixel non nullo
%lateralmente, non al centro dell%immagine).
%2. Fantoccio implementato in Matlab (comando Phantom) di 128x128 punti
%3. Fantoccio implementato in Matlab (comando Phantom) di 32x32 punti
%4. Fantoccio circolare con emissione media per pixel l=50Bq, di raggio 20cm su un campo di vista di
%70cm, in una matrice di 128x128 pixels.
clear all
close all

fantoccio1=zeros(64,64);
fantoccio1(15,15)=255; %Metto un punto a 255 come suggerito dalla professoressa, fantoccio1.
fantoccio2=phantom(128); %creo il fantoccio2 di dimensioni 128x128.
fantoccio3=phantom(32); %creo il fantoccio3 di dimensioni 32x32.
R=37;% inizio porzione di codice fornita dalla professoressa per creare il fantoccio circolare
%pari a 37 per il FOV.
R2=R^2;  
nx=128;  
ny=nx;
x=1:nx;  
y=1:ny;
[X,Y] = meshgrid(x,y);
mask = (((X-round(nx/2)).^2 +(Y-round(ny/2)).^2 )<= R2);% fine porzione di codice fornita dalla professoressa 
fantoccio4=double(mask);
for i=1:nx
    for j=1:ny
        if fantoccio4(i,j)==1
            fantoccio4(i,j)=poissrnd(50);%fantoccio circolare con emissione media pari a 50
        end
    end
end
%% A
% calcolare il sinogramma del fantoccio 1. (funzione “radon”), per -180°£ q <180°, con Dq= 1° e
%visualizzarne il risultato. (%sino’ gramma)
sinogramma1=radon(fantoccio1,-180:1:180); %funzione che calcola il sinogramma,va fornito il fantoccio 
% e vanno forniti gli angoli con il relativo passo.
figure; subplot(1,2,1); imagesc(fantoccio1); colormap('gray'); title('single point')
subplot(1,2,2); imagesc(sinogramma1); colormap('gray'); title('Sinogramma dteta=1°');
xlabel('teta'); ylabel('s');

%% B
% Calcolare i sinogrammi (funzione “radon”) per -180°£ q <180°, con: Dq= 1°, per i fantocci dei punti 2 e 3.
%Visualizzare i risultati
sinogramma2=radon(fantoccio2,-180:1:180); %funzione che calcola il sinogramma,va fornito il fantoccio 
% e vanno forniti gli angoli con il relativo passo.
figure; subplot(2,2,1); imagesc(fantoccio2); colormap('gray'); title('fantoccio 128x128');
subplot(2,2,2); imagesc(sinogramma2); colormap('gray'); title('Sinogramma dteta=1°');
xlabel('teta'); ylabel('s');
sinogramma3=radon(fantoccio3,-180:1:180); %funzione che calcola il sinogramma,va fornito il fantoccio 
% e vanno forniti gli angoli con il relativo passo.
subplot(2,2,3); imagesc(fantoccio3); colormap('gray'); title('fantoccio 32x32');
subplot(2,2,4); imagesc(sinogramma3); colormap('gray'); title('Sinogramma dteta=1°');
xlabel('teta'); ylabel('s');

%% C.1
%Aggiungere l’effetto dell’attenuazione µ=.05cm-1 e il comportamento poissoniano dell’emissione
%(attenuazione: exp(-µ*l); poisson: mediante la funzione matlab "poissrnd”)
miu=0.05; %coefficente di attenuazione sul pixel, devo fare la proporzione con il campo di vista di 70cm
matrice_attenuazione=double(mask); %preparo la matrice di attenuazione
raggio=37; %ho convertito i 20cm di raggio in pixel
for i=1:nx
    for j=1:ny
        if matrice_attenuazione(i,j)==1
            r=sqrt((i-64)^(2)+(j-64)^(2)); %calcolo r, la crf è centratata in (64,64)
            d=raggio-r; %per usare la formula utilizzata nell'attenuazione devo calcolare la differenza
            %tra il pixel che sto calcolando al passo (i,j) e il raggio.
            %Bisogna ragionare sugli esponenziali crescenti e decrescenti
            matrice_attenuazione(i,j)=exp(-miu*d); %determino l'attenuazione all'interno della maschera 
        end
    end
end
C1=zeros(nx,ny);
for i=1:nx
    for j=1:nx
        C1(i,j)=(fantoccio4(i,j))*matrice_attenuazione(i,j);
    end
end

%% C2
% Generare il sinogramma del fantoccio C1, con -180°£ q <180°, per Dq= 1°
sinogrammaC1=radon(C1,-180:1:180);
figure; subplot(2,2,1); imagesc(C1); colorbar; title('fantoccio attenuato con emissione di Poisson')
riga_centrale_C1=C1(nx/2,:); %Prendo la riga centrale del fantoccio attenuato con emissione di Poisson
subplot(2,2,2); plot(riga_centrale_C1); title('riga centrale');
subplot(2,2,3); imagesc(sinogrammaC1); colorbar; title('sinogramma fantoccio attenuato');
colonna_centrale_C1=sinogrammaC1(:,180);
subplot(2,2,4); plot(colonna_centrale_C1); title('colonna centrale');
%% C3
% Al sinogramma del punto C2, aggiungere l%effetto delle coincidenze accidentali e lo scattering
%random.(coincidenze accidentali: secondo distribuzione di Poisson, con valor medio =10% del massimo del
%sinogramma; le coincidenze accidentali avvengono su tutto il campo di vista.
%Scattering random: è massimo nelle righe centrali del sinogramma, e diminuisce con andamento
%gaussiano, quando ci si allontana dalle righe centrali;
max_sinC1=max(max((sinogrammaC1))); %prendo il massimo del sinogramma C1
valor_medio=0.1*max_sinC1; %il valor medio è il 10% del valore massimo
sinogramma_coincidenze_accidentali_r=poissrnd(valor_medio,size(sinogramma2));


%genero scattering forma gaussiana con il codice dato dalla professoressa
xgauss=linspace(-1,1,size(sinogrammaC1,1));
gaussdata=(exp(-(xgauss).^2)./(2*.0208))';
gaussdata=(gaussdata-min(gaussdata))/(max(gaussdata)-min(gaussdata));
PS=20;
gaussdata=gaussdata*(max_sinC1*PS/100);
phantscatter = poissrnd(repmat(gaussdata,[1,size(sinogrammaC1,2)])); %scattering da aggiungere al sinogramma.
C3=zeros(185,361);
for i=1:185
    for j=1:361
        C3(i,j)=sinogrammaC1(i,j)+sinogramma_coincidenze_accidentali_r(i,j)+phantscatter(i,j);
    end
end
figure; subplot(5,2,1); imagesc(sinogrammaC1); colorbar; title('sinogramma no scattering');
subplot(5,2,2); plot(colonna_centrale_C1); title('colonna centrale')
subplot(5,2,3); imagesc(sinogramma_coincidenze_accidentali_r); colorbar; title('Accidental coincidences');
colonna_centrale_coincidenze_accidentali_r=sinogramma_coincidenze_accidentali_r(:,180);
subplot(5,2,4); plot(colonna_centrale_coincidenze_accidentali_r); title('colonna centrale');
subplot(5,2,5); imagesc(phantscatter); colorbar; title('Random scattering')
colonna_centrale_phantscatter=phantscatter(:,180);
subplot(5,2,6); plot(colonna_centrale_phantscatter); title('colonna centrale');
%% C4
% Al sinogramma del punto C3 aggiungere il rumore di misura (rumore gaussiano bidimensionale, con
%media nulla e deviazione standard pari al 5% del valore massimo del sinogramma)
%Visualizzare i risultati
sinogramma_gaussiano=normrnd(0, 0.05*max_sinC1, size(sinogrammaC1));
subplot(5,2,7); imagesc(sinogramma_gaussiano); colorbar; title('measurement noise');
colonna_centrale_gaussiana=sinogramma_gaussiano(:,180);
subplot(5,2,8); plot(colonna_centrale_gaussiana); title('colonna centrale');
sinogramma_finale=sinogrammaC1+sinogramma_gaussiano+sinogramma_coincidenze_accidentali_r+phantscatter;
subplot(5,2,9); imagesc(sinogramma_finale); colorbar; title('Noisy sin. (scatter.+accident.+measurNoise)')
colonna_centrale_finale=sinogramma_finale(:,180);
subplot(5,2,10); plot(colonna_centrale_finale); title('colonna centrale');









