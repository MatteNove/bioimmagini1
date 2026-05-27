%% A.2
t=0:1:999;
T1=600; %ms
T2=100; %ms
df=10^(-2)*1000; % riporto in Hz
M0=[1,0,0]'; %Magnetizzazione dopo l'impulso a 90 gradi
N=1000;
Mx=zeros(N,1);
My=zeros(N,1);
Mz=zeros(N,1);
for i=1:N
    if i==1
        Mx(1)=M0(1);
        My(1)=M0(2);
        Mz(1)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end

figure; plot(t,Mx,'b') ; hold on; plot(t,My,'--r'); hold on; plot(t,Mz,'g');grid on; legend('Mx','My','Mz');
xlabel('time [ms]'); ylabel('Magnetizzazione');

%% B.1
T1=600; %ms
T2=100; %ms
df=0; %Hz (Assi rotanti)
FA=pi/3; %butto giù di 60 gradi
TR=500; %ms ogni quanto butto giù
t=0:1:4999; %asse temporale
Mz=zeros(length(t),1);
Mx=zeros(length(t),1);
My=zeros(length(t),1);
M0=[0,0,1]'; %magnetizzazione iniziale
for i=1:length(t)
    if i==1
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if mod(i,TR)==0
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); grid on; legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione');
%% FA=90°
T1=600; %ms
T2=100; %ms
df=0; %Hz
FA=pi/2; %butto giù di 60 gradi
TR=500; %ms ogni quanto butto giù
t=0:1:4999; %asse temporale
Mz=zeros(length(t),1);
Mx=zeros(length(t),1);
My=zeros(length(t),1);
M0=[0,0,1]'; %magnetizzazione iniziale
for i=1:length(t)
    if i==1
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if mod(i,TR)==0
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); grid on; legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('FA=90°');
%% FA=10°
T1=600; %ms
T2=100; %ms
df=0; %Hz
FA=pi/18; %butto giù di 60 gradi
TR=500; %ms ogni quanto butto giù
t=0:1:4999; %asse temporale
Mz=zeros(length(t),1);
Mx=zeros(length(t),1);
My=zeros(length(t),1);
M0=[0,0,1]'; %magnetizzazione iniziale
for i=1:length(t)
    if i==1
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if mod(i,TR)==0
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); grid on; legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('FA=10°');
%% TR=200 ms
T1=600; %ms
T2=100; %ms
df=0; %Hz
FA=pi/3; %butto giù di 60 gradi
TR=200; %ms ogni quanto butto giù
t=0:1:2000; %asse temporale
Mz=zeros(length(t),1);
Mx=zeros(length(t),1);
My=zeros(length(t),1);
M0=[0,0,1]'; %magnetizzazione iniziale
for i=1:length(t)
    if i==1
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if mod(i,TR)==0
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
   [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); legend('Mz','Mx','My'); grid on;
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('TR=200ms');
%% TR=3000 ms
T1=600; %ms
T2=100; %ms
df=0; %Hz
FA=pi/3; %butto giù di 60 gradi
TR=3000; %ms ogni quanto butto giù
t=0:1:29999; %asse temporale
Mz=zeros(length(t),1);
Mx=zeros(length(t),1);
My=zeros(length(t),1);
M0=[0,0,1]'; %magnetizzazione iniziale
for i=1:length(t)
    if i==1
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if mod(i,TR)==0
        H=yrot(FA);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('TR=3000ms');
%% SPIN-ECO TE=50 ms
T1=600; %ms
T2=100; %ms
df=10^(-2)*1000; %mHz
TR=500; %ms
TE=50; %ms
t=0:1:499;
Mx=zeros(length(t),1);
My=zeros(length(t),1);
Mz=zeros(length(t),1);
M0=[0;0;1];
FAE=pi;
FAR=pi/2;
for i=1:length(t)
    if i==1
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if i==2
        H=yrot(FAR);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if i==(TE/2+2)
        H=xrot(FAE);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); grid on; legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('TE=50ms');

%% TE=20 ms
T1=600; %ms
T2=100; %ms
df=10^(-2)*1000; %mHz
TR=500; %ms
TE=20; %ms
t=0:1:499;
Mx=zeros(length(t),1);
My=zeros(length(t),1);
Mz=zeros(length(t),1);
M0=[0;0;1];
FAE=pi;
FAR=pi/2;
for i=1:length(t)
    if i==1
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if i==2
        H=yrot(FAR);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if i==(TE/2+2)
        H=xrot(FAE);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); grid on; legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('TE=20ms');

%% TE=70 ms
T1=600; %ms
T2=100; %ms
df=10^(-2)*1000; %mHz
TR=500; %ms
TE=70; %ms
t=0:1:499;
Mx=zeros(length(t),1);
My=zeros(length(t),1);
Mz=zeros(length(t),1);
M0=[0;0;1];
FAE=pi;
FAR=pi/2;
for i=1:length(t)
    if i==1
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if i==2
        H=yrot(FAR);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    if i==(TE/2+2)
        H=xrot(FAE);
        M0=H*M0;
        Mx(i)=M0(1);
        My(i)=M0(2);
        Mz(i)=M0(3);
    end
    [H1,H2]=freeprecess(1,T1,T2,df);
    M0=H1*M0+H2;
    Mx(i)=M0(1);
    My(i)=M0(2);
    Mz(i)=M0(3);
