%geschwindigkeit in feststoffen

laengen = [1.49,1.5,1.51];
alleMetallZeiten = {[874,1758,2630, 3510, 4381];%Messing
[782, 1565, 2339, 3122, 3901];%Kupfer
[598, 1191, 1790, 2380, 2984]};%Alu
rho_metall = [8600, 8950, 2700];
rho_fehler = [200, 50, 100];

fehler_metall=zeros(1,3);
ela_metall=zeros(1,3);
fehler_ela=zeros(1,3);
v_metall=zeros(1,3);
xlim([0 4])
clf
hold on
c_map = {'red', 'green', 'blue'};
for i=(1:3)
    metall = alleMetallZeiten{i};
    metall = diff (metall');
    metall = (metall*1e-6); % zu sekunden
    metall = metall(:);
    v_metall(i) = 2*laengen(i)/mean(metall);
    ela_metall(i) = v_metall(i)^2*rho_metall(i);
    
    delta_l = sqrt(0.0014^2+(0.001/sqrt(6))^2);
    delta_t = sqrt((std(metall))^2+(mean(metall)*0.0001)^2+(0.01*mean(metall)/sqrt(3))^2);
    fehler_metall(i) = sqrt((2/mean(metall) *delta_l)^2+((delta_t*2*laengen(i))/mean(metall)^2)^2);

    fehler_ela(i) = sqrt((4*laengen(i)^2/mean(metall)^2*rho_fehler(i))^2 ...
    +(delta_t*8*laengen(i)^2*rho_metall(i)/mean(metall)^3)^2 ...
    +(delta_l*8*rho_metall(i)*laengen(i)/mean(metall)^2)^2);
    
    x = [0,2*laengen(i)];
    erplot=errorbar(x, [0,mean(metall)], [0,std(metall)]);
    set(erplot,'Color',c_map{i})
    erplot=plot(ones(size(metall))*laengen(i)*2,metall, 'o');
    set(erplot,'Color',c_map{i})
    alleMetallZeiten{i}=metall;
    text(2.,mean(alleMetallZeiten{i}),sprintf('%s ± %s m/s \n %s ± %s GPa',...
    num2str(v_metall(i), 4),...
    num2str(fehler_metall(i), 3), ...
    num2str(ela_metall(i)*1e-9, 3),...
    num2str(fehler_ela(i)*1e-9, 1)))
end

legend('Messing Gerade','Messing Messpunkte', 'Kupfer Gerade', 'Kupfer Messpunkte','Alu Gerade','Alu Messpunkte', 'Location', 'southeast')
xlabel('Distanz [m]')
ylabel('Zeit [ms]')
hold off