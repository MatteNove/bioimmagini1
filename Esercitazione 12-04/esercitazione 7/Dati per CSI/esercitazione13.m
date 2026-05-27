clear all
close all
load("DATI_13C_FourVials.mat");
%% Eseguire la decodifica spaziale
%Abbiamo una matrice 16x16x256 dove 16x16 è il numero dei voxel 
%e per ognuno il segnale FID è lungo 256
kspazio=reshape(DATI,[nRighe_CSI,nColonne_CSI,256]);
% eseguo la decodifica spaziale per ciascuno dei valori temporali del FID :
for k=1:256
    imm(:,:,k)=ifft2(kspazio(:,:,k)); %imm contiene i fid per ogni voxel
end
i=mean(kspazio(:,:,4:14),3); %faccio la media sul K-spazio da 4 a 14
figure, imagesc(abs(i)), title("media su 10 k-spazio");
im=mean(imm(:,:,4:14),3); %faccio la media sulle immagini
figure,imagesc(fftshift(abs(im)));title("media su 10 immagini")
%% Rephasing su ciascun FID
Fc=5000 ;%[Hz] Freq.uenza di campionamento
N=256 ; 
df=Fc/N;
f=df*[-N/2:N/2-1]; % asse frequenziale
time=(1:N)*1/Fc; %asse temporale
phi=[-180:180];
for i=1:16
    for j=1:16
        FID_freq(i,j,:)=fftshift(fft(imm(i,j,:))); %Ottengo il Fid per ogni voxel
        for k=1:length(phi)
            Fid=squeeze((FID_freq(i,j,:)).*(cos(phi(k))+1j*sin(phi(k)))); %cerco il phi che massimizza
            temp(k)=sum(real(Fid(N/2-10:N/2+10,:)),1); %limito la ricerca in un inotrno dello zero
            %come consigliato dal Prof    
        end
        [val,ind]=max(temp); %ricavo il valore e l'indice a cui ho trovato il massimo
        imm_corr(i,j,:)=imm(i,j,:).*exp(1j*phi(ind)); %correggo nel dominio temporale
        FID_freq_corr(i,j,:)=fftshift(fft(imm_corr(i,j,:))); %Spettro dei Fid corretto
    end
end
figure;
subplot(2,2,1); plot(f,real((squeeze(FID_freq(13,5,:))))), title("Parte Reale Spettro in frequenza (non corretto)");
subplot(2,2,2); plot(f,imag((squeeze(FID_freq(13,5,:))))), title("Parte Imm Spettro in frequenza (non corretto)");
subplot(2,2,3); plot(f,real((squeeze(FID_freq_corr(13,5,:))))), title("Parte Reale Spettro in frequenza (corretto)");
subplot(2,2,4); plot(f,imag((squeeze(FID_freq_corr(13,5,:))))), title("Parte Imm Spettro in frequenza (corretto)");
figure;
subplot(2,2,1); plot(time,real((squeeze(imm(13,5,:))))), title("Parte Reale FID (non corretto)");
subplot(2,2,2); plot(time,imag((squeeze(imm(13,5,:))))), title("Parte Imm FID (non corretto)");
subplot(2,2,3); plot(time,real((squeeze(imm_corr(13,5,:))))), title("Parte Reale FID (corretto)");
subplot(2,2,4); plot( time,imag((squeeze(imm_corr(13,5,:))))), title("Parte Imm (corretto)");

%% Stima dei parametri su ciascu Fid
%Definisco due modelli, uno per la parte reale e uno per la parte
%immaginaria
modelFunR=@(p,t) p(1)*exp(-p(2)*t).*cos(2*pi*p(3)*t)...  Acetato
                   +p(4)*exp(-p(5)*t).*cos(2*pi*p(3)*t)... Lattato
                   +p(6)*exp(-p(7)*t).*cos(2*pi*p(8)*t)... Alanina
                   +p(9)*exp(-p(10)*t).*cos(2*pi*p(11)*t)...Glicina

modelFunI=@(p,t) p(1)*exp(-p(2)*t).*sin(2*pi*p(3)*t)... Acetato
                   +p(4)*exp(-p(5)*t).*cos(2*pi*p(3)*t)... Lattato
                   +p(6)*exp(-p(7)*t).*cos(2*pi*p(8)*t)... Alanina
                   +p(9)*exp(-p(10)*t).*cos(2*pi*p(11)*t)...Glicina

%Vado a definire i parametri iniziali
startingVals=[1e6,40,-39,1e6,40,1e5,40,175,1e5,40,280]; %a_k,d_k,f_k 

%Vado a definire upper bound e lower bound : 
lb=[1e3,35,-44,1e3,35,1e3,35,170,1e3,35,270]; 
ub=[1e7,45,-34,1e7,45,1e6,45,180,1e6,45,290];

