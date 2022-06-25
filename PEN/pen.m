tab = readtable('meformated2222.xlsx'); 

schwebungen = [];
kreisfrequenzen = [];

close all

showIntermediate=true;

for i = 1:18
    werte1 = tab{:,i*4-1};
    werte1 = werte1(~isnan(werte1))';
    werte1 = werte1-mean(werte1);
    werte2 = tab{:,i*4};
    werte2 = werte2(~isnan(werte2))';
    werte2 = werte2-mean(werte2);

    %assuming an equaly spaced sample rate of 10Hz like in the example
    zeiten = [0:size(werte1,2)-1]/10;
    if showIntermediate
        figure
        hold on
        plot(werte1)
        plot(werte2)
    end
    signal = werte2;
    %step_time=0.1;
    %sampling_frequency = 1/step_time;
    %nyquist_frequency = sampling_frequency/2;
    %%get spectrum and get it normalized
    %Fourier_trans = fft(signal, 1200);
    %N_ = length(Fourier_trans);
    %a = abs(Fourier_trans)/N_; % amplitude and normalization
    %frequency_vector = linspace(0, 1, fix(N_/2)+1)*nyquist_frequency;
    %idx_vct = 1:length(frequency_vector);
    %finde die dominante Frequenz
    %[maxYValue, indexAtMaxY] = max(a(idx_vct)*2);
    %kreisfrequenzen(end+1)=pi*frequency_vector(indexAtMaxY);
    
    %Bestimme die Kreisfrequenz durch mitteln der Kreisfrequenzen beider
    %Pendel
    %step_time=0.1;
    %Fourier_trans = fft(werte1,1200);
    %N_ = length(Fourier_trans);
    %a = abs(Fourier_trans)/N_; % amplitude and normalization
    %frequency_vector = linspace(0, 1, fix(N_/2)+1)*nyquist_frequency;
    %idx_vct = 1:length(frequency_vector);
    %finde die dominante Frequenz und gebe sie in der Konsole aus
    %[maxYValue, indexAtMaxY] = max(a(idx_vct)*2);
    %kreisfrequenzen(end)=kreisfrequenzen(end)+pi*frequency_vector(indexAtMaxY);

    
    
    [pks,locs] = findpeaks(smooth(signal),'MinPeakDistance',3);
    periode=(locs(end)-locs(1))/numel(locs);
    %vermeidet rundungsfehler die durch die Differenz zwischen den
    %einzelnen Peaks entstehen würden 
    kreisfrequenzen(end+1)=2*pi/(periode/10);
    %finde die Schwebungsfrequenz indem wir den Envelope bilden und davon die
    %frquenz extrahieren
    %und weil diese Behinderte scheiße bei geringen Frequyenzen nicht
    %funktioniert, extrahieren wir stattdessen die peaks des signals,
    %betrachten nur die maxima und berechnen daraus die frequenz
    dsRate=3;
    
    [envTop, envBottom] = envelope(signal);
    envTop = envTop-mean(envTop);
    envTop = smoothdata(downsample(envTop,dsRate),'gaussian',20);
    
    [pks,locs] = findpeaks(envTop,'MinPeakDistance',5);
    %indices = find(pks>0);
    %pks=pks(indices);
    %locs=locs(indices);
    locs = locs *dsRate;
    if showIntermediate
        plot([1:numel(envTop)]*dsRate,envTop);
        plot(locs, pks, '*')
        text(0,0,sprintf('Periode: %s s', num2str(periode/10, 4)))
    end
    if numel(diff(locs))>5
        periode=(locs(end)-locs(1))/numel(locs);
    elseif numel(diff(locs))>2
        periode=diff(locs);
        periode = periode(2);
    elseif numel(diff(locs))>0
        periode=diff(locs);
        periode = periode(1);
    else
        periode = 700
        
    end
    %*2 notwendig, da der envelope die doppelte frequenz der welle bekommt
    %(abs(sin(x)) hat doppelte frequenz von sin(x))
    schwebungen(end+1)=10*pi/periode;%konvertiert von samples zu sekunden
    if showIntermediate
        title(num2str(periode/10,3))
        legend('Pendulum 1', 'Pendulum 2', 'Beat', 'Peaks of the beat')
        hold off
        exportgraphics(gcf,sprintf('tollePlots %s.png', num2str(i, 2)));
    end
end


