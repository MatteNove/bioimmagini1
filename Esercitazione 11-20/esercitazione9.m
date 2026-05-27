
close all
clear 
clc
%% Importale la spirale a 64 giri
% load spirale32giri.mat
load spirale64giri.mat


% I immagine originale con Field of view pari a FOV [cm]. mu è lo spettro 
% campionato sulla spirale. f_nonh_x e f_nonh_x sono le coordinate dei punti 
% della spirale sul piano di Fourier.

figure, imagesc(I), colormap gray, title('immagine originale','Fontsize',14,'fontweight','B')
figure, plot3(f_nonh_x,f_nonh_y,abs(mu)),grid on,...
title('spettro campionato sulla spirale','Fontsize',14,'fontweight','B')

%% Definire le coordinate spaziali 
%--- FARE: 
% Definizione delle coordinate spaziali(x,y), dal FOV e le dimensioni
% dell'immagine I
deltaX=FOVxy(1)/size(I,1);
deltaY=FOVxy(2)/size(I,1);
x=[-FOVxy(1)/2:deltaX:(FOVxy(1)/2)-deltaX];
y=[-FOVxy(2)/2:deltaY:(FOVxy(2)/2)-deltaY];

Z=vertcat(f_nonh_x,f_nonh_y)';

%% Definire le aree con cui pesare i dati
% Definizione delle aree con cui pesare i dati. Usare la funzione voronoin
% e poi la funzione polyarea
[V, C] = voronoin(Z);


%% Calcolare le aree di ciascuna cella
% figura con vertici e celle di voronoi
figure, voronoi(f_nonh_x,f_nonh_y),title('punti della spirale e Celle di Voronoi','Fontsize',14,'fontweight','B');
lunghezza=length(C);
Vettore_Aree=zeros(lunghezza,1);
for i=1:lunghezza
    a=C(i,1);
    vettore=cell2mat(a);
    lunghezza_vettore=length(vettore);
    X=zeros(lunghezza_vettore,1);
    Y=zeros(lunghezza_vettore,1);
    for j=1:lunghezza_vettore
        K=vettore(j);
        X(j)=V(K,1);
        Y(j)=V(K,2);
    end
    Vettore_Aree(i)=polyarea(X,Y);
end

%% Trascurare i dati in periferia
% Trascurare i dati in periferia: ad essi è stata associata un'area di
% voronoi troppo grande perché si trovano all'estremità.

for i=1:lunghezza
    if isnan(Vettore_Aree(i))
        Vettore_Aree(i)=0;
    end
end

%% Definire la matrice E
% Definire la matrice (E) della trasformata inversa discreta di Fourier, 
% il cui elemento (n,m) è dato da: E(n,m)=exp(2*pi*(r(n)*f(m))). 
% r(n) è un vettore che contiene le coordinate (x,y) vettorizzate 
% (usare meshgrid e reshape) dell'immagine; 
% f(m) è un vettore che contiene (f_nonh_x,f_nonh_y)
[X,Y]=meshgrid(x,y);
X_1=reshape(X,[],1);
Y_1=reshape(Y,[],1);
r=[X_1,Y_1];
f=[f_nonh_x',f_nonh_y'];
n=length(r);
m=length(f);
E=zeros(m,n);
for k=1:n
    for j=1:m
        E(j,k)=exp(2*1i*pi*((r(k,1)*f(j,1))+(r(k,2)*f(j,2))));
    end
end
%% Visualizzare l'immagine
H=mu.*Vettore_Aree;
Imm1=H'*E;
Imm1=reshape(Imm1,[length(I),length(I)]);
figure; imagesc(abs(Imm1)); colormap gray;

%% Utilizzare la spirale a 32 giri;

 load spirale32giri.mat
%load spirale64giri.mat


% I immagine originale con Field of view pari a FOV [cm]. mu è lo spettro 
% campionato sulla spirale. f_nonh_x e f_nonh_x sono le coordinate dei punti 
% della spirale sul piano di Fourier.

figure, imagesc(I), colormap gray, title('immagine originale','Fontsize',14,'fontweight','B')
figure, plot3(f_nonh_x,f_nonh_y,abs(mu)),grid on,...
title('spettro campionato sulla spirale','Fontsize',14,'fontweight','B')


%--- FARE: 
% Definizione delle coordinate spaziali(x,y), dal FOV e le dimensioni
% dell'immagine I
deltaX=FOVxy(1)/size(I,1);
deltaY=FOVxy(2)/size(I,1);
x=[-FOVxy(1)/2:deltaX:(FOVxy(1)/2)-deltaX];
y=[-FOVxy(2)/2:deltaY:(FOVxy(2)/2)-deltaY];

Z=vertcat(f_nonh_x,f_nonh_y)';


% Definizione delle aree con cui pesare i dati. Usare la funzione voronoin
% e poi la funzione polyarea
[V, C] = voronoin(Z);



% figura con vertici e celle di voronoi
figure, voronoi(f_nonh_x,f_nonh_y),title('punti della spirale e Celle di Voronoi','Fontsize',14,'fontweight','B');
lunghezza=length(C);
Vettore_Aree=zeros(lunghezza,1);
for i=1:lunghezza
    a=C(i,1);
    vettore=cell2mat(a);
    lunghezza_vettore=length(vettore);
    X=zeros(lunghezza_vettore,1);
    Y=zeros(lunghezza_vettore,1);
    for j=1:lunghezza_vettore
        K=vettore(j);
        X(j)=V(K,1);
        Y(j)=V(K,2);
    end
    Vettore_Aree(i)=polyarea(X,Y);