% definizione opzioni
options=statset('TolFun', 1e-10,'MaxIter',1e6,'TolX',10,'MaxFunEvals',1e8');
options.Algorithm='levenberg-marquardt';  
AcLaMap=zeros(16,16); %NB acetato e lattato hanno la stessa fk per cui la metto nella stessa immagine
AlaMap=zeros(16,16);
GliMap=zeros(16, 16);
for i=1:16
    for j=1:16
        imm_corr_vox=squeeze(imm_corr(i,j,:));
        [coefEstsR,resnorm1R]=lsqcurvefit(modelFunR,startingVals,time,real(imm_corr_vox'),lb,ub,options);
         AcLaMap(i,j)=coefEstsR(1);% a1(lattato e acetato)
         AlaMap(i,j)=coefEstsR(6);% a4(alanina)
         GliMap(i,j)=coefEstsR(9);% a7(glicina)
    end
end
image=double(dicomread('immagine_1H_FourVials'));
figure; subplot(2,2,1), imagesc(image'), colormap gray, title(" Immagine Riferimento");
subplot(2,2,2); imagesc(fftshift(AcLaMap)); colormap gray; colorbar; title("Acetato-Lattato");
subplot(2,2,3); imagesc(fftshift(AlaMap)); colormap gray; colorbar; title("Alanina");
subplot(2,2,4); imagesc(fftshift(GliMap)); colormap gray; colorbar; title("Glicina");

%% Zero padding nella decodifica spaziale [64x64x256]
clear all 
close all
load("DATI_13C_FourVials.mat");
kspazio=reshape(DATI,[nRighe_CSI,nColonne_CSI,256]);
% eseguo la decodifica spaziale per ciascuno dei valori temporali del FID :
for k=1:256
    imm(:,:,k)=ifft2(kspazio(:,:,k),64,64);
end
im=mean(imm(:,:,4:14),3);
figure; imagesc(fftshift(abs(im))); title("media su 10 immagini");
%% Rephasing su ciascun Fid
Fc=5000 ;%[Hz] frequenza di campionamento
N=256; 
df=Fc/N;
f=df*[-N/2:N/2-1]; %asse frequenziale
time=(1:N)*1/Fc; %asse temporale
phi=[-180:180];

for i=1:64
    for j=1:64
        FID_freq(i,j,:)=fftshift(fft(imm(i,j,:))); %Ottengo il Fid per ogni voxel
        for k=1:length(phi) %cerco il phi che massimizza
            Fid=squeeze((FID_freq(i,j,:)).*(cos(phi(k))+1j*sin(phi(k))));
            temp(k)=sum(real(Fid(N/2-10:N/2+10,:)),1); %limito la ricerca in un intorno 
            %dello zero come consigliato dal prof
        end
        [val, ind] = max(temp);
        imm_corr(i,j,:)=imm(i,j,:).*exp(1j*phi(ind)); %correggo nel tempo 
        FID_freq_corr(i,j,:)=fftshift(fft(imm_corr(i,j,:))); %correggo in frequenza

    end
end
%% Stima dei parametri su ciascu Fid
%Definisco i due modelli, uno per la parte reale e uno per la parte
%immaginaria
modelFunR= @(p,t) p(1)*exp(-p(2)*t).*cos(2*pi*p(3)*t)...  Acetato
                   +p(4)*exp(-p(5)*t).*cos(2*pi*p(3)*t)... Lattato
                   +p(6)*exp(-p(7)*t).*cos(2*pi*p(8)*t)... Alanina
                   +p(9)*exp(-p(10)*t).*cos(2*pi*p(11)*t)...Glicina


modelFunI= @(p,t) p(1)*exp(-p(2)*t).*sin(2*pi*p(3)*t)... Acetato
                   +p(4)*exp(-p(5)*t).*sin(2*pi*p(3)*t)... Lattato
                   +p(6)*exp(-p(7)*t).*sin(2*pi*p(8)*t)... Alanina
                   +p(9)*exp(-p(10)*t).*sin(2*pi*p(11)*t)...Glicina

%Vado a definire i parametri iniziali
startingVals=[1e4,40,-39,1e4,40,1e4,40,175,1e4,40,280];  

%Definisco upper bound e lower bound : 
 lb=[1e3,35,-44,1e3,35,1e2,35,170,1e3,35,270];  

 ub=[1e6,45,-34,1e6,45,1e6,45,180,1e6,45,290];  

% definizione opzioni
options=statset('TolFun', 1e-10,'MaxIter',1e6,'TolX',10,'MaxFunEvals',1e8','Display','off');
options.Algorithm='levenberg-marquardt';   % 'trust-region-reflective';

AcLaMap=zeros(64,64); %NB acetato e lattato hanno la stessa fk per cui la metto nella stessa immagine
AlaMap=zeros(64,64);
GliMap=zeros(64, 64);
for i=1:64
    for j=1:64
        imm_corr_vox=squeeze(imm_corr(i,j,:));
        [coefEstsR,resnorm1R]=lsqcurvefit(modelFunR,startingVals,time,real(imm_corr_vox'),lb,ub,options);
         AcLaMap(i,j)=coefEstsR(1);%a1(lattato e acetato)
         AlaMap(i,j)=coefEstsR(6);%a4(alanina)
         GliMap(i,j)=coefEstsR(9);%a7(glicina)
         
    end

end
image=double(dicomread('immagine_1H_FourVials'));
figure; subplot(2,2,1); imagesc(image'); colormap gray; title(" Immagine Riferimento");
subplot(2,2,2); imagesc(fftshift(AcLaMap)); colormap gray ;colorbar, title("Acetato-Lattato");
subplot(2,2,3); imagesc(fftshift(AlaMap)); colormap gray ;colorbar, title("Alanina");
subplot(2,2,4); imagesc(fftshift(GliMap)); colormap gray; colorbar, title("Glicina");
       
%% Zero-Pdding nella codifica spaziale e temporale
clear all
close all
load("DATI_13C_FourVials.mat");
kspazio=reshape(DATI,[nRighe_CSI,nColonne_CSI,256]);
% eseguo la decodifica spaziale per ciascuno dei valori temporali del FID :
for k=1:256
    imm(:,:,k) = ifft2(kspazio(:,:,k),64,64);
end
Fc=5000 ;%[Hz] Freq di campionamento
N=512 ; 
df=Fc/(N);
f=df*[-N/2:N/2-1]; % asse frequenziale
Tc=1/Fc;
time=(1:N)*Tc; %asse temporale
phi=[-180:180];

for i=1:64
    for j=1:64
        fids_t=imm(i,j,:);
        fids_t=squeeze(fids_t);
        FID_freq(i,j,:)=(fft(fids_t,N));
        for k=1:length(phi)
            Fid=fftshift(((FID_freq(i,j,:)).*(cos(phi(k))+1j*sin(phi(k)))));
            Fid=squeeze(Fid);
            temp(k)=sum(real((Fid(N/2-10:N/2+10,:))));
        end
        [val(i,j), ind(i,j)] = max(temp);
        imm_corr(i,j,:) = (ifft(FID_freq(i,j,:))).*exp(1j*phi(ind(i,j))); 
    end
end
im=mean(imm_corr(:,:,4:14),3);
figure,imagesc(fftshift(abs(im)));title("media su 10 immagini")
%% Stima dei parametri su ciascu Fid
%Definisco i due modelli, uno per la parte reale e uno per la parte
%immaginaria

modelFunR= @(p,t) p(1)*exp(-p(2)*t).*cos(2*pi*p(3)*t)...  Acetato
                   +p(4)*exp(-p(5)*t).*cos(2*pi*p(3)*t)... Lattato
                   +p(6)*exp(-p(7)*t).*cos(2*pi*p(8)*t)... Alanina
                   +p(9)*exp(-p(10)*t).*cos(2*pi*p(11)*t)...Glicina


modelFunI= @(p,t) p(1)*exp(-p(2)*t).*sin(2*pi*p(3)*t)... Acetato
                   +p(4)*exp(-p(5)*t).*sin(2*pi*p(3)*t)... Lattato
                   +p(6)*exp(-p(7)*t).*sin(2*pi*p(8)*t)... Alanina
                   +p(9)*exp(-p(10)*t).*sin(2*pi*p(11)*t)...Glicina

%Definisco i valori iniziali
startingVals=[1e4,50,-39,1e4,50,30,40,175,1e3,50,280];   

%Definisco upper bound e lower bound : 
lb = [1e3,45,-44,1e3,45,0,35,170,1e2,40,270];  
ub = [1e5,55,-34,1e5,55,1e3,45,180,1e4,60,290];  


% definisco le opzioni opzioni
options=statset('TolFun', 1e-10,'MaxIter',1e6,'TolX',10,'MaxFunEvals',1e8','Display','off');
options.Algorithm='levenberg-marquardt';   % 'trust-region-reflective';

AcLaMap=zeros(64,64);%NB acetato e lattato hanno la stessa fk per cui la metto nella stessa immagine
AlaMap=zeros(64,64);
GliMap=zeros(64, 64);
for i=1:64
    for j=1:64
        imm_corr_vox=squeeze(imm_corr(i,j,:));
        [coefEstsR,resnorm1R]=lsqcurvefit(modelFunR,startingVals,time,real(imm_corr_vox'),lb,ub,options);
         AcLaMap(i,j)=coefEstsR(1);%a1(lattato e acetato)
         AlaMap(i,j)=coefEstsR(6);%a4(alanina)
         GliMap(i,j)=coefEstsR(9);%(glicina)
    end
end
image=double(dicomread('immagine_1H_FourVials'));
figure; subplot(2,2,1); imagesc(image'); colormap gray; title(" Immagine Riferimento");
        subplot(2,2,2); imagesc(fftshift(AcLaMap)); colormap gray ;colorbar; title("Acetato-Lattato");
        subplot(2,2,3); imagesc(fftshift(AlaMap)); colormap gray ;colorbar; title("Alanina");
        subplot(2,2,4); imagesc(fftshift(GliMap)); colormap gray; colorbar; title("Glicina");



