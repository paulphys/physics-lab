mittlere_haftkraft = [1,3.51,6.66];
u_mhk = [0.117,0.334,0.539]; % Unsicherheit(standartabweichung)

masse = [284.40,867.92,1451.44];

grid on


scatter(masse,mittlere_haftkraft)
hold on
errorbar(masse,mittlere_haftkraft,u_mhk,'o')
hold on

p = polyfit(masse,mittlere_haftkraft,1);
yfit = polyval(p,masse);
plot(masse,yfit);
hold on 

legend("Messpunkte","Fehlerbalken", "Linear fit");
ylabel('Mittlere Haftkraft in [N]')
xlabel('Masse in [g]')

%hold off