end

% Trascurare i dati in periferia: ad essi è stata associata un'area di
% voronoi troppo grande perché si trovano all'estremità.

for i=1:lunghezza
    if isnan(Vettore_Aree(i))
        Vettore_Aree(i)=0;
    end
end

% Definire la matrice (E) della trasformata inversa discreta di Fourier, 
% il cui elemento (n,m) è dato da: E(n,m)=exp(2*pi*(r(n)*f(m))). 
% r(n) è un vettore che contiene le coordinate (x,y) vettorizzate 
% (usare meshgrid e reshape) dell'immagine; 
% f(m) è un vettore che contiene (f_nonh_x,f_nonh_y)
[X,Y]=meshgrid(x,y);
X_1=reshape(X,[],1);
Y_1=reshape(Y,[],1);
r=[X_1,Y_1];
f=[f_nonh_x',f_nonh_y'];
n=length(r);
m=length(f);
E=zeros(m,n);
for k=1:n
    for j=1:m
        E(j,k)=exp(2*1i*pi*((r(k,1)*f(j,1))+(r(k,2)*f(j,2))));
    end
end

H=mu.*Vettore_Aree;
Imm2=H'*E;
Imm2=reshape(Imm2,[length(I),length(I)]);
figure; imagesc(abs(Imm2)); colormap gray;
%% Utilizzare la Spirale a 64 giri sottocampionata
%close all
%clear 
%clc

% load spirale32giri.mat
load spirale64giri.mat


% I immagine originale con Field of view pari a FOV [cm]. mu è lo spettro 
% campionato sulla spirale. f_nonh_x e f_nonh_x sono le coordinate dei punti 
% della spirale sul piano di Fourier.

figure, imagesc(I), colormap gray, title('immagine originale','Fontsize',14,'fontweight','B')
figure, plot3(f_nonh_x,f_nonh_y,abs(mu)),grid on,...
title('spettro campionato sulla spirale','Fontsize',14,'fontweight','B')
f_nonh_x=f_nonh_x(1:2:end,1:2:end);
f_nonh_y=f_nonh_y(1:2:end,1:2:end);
mu=mu(1:2:end,1:2:end);

%--- FARE: 
% Definizione delle coordinate spaziali(x,y), dal FOV e le dimensioni
% dell'immagine I
deltaX=FOVxy(1)/size(I,1);
deltaY=FOVxy(2)/size(I,1);
x=[-FOVxy(1)/2:deltaX:(FOVxy(1)/2)-deltaX];
y=[-FOVxy(2)/2:deltaY:(FOVxy(2)/2)-deltaY];

Z=vertcat(f_nonh_x,f_nonh_y)';


% Definizione delle aree con cui pesare i dati. Usare la funzione voronoin
% e poi la funzione polyarea
[V, C] = voronoin(Z);



% figura con vertici e celle di voronoi
figure, voronoi(f_nonh_x,f_nonh_y),title('punti della spirale e Celle di Voronoi','Fontsize',14,'fontweight','B');
lunghezza=length(C);
Vettore_Aree=zeros(lunghezza,1);
for i=1:lunghezza
    a=C(i,1);
    vettore=cell2mat(a);
    lunghezza_vettore=length(vettore);
    X=zeros(lunghezza_vettore,1);
    Y=zeros(lunghezza_vettore,1);
    for j=1:lunghezza_vettore
        K=vettore(j);
        X(j)=V(K,1);
        Y(j)=V(K,2);
    end
    Vettore_Aree(i)=polyarea(X,Y);
end

% Trascurare i dati in periferia: ad essi è stata associata un'area di
% voronoi troppo grande perché si trovano all'estremità.

for i=1:lunghezza
    if isnan(Vettore_Aree(i))
        Vettore_Aree(i)=0;
    end
end

% Definire la matrice (E) della trasformata inversa discreta di Fourier, 
% il cui elemento (n,m) è dato da: E(n,m)=exp(2*pi*(r(n)*f(m))). 
% r(n) è un vettore che contiene le coordinate (x,y) vettorizzate 
% (usare meshgrid e reshape) dell'immagine; 
% f(m) è un vettore che contiene (f_nonh_x,f_nonh_y)
[X,Y]=meshgrid(x,y);
X_1=reshape(X,[],1);
Y_1=reshape(Y,[],1);
r=[X_1,Y_1];
f=[f_nonh_x',f_nonh_y'];
n=length(r);
m=length(f);
E=zeros(m,n);
for k=1:n
    for j=1:m
        E(j,k)=exp(2*1i*pi*((r(k,1)*f(j,1))+(r(k,2)*f(j,2))));
    end
end

H=mu.*Vettore_Aree;
Imm3=H'*E;
Imm3=reshape(Imm3,[length(I),length(I)]);
figure; imagesc(abs(Imm3)); colormap gray;
%% Visualizzare le figure
figure; subplot(2,2,1); imagesc(I); colormap gray;  title('Immagine Originale')
subplot(2,2,2); imagesc(abs(Imm1)); colormap gray;  title('Immagine 64 giri');
subplot(2,2,3); imagesc(abs(Imm2)); colormap gray; title('Immagine 32 giri');
subplot(2,2,4); imagesc(abs(Imm3)); colormap gray; title('Immagine 64 giri sottocampionata');



