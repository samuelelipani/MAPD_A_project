clear all
close all

[y,Fs] = audioread("mario.mp3");
disp(strcat("La frequenza di campionamento nativa del file è ", num2str(Fs)," Hz"))
durata_file = 8*60+15; % 8m15s
t = linspace(0, durata_file, length(y));

% prendo il canale 2

durata_tagliata = 2; % mi accontento di 2 secondi
% trovo quale indice corrisponde a questo tempo col solito trucco di
% cercare l'argmin del modulo della differenza
[~,ind] = min(abs(t-durata_tagliata));
tt = t(1:ind); % tempo tagliato 
x = y(1:ind,2); % segnale tagliato
% senza un resampling mi viene un txt di più di 250 mega... meglio
% abbassare Fs! Per scendere da 44100 Hz a 11025 devo moltiplicare per 0.25
% i.e. 1/4
x = resample(x,1,4);
disp(strcat("Nuova frequenza di campionamento: ",num2str(Fs*1/4)," Hz"))
tt = linspace(0,durata_tagliata,length(x))';

plot(tt,x)
title("Segnale vs tempo")
[f,a] = spettroFrequenze(tt,x);
%figure
%plot(f,a)
%title("Spettro del segnale")
% nota che arriva fino alla frequenza di Nyquist (Fs/2) visto che prendo solo mezzo vettore, giustamente
% (ma probabilmente non è una coincidenza, dopotutto quella è la massima
% frequenza leggibile senza ambiguità..?)

% salvo la time series del segnale in un file di testo
%fid = fopen("mario.txt","w");
%fprintf(fid, "%f %f\n", [tt, x]); % se no si mette y per avere i due canali della canzone non tagliata
%fclose(fid);
writematrix([tt, x], "mario.txt");