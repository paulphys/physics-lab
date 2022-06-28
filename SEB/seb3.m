neigung = [7.27,11.30,16.80,19.05,2.75];
u_neigung = [0.5,0.5,0.5,0.5,0.5]; % Unsicherheit

% Hangabtriebskraft (parallel)
f_p = [1.19,1.80,2.55,2.85,0.55];
u_f_p = [0.02,0.02,0.05,0.05,0.02]; % Unsicherheit (verschiedene Federn)

f_g = [8.512,8.512,8.512,8.512,8.512];

quo= f_p./f_g;


von = 0:50;
 
neigungs_sin = sind(von);
plot(neigungs_sin)
hold on

errorbar(neigung,quo,u_f_p,u_f_p,u_neigung,u_neigung, 'o')

legend('$\sin(\alpha)$','$F_{\parallel}/F_{g}$','Interpreter','latex');
ylabel('$F_{\parallel}/F_{g}$','Interpreter','latex')
xlabel('Neigungswinkel $\alpha$ in Grad','Interpreter','latex')

hold off