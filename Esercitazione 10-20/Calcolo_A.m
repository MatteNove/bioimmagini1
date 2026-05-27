function A = Calcolo_A(na,nb,nx,ny)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Calcolo della Matrice di Sistema A
% %   dati in input:
% %   na: %numero di proiezioni
% %   nb: numero di misure, ovvero numero di locazioni del rilevatore
% (numero di righe del sinogramma)
% %   nx: numero di righe dell'immagine finale
% %   ny: numero di colonne dell'immagine finale
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
% la funzione radon di matlab mette come distanza tra un raggio e l'altro 
% la dimensione di 1 pixel dell'immagine
ray_pix = 1;	                
% centra le coordinate nel centro dell'immagine (in matlab l'origine di
%un'immagine è in alto a sx)
x = (0:nx-1) - (nx-1)/2; 
% cambio segno all'asse y 
y = (-1)*((0:ny-1) - (ny-1)/2);               
%generazione delle nuove coordinate secondo il diagramma di Nyquist                                
[x,y] = ndgrid(x, y); 
%maschera di 1 logici
mask = true(nx,ny);       
%valutazioni logiche
x = x(mask(:));
y = y(mask(:));     
%numero di punti
np = length(x);              
%definizione degli angoli in radianti tra -90 e 90 deg
angle = (1:na)'/na * pi-pi/2;      
%variabile s della trasformata di Radon
s = cos(angle) * x' + sin(angle) * y'; 
% s valutata in base alla dimensione del pixel dell'immagine
s = s / ray_pix;   
% account for ray_spacing / pixel_size
% ottengo valori da -nb/2 a nb/2 mentre matlab vuole indici interi positivi
% scala di nb/2+1
s = s + (nb+1)/2;                         
%indici interi positivi
ibl = floor(s);     
%valore peso per il bin
val = 1 - (s-ibl);                           
%indice del sinogramma
ii = ibl + (0:na-1)'*nb*ones(1,np);            
%diversi casi per diversi FOV
good = ibl(:) >= 1 & ibl(:) < nb;              
if any(~good), warning 'FOV too small', end          
%numero di pixels dell'immagine di partenza
nc = nx * ny; 
jj = find(mask(:))';             
jj = jj(ones(1,na),:);
%val1 coincide con s-ibl
val1 = 1-val;
% definizione della precisione
if 0 
	val = double(single(val));
	val1 = double(single(val1));
end

A1 = sparse(ii(good), jj(good), val(good), nb*na, nc);  % left bin
A2 = sparse(ii(good)+1, jj(good), val1(good), nb*na, nc); % right bin
% la matrice A è (nx*ny,na*nb)   
A = A1 + A2;       
%cambia i valori sulle righe, le ultime diventano le prime e viceversa
A = flipud(A);  

end