%s=schwebungen
%gl = gleichphasig, gg=gegenphasig, e=nur eins angestoßen
s_gl_kl = schwebungen(1:3:end/2);
s_gl_gr = schwebungen(end/2+1:3:end);
s_gg_kl = schwebungen(2:3:end/2);
s_gg_gr = schwebungen(end/2+2:3:end);
s_e_kl = schwebungen(3:3:end/2);
s_e_gr = schwebungen(end/2+3:3:end);
%k=kreisfrequenzen
k_gl_kl = kreisfrequenzen(1:3:end/2);
k_gl_gr = kreisfrequenzen(end/2+1:3:end);
k_gg_kl = kreisfrequenzen(2:3:end/2);
k_gg_gr = kreisfrequenzen(end/2+2:3:end);
k_e_kl = kreisfrequenzen(3:3:end/2);
k_e_gr = kreisfrequenzen(end/2+3:3:end);

x=[28.5,53.5,78.5];%Kopplungsabstand in cm

%Aufgabe 11
%Wgl und Wgeg bestimmen, daraus Ws und Wm errechnen
unsicherheit_w = 0.005;
unsicherheit_s = 0.01;

%kleine Feder
w_s_kl = (k_gg_kl-k_gl_kl)/2;
w_m_kl = (k_gg_kl+k_gl_kl)/2;
w_s_kl_f = sqrt((unsicherheit_w*k_gg_kl/2).^2+(unsicherheit_w*k_gl_kl/2).^2);

%Große Feder
w_s_gr = (k_gg_gr-k_gl_gr)/2;
w_m_gr = (k_gg_gr+k_gl_gr)/2;
w_s_gr_f = sqrt((unsicherheit_w*k_gg_gr/2).^2+(unsicherheit_w*k_gl_gr/2).^2);

figure
subplot(1,2,1);
hold on
errorbar(x,w_s_kl,w_s_kl_f)
errorbar(x,w_s_gr,w_s_gr_f)
title('Theoretical beat frequency')
legend('Small spring','Big spring')
xlabel('Coupling distance [cm]')
ylabel('Angular frequency [Hz]')
hold off

subplot(1,2,2);
hold on
errorbar(x,w_m_kl,w_s_kl_f)
errorbar(x,w_m_gr,w_s_gr_f)
title('Theoretical angular frequency')
legend('Small spring','Big spring')
xlabel('Coupling distance [cm]')
ylabel('Angular frequency [Hz]')
hold off

%Aufgabe 12
w_geg = s_e_kl+k_e_kl;
w_gl = k_e_kl-s_e_kl;
kopplung_kl = (w_geg.^2-w_gl.^2)./(w_gl.^2+w_geg.^2);
kopplung_kl_f = sqrt(((unsicherheit_w+unsicherheit_s)*(2 *w_geg.* w_gl.^2)./...
(w_geg.^2 + w_gl.^2).^2).^2+((unsicherheit_w+unsicherheit_s)*(2 *w_geg.^2.* w_gl)./...
(w_geg.^2 + w_gl.^2).^2).^2);

w_geg = s_e_gr+k_e_gr;
w_gl = k_e_gr-s_e_gr;
kopplung_gr = (w_geg.^2-w_gl.^2)./(w_gl.^2+w_geg.^2);
kopplung_gr_f = sqrt(((unsicherheit_w+unsicherheit_s)*(2 *w_geg.* w_gl.^2)./...
(w_geg.^2 + w_gl.^2).^2).^2+((unsicherheit_w+unsicherheit_s)*(2 *w_geg.^2.* w_gl)./...
(w_geg.^2 + w_gl.^2).^2).^2);

figure
hold on
errorbar(x,kopplung_kl,kopplung_kl_f)
errorbar(x,kopplung_gr,kopplung_gr_f)
title('Coupling coefficient Beat')
legend('Small spring','Big spring')
xlabel('Coupling distance [cm]')
ylabel('Coupling coefficient')
hold off


%Aufgabe 13
figure
subplot(1,2,1);
hold on
errorbar(x,s_e_kl,ones(size(s_e_kl))*unsicherheit_s)
errorbar(x,w_s_kl,w_s_kl_f)
errorbar(x,s_e_gr,ones(size(s_e_gr))*unsicherheit_s)
errorbar(x,w_s_gr,w_s_gr_f)
title('Beat frequency')
legend('Small spring','Small spring theoretical','Big spring','Big spring theoretical')
xlabel('Coupling distance [cm]')
ylabel('Angular frequency [Hz]')
hold off

subplot(1,2,2);
hold on
errorbar(x,k_e_kl,ones(size(k_e_kl))*unsicherheit_w)
errorbar(x,w_m_kl,w_s_kl_f)
errorbar(x,k_e_gr,ones(size(k_e_gr))*unsicherheit_w)
errorbar(x,w_m_gr,w_s_gr_f)
title('Angular frequency')
legend('Small spring','Small spring theoretical','Big spring','Big spring theoretical')
xlabel('Coupling distance [cm]')
ylabel('Angular frequency [Hz]')
hold off