neigung = [7.27,11.30,16.80,19.05,2.75];
u_neigung = [0.5,0.5,0.5,0.5,0.5]; % Unsicherheit

% Normalkraft
f_n = [8.9,8.85,8.65,8.55,9.00];
u_f_n = [0.1,0.1,0.1,0.1,0.1]; % Unsicherheit


f_g = [8.512,8.512,8.512,8.512,8.512];

quo= f_n./f_g;

von = 0:50;
 
neigungs_cos = cosd(von);
plot(neigungs_cos)
hold on

errorbar(neigung,quo,u_f_n,u_f_n,u_neigung,u_neigung, 'o')

legend('$\cos(\alpha)$','$F_{\parallel}/F_{g}$','Interpreter','latex');
ylabel('$F_{\parallel}/F_{g}$','Interpreter','latex')
xlabel('Neigungswinkel $\alpha$ in Grad','Interpreter','latex')

hold off