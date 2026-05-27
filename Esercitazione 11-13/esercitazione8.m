load("K_spazio_cuore.mat");
%% A1 Immagine
Im1=abs(ifft2(K_S_cuore128));
Im2=abs(ifft2(K_S_cuore256)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256');
%% A2 Parte centrale del K-Spazio
N1=128;
A1=zeros(N1);
inizio=(N1/2)-20;
fine=(N1/2)+20;
for i=1:N1
    for j=1:N1
        if (i>inizio && i<fine) && (j>inizio && j<fine)
            A1(i,j)=K_S_cuore128(i,j);
        end
    end
end
N2=256;
B1=zeros(N2);
inizio=(N2/2)-20;
fine=(N2/2)+20;
for i=1:N2
    for j=1:N2
        if (i>inizio && i<fine) && (j>inizio && j<fine)
            B1(i,j)=K_S_cuore256(i,j);
        end
    end
end
Im1=abs(ifft2(A1));
Im2=abs(ifft2(B1)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128 centrale k spazio');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256 centrale k spazio');
%% A3 Parte esterna del K-Spazio
N1=128;
A2=zeros(N1);
inizio=(N1/2)-20;
fine=(N1/2)+20;
for i=1:N1
    for j=1:N1
        if (i<inizio || i>fine) && (j<inizio || j>fine)
            A2(i,j)=K_S_cuore128(i,j);
        end
    end
end
N2=256;
B2=zeros(N2);
inizio=(N2/2)-20;
fine=(N2/2)+20;
for i=1:N2
    for j=1:N2
        if (i<inizio || i>fine) || (j<inizio || j>fine)
            B2(i,j)=K_S_cuore256(i,j);
        end
    end
end
Im1=abs(ifft2(A2));
Im2=abs(ifft2(B2)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128 esterna k spazio');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256 esterna k spazio');
%% A4 Una riga si e una no
A3=K_S_cuore128(1,:);
for i=1:N1
    if mod(i,2)==0 && i<N1
        A3=vertcat(A3,K_S_cuore128(i,:));
    end
end
B3=K_S_cuore256(1,:)
for i=1:N2
    if mod(i,2)==0 && i<N2
        B3=vertcat(B3,K_S_cuore256(i,:));
    end
end
Im1=abs(ifft2(A3));
Im2=abs(ifft2(B3)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128 riga si/no k spazio');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256 riga si/no k spazio');

%% A5 60% di righe del K-Spazio
X1=floor(N1*0.6);
inizio=N1/2-X1/2;
fine=N1/2+X1/2;
A5=zeros(N1);
for i=N1:-1:1
    if i>=inizio && i<=fine
        A5(i,:)=K_S_cuore128(i,:);
    end
end
X2=floor(N2*0.6);
inizio=N2/2-X2/2;
fine=N2/2+X2/2;
B5=zeros(N2);
for i=N2:-1:1
    if i>=inizio && i<=fine
        B5(i,:)=K_S_cuore256(i,:);
    end
end
Im1=abs(ifft2(A5));
Im2=abs(ifft2(B5)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128 60% FOV');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256 60% FOV');
Im3=abs(ifft2(K_S_cuore256)); 
figure; subplot(1,2,1); imagesc(Im3); title('modulo ifft2'); colormap gray;
subplot(1,2,2); imagesc(Im2); title('FOV 60%'); colormap gray;
%% A6 Zero-Padding
%x=[zeros(1,64),K_S_cuore128(1,:),zeros(1,64)];
A6=zeros(2*N1);
centro=length(A6)/2;
inizio=centro-N1/2;
fine=centro+N1/2;
a=fine-inizio;
k=1;
for i=1:length(A6)
    if i>inizio && i<=fine
        A6(i,:)=[zeros(1,64),K_S_cuore128(k,:),zeros(1,64)];
        k=k+1;
    end
end
B6=zeros(2*N2);
centro=length(B6)/2;
inizio=centro-N2/2;
fine=centro+N2/2;
a=fine-inizio;
k=1;
for i=1:length(B6)
    if i>inizio && i<=fine
        B6(i,:)=[zeros(1,128),K_S_cuore256(k,:),zeros(1,128)];
        k=k+1;
    end
end
Im1=abs(ifft2(A6));
Im2=abs(ifft2(B6)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128 zero-padding');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256 zero-padding');
%% A7 HALF-FOURIER
l=floor(0.6*N1);
A7=zeros(l,N1);
for i=1:l
    A7(i,:)=K_S_cuore128(i,:);
end
%Im1=abs(ifft2(A7));
%figure; imagesc(Im1); colormap gray;
l=floor(0.6*N2);
B7=zeros(l,N2);
for i=1:l
    B7(i,:)=K_S_cuore256(i,:);
end
Im1=abs(ifft2(A7));
Im2=abs(ifft2(B7)); 
figure; subplot(1,2,1); imagesc(Im1); colormap gray; colorbar; title ('128x128 Half-Fourier');
subplot(1,2,2); imagesc(Im2); colormap gray; colorbar;  title ('256x256 Half-Fourier');





    



