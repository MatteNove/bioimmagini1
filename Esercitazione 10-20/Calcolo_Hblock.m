function [H_block] = Calcolo_Hblock(H,nblock,righe,colonne)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%   Trasformazione della Matrice di Sistema in una matrice a blocchi
%%%
%%%   Input ed Output descritti qui sono suggerimenti indicativi che non
%%%   devono necessariamente essere seguiti alla lettera.
%%%   ---------------------------------------------------------------------
%%%   INPUT
%%%   H:     matrice di sistema
%%%   nproj: numero di proiezioni angolari (colonne sinogramma)
%%%   npos: numero di locazioni del rilevatore (righe del sinogramma)
%%%   nblock: numero di subset in cui suddividere H
%%% 
%%%   OUTPUT
%%%   Hblock{i}.block: matrice Hk relativa all'i-esimo blocco di proiezioni
%%%   Hblock{i}.projections: vettore delle proiezioni (indici degli angoli) 
%%%   appartenenti all'i-esimo blocco
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
l=floor(colonne/nblock); %lunghezza colonne del singolo subset
H_block=[];
seq=randperm(nblock);
lblock=(righe*colonne)/(nblock);
for i=1:nblock
    x=seq(i);
    H_block(i).block=H((lblock*(x-1))+1:lblock*x,:);
    H_block(i).ind_start=sub2ind([righe,colonne],1,(l*(x-1)+1));
    H_block(i).ind_end=sub2ind([righe,colonne],159,l*x);
end