end
figure; plot(t,Mz,'--g'); hold on; plot(t,Mx,'b'); hold on; plot(t,My,'--r'); grid on; legend('Mz','Mx','My');
xlabel('time [ms]'); ylabel('Magnetizzazione'); title('TE=70ms');

%% C.3
N_spin=10;
spin=randi([-50,50],N_spin,1);
T1=600; %ms
T2=100; %ms
TR=500; %ms
TE=50; %ms
FAR=pi/2;
FAE=pi;
t=0:1:499;
Mx=zeros(10,length(t));
My=zeros(10,length(t));
Mz=zeros(10,length(t));
for j=1:N_spin
   M0=[0;0;1];
    for i=1:length(t)
        if i==1
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==2
           H=yrot(FAR);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==(TE/2+2)
           H=xrot(FAE);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        [H1,H2]=freeprecess(1,T1,T2,spin(j));
        M0=H1*M0+H2;
        Mx(j,i)=M0(1);
        My(j,i)=M0(2);
        Mz(j,i)=M0(3);
    end
end
s=zeros(length(t),1);
for k=1:length(t)
    a=mean(Mx(:,k));
    b=mean(My(:,k));
    s(k)=abs(a+1i*b);
end
figure; plot(t,s); grid on; title('TE=50 ms'); xlabel('time [ms]'); ylabel('Magnetizzazione Netta');

%% C4
N_spin=10;
spin=randi([-50,50],N_spin,1);
T1=600; %ms
T2=20; %ms
TR=500; %ms
TE=50; %ms
FAR=pi/2;
FAE=pi;
t=0:1:499;
Mx=zeros(10,length(t));
My=zeros(10,length(t));
Mz=zeros(10,length(t));
for j=1:N_spin
   M0=[0;0;1];
    for i=1:length(t)
        if i==1
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==2
           H=yrot(FAR);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==(TE/2+2)
           H=xrot(FAE);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        [H1,H2]=freeprecess(1,T1,T2,spin(j));
        M0=H1*M0+H2;
        Mx(j,i)=M0(1);
        My(j,i)=M0(2);
        Mz(j,i)=M0(3);
    end
end
s1=zeros(length(t),1);
for k=1:length(t)
    a=mean(Mx(:,k));
    b=mean(My(:,k));
    s1(k)=abs(a+1i*b);
end
N_spin=10;
spin=randi([-50,50],N_spin,1);
T1=600; %ms
T2=50; %ms
TR=500; %ms
TE=50; %ms
FAR=pi/2;
FAE=pi;
t=0:1:499;
Mx=zeros(10,length(t));
My=zeros(10,length(t));
Mz=zeros(10,length(t));
for j=1:N_spin
   M0=[0;0;1];
    for i=1:length(t)
        if i==1
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==2
           H=yrot(FAR);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==(TE/2+2)
           H=xrot(FAE);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        [H1,H2]=freeprecess(1,T1,T2,spin(j));
        M0=H1*M0+H2;
        Mx(j,i)=M0(1);
        My(j,i)=M0(2);
        Mz(j,i)=M0(3);
    end
end
s2=zeros(length(t),1);
for k=1:length(t)
    a=mean(Mx(:,k));
    b=mean(My(:,k));
    s2(k)=abs(a+1i*b);
end
N_spin=10;
spin=randi([-50,50],N_spin,1);
T1=600; %ms
T2=200; %ms
TR=500; %ms
TE=50; %ms
FAR=pi/2;
FAE=pi;
t=0:1:499
Mx=zeros(10,length(t));
My=zeros(10,length(t));
Mz=zeros(10,length(t));
for j=1:N_spin
   M0=[0;0;1];
    for i=1:length(t)
        if i==1
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==2
           H=yrot(FAR);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        if i==(TE/2+2)
           H=xrot(FAE);
           M0=H*M0;
           Mx(j,i)=M0(1);
           My(j,i)=M0(2);
           Mz(j,i)=M0(3);
        end
        [H1,H2]=freeprecess(1,T1,T2,spin(j));
        M0=H1*M0+H2;
        Mx(j,i)=M0(1);
        My(j,i)=M0(2);
        Mz(j,i)=M0(3);
    end
end
s3=zeros(length(t),1);
for k=1:length(t)
    a=mean(Mx(:,k));
    b=mean(My(:,k));
    s3(k)=abs(a+1i*b);
end
figure; plot(t,s1); hold on; plot(t,s2); hold on; plot(t,s3); title('TE=50 ms');
legend('T2=20 ms','T2=50ms','T2=200ms'); xlabel('time [ms]'); ylabel('Magnetizzazione Netta')



















