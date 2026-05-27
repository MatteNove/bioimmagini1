
function R0 = FiltroConico(nx,ny)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  Costruzione filtro conico, in frequenza
% %  per un'immagine di dimensioni normalizzate (sixzex x sizey =  1x1 )
% %  nx  =  Numero righe  del laminogramma	
% %  ny = Numero  colonne  del laminogramma
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx = 1/nx; 		%asse spaziale
dy = 1/ny;
 
dfx = 1/(nx*dx); 	%risoluzione in frequenza
dfy = 1/(ny*dy);
 
fx = dfx*(-nx/2+1:nx/2);	%asse frequenze; la freq 0 è a Fmax/2
fy = dfy*(-ny/2+1:ny/2);
[FX,FY] = meshgrid(fx,fy);
  
R0 = sqrt(FX.^2+FY.^2); 			% filtro 2D IN FREQUENZA...
%figure, mesh(fx,fy,R0),grid on,title('filtro rampa 2D (in frequenza)'),...
    %xlabel('f_x'), ylabel('f_y');  %visualizzo il filtro	

 	
