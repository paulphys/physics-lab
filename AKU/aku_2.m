%mikrofon messung

zeiten = [0.86,0.86,0.86;1.3,1.38,1.3; 1.76,1.78,1.8; 2.22,2.12,2.16; 2.64,2.61,2.68];
zeiten = zeiten/1000; % convert to seconds
zeiten = zeiten';
mean_boys = mean(zeiten);
stds = std(zeiten);% messunsicherheiten für die einzelnen Punkte
stds=stds*1.32;
zeiten = zeiten(:);
distanzen = [30,30,30,45,45,45,60,60,60,75,75,75,90,90,90];
distanzen = distanzen/100;

p = polyfit(distanzen,zeiten,1); %polynomial values
fitx = unique(distanzen);

ax = gca;
ax.ColorOrder = [1 0 0];

scatter(distanzen, zeiten)
hold on
errorbar(fitx, mean_boys,stds, 'x')

p(1); %steigung
p(2)
p(2)=0; %offset den wir ignorieren
fitx = linspace(0,max(fitx));
fity = polyval(p,fitx);    %a polynomial function
plot(fitx, fity);


%fehlerrechnung
delta_l = sqrt((0.0002/sqrt(6))^2);
delta_t = sqrt((mean(stds))^2+(0.001*mean(zeiten))^2+ ... %Osziloskop genauigkeit
    (0.01*mean(zeiten)/sqrt(3))^2); %Digitale Ablesegenauigkeit dritte Stelle
vfehler = sqrt( ...
    (mean(distanzen)/mean(zeiten)^2*delta_t)^2+ ...%Fehler Zeit
    (delta_l/mean(zeiten))^2); %Fehler Distanz
title(sprintf('Geschwindigkeit %s ± %s m/s',num2str(1/p(1), 3), num2str(vfehler, 2)));

gaskonst = 287.05; %J/kg*K ist die Gaskonstante für luft
%mit rho = p/(R*T) lässt sich k=rho*v^2/p zu v^2/(R*T) vereinfachen
temperatur =273.15+12; %Schätzung mit ± 5 *C Unsicherheit
adabiatenKoeff = (1/p(1))^2/(gaskonst*temperatur)
adabiatenUnsicherheit = sqrt(((1/p(1))^2/(gaskonst*temperatur^2)*5)^2+ ...%Fehler Temperatur
    ((1/p(1))/(gaskonst*temperatur)*vfehler)^2)%Fehler Geschwindigkeit

legend('Messpunkte','Mittelwert mit Standardabweichung', 'Fit', 'Location', 'southeast');
xlabel('Distanz [m]')
ylabel('Zeit [s]')
hold off