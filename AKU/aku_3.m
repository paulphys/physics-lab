%stehende welle messung

d10=[6.7,6.5;23.8,23.5;40.8,40.5;58,57.8];
d15=[5.1,5.2;15.5,15.2;	26.8,26.7;	38.5,38.3;	49.7,49.8;	61.5,61.3;	72.2,73];
d5=[15.4,15.3;	49.5,49.7;	83.8,83.5];
alledistanzen = {d5;d10; d15};
frequenz = [500,1000,1500];

v=zeros(1,3);
v_f={[0];[0];[0]};
c_map = parula(12);

clf
hold on
for i=(1:3)
    distanzen3 = alledistanzen{i};
    distanzen3=distanzen3'/100;
    stds = std(distanzen3);
    stds=stds*1.84;

    [x,y] = size(distanzen3); %wie viele messpunkte?
    xachse = (1:y);
    ydata = mean(distanzen3);
    
    errorbar(xachse,ydata, stds)
    ax = gca; %get current axis and set color
    ax.ColorOrderIndex = i;
    p = polyfit(xachse,ydata,1); %finde den fit
    p(2)=0; %offset den wir ignorieren
    fity = polyval(p,linspace(0,max(xachse)));    %a polynomial function evaluated at linspace
    plot(linspace(0,max(xachse)), fity)
    v(i) = 2*p(1)*frequenz(i);
    
    %Fehlerrechnung
    %Unsicherheit Maßband, Ableseunsicherheit, Schwankung Messwerte (obere und untere Annäherung)
    delta_l = sqrt(0.01^2+(0.01/sqrt(6))^2+stds.^2);
    delta_f = sqrt(0.5^2+(frequenz(i)*0.001/sqrt(3))^2);
    for n=xachse
        d= mean(distanzen3);
        v_f{i}(n) = sqrt(...
        (4*delta_l(n)*frequenz(i)/(2*n-1))^2+...
        (4*delta_f*d(n)/(2*n-1))^2);
    end
end
hold off
legend('500 Hz Messung','500 Hz Fit','1000 Hz Messung','1000 Hz Fit', '1500 Hz Messung','1500 Hz Fit')
mean(v)
title(sprintf('Geschwindigkeit %s ± %s m/s', num2str(mean(v), 3),...
    num2str(sqrt(mean(v_f{1})^2 + mean(v_f{2})^2 + mean(v_f{3})^2), 2)))
xlabel('Ordnung n')
ylabel('Rohrlänge l [m]')