clear all;
close all;
H1=load('Hpoint5.mat'); %filtro 0.5MHz
H2=load('H1.mat'); %filtro 1MHz
H3=load('H5.mat'); %filtro 5MHz

%% Creazione Fantoccio
%A.1 Fantoccio con due cerchi concentrici di raggio 5cm e 
% 3.5cm rispettivamente, su un campo di vista di 20cm, 
% in una matrice di 128x128 pixels
N=128;
cm=0.15625; %un pixel è 0.15625cm
R2=floor((5*128)/20); %raggio più esterno
R1=floor((3.5*128)/20);%raggio più interno
O=64; %centro dell'immagine
%%
%A.2 Associare allo sfondo del fantoccio l’impedenza acustica dell’acqua, 
% al cerchio più esterno l’impedenza del muscolo, al più interno l’impedenza 
% del sangue (il fantoccio dovrebbe simulare il piano 
% assiale di un ventricolo sinistro). 
Fantoccio=zeros(N);
for i=1:N
    for j=1:N
        d=sqrt(((i-O)^(2))+((j-O)^(2)));
        if d>R2
            Fantoccio(i,j)=1.48*10000; %impedenza acustica dell'acqua
        end
        if d<=R2 && d>R1
            Fantoccio(i,j)=1.8*100000; %impedenza acustica del muscolo
        end
        if d<R2 && d<=R1
            Fantoccio(i,j)=1.2*100000; %impedenza acustica sangue
        end
    end
end
figure; imagesc(Fantoccio); colormap gray; colorbar; title('Fantoccio');
%%
%A.3 Aggiungere l’effetto speckle, moltiplicando i dati generati al punto A.2 
% per una distribuzione random con media nulla e varianza a piacere 
% (ad esempio, pari all’1% della varianza dell’immagine A.2 (utilizzare la funzione rand))
Var=0.3;
Var=0.01*Var;
speckle=-Var+(Var+Var)*rand(N,N);
Fantoccio_1=Fantoccio.*speckle;
figure; imagesc(Fantoccio_1); colormap gray; colorbar; title('Speckle');
%% FILTRO 1
Imm1=imfilter(Fantoccio_1,H1.h);
Imm_1=mat2gray(abs(Imm1));
figure; imagesc(Imm_1); colormap gray; colorbar; title('Fantoccio con speckle');
Acqua=0.002*0.01;
Sangue=0.63*0.01;
Muscolo=0.3*0.01;
MHz=0.5;
Imm_attenuata_1=zeros(N,N);
for i=1:N
    for j=1:N
        d=sqrt(((i-O)^(2))+((j-O)^(2)));
        z=sqrt((i-1)^(2)+(j-O)^(2));
        if d>R2
           Imm_attenuata_1(i,j)=exp(-2*z*Acqua*MHz/(cm))*Imm_1(i,j);
        end
        if d<=R2 && d>R1
           Imm_attenuata_1(i,j)=exp(-2*z*Muscolo*MHz/(cm))*Imm_1(i,j);
        end
        if d<R2 && d<=R1
           Imm_attenuata_1(i,j)=exp(-2*z*Sangue*MHz/(cm))*Imm_1(i,j);
        end   
    end
end
figure; imagesc(Imm_attenuata_1); colormap gray; colorbar; title('Effetto attenuazione con trasduttore a 0.5MHz');
figure; plot(Imm_1(:,N/2)); hold on; plot(Imm_attenuata_1(:,N/2)); title('Profilo attenuazione a 0.5MHz');
I1=Imm_attenuata_1(:,N/2);
%% FILTRO 2
Imm2=imfilter(Fantoccio_1,H2.h);
Imm_2=mat2gray(abs(Imm2));
figure; imagesc(Imm_2); colormap gray; colorbar;
Acqua=0.002*0.01;
Sangue=0.63*0.01;
Muscolo=0.3*0.01;
MHz=1;
Imm_attenuata_2=zeros(N,N);
for i=1:N
    for j=1:N
        d=sqrt(((i-O)^(2))+((j-O)^(2)));
        z=sqrt((i-1)^(2)+(j-O)^(2));
        if d>R2
           Imm_attenuata_2(i,j)=exp(-2*z*Acqua*MHz/(cm))*Imm_2(i,j);
        end
        if d<=R2 && d>R1
           Imm_attenuata_2(i,j)=exp(-2*z*Muscolo*MHz/(cm))*Imm_2(i,j);
        end
        if d<R2 && d<=R1
           Imm_attenuata_2(i,j)=exp(-2*z*Sangue*MHz/(cm))*Imm_2(i,j);
        end   
    end
end
figure; imagesc(Imm_attenuata_2); colormap gray; colorbar; title('Effetto attenuazione con trasduttore a 1MHz');
figure; plot(Imm_2(:,N/2)); hold on; plot(Imm_attenuata_2(:,N/2)); title('Profilo attenuazione a 1MHz');
I2=Imm_attenuata_2(:,N/2);
%% FILTRO 3
Imm3=imfilter(Fantoccio_1,H3.h);
Imm_3=mat2gray(abs(Imm3));
figure; imagesc(Imm_3); colormap gray; colorbar;
Acqua=0.002*0.01;
Sangue=0.63*0.01;
Muscolo=0.3*0.01;
MHz=5;
Imm_attenuata_3=zeros(N,N);
for i=1:N
    for j=1:N
        d=sqrt(((i-O)^(2))+((j-O)^(2)));
        z=sqrt((i-1)^(2)+(j-O)^(2));
        if d>R2
           Imm_attenuata_3(i,j)=exp(-2*z*Acqua*MHz/(cm))*Imm_3(i,j);
        end
        if d<=R2 && d>R1
           Imm_attenuata_3(i,j)=exp(-2*z*Muscolo*MHz/(cm))*Imm_3(i,j);
        end
        if d<R2 && d<=R1
           Imm_attenuata_3(i,j)=exp(-2*z*Sangue*MHz/(cm))*Imm_3(i,j);
        end   
    end
end
figure; imagesc(Imm_attenuata_3); colormap gray; colorbar; title('Effetto attenuazione con trasduttore a 5MHz');
figure; plot(Imm_3(:,N/2)); hold on; plot(Imm_attenuata_3(:,N/2)); title('Profilo attenuazione a 5MHz');
I3=Imm_attenuata_3(:,N/2);



