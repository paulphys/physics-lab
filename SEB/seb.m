neigung = [7.27,11.30,16.80,19.05,2.75];
u_neigung = [0.5,0.5,0.5,0.5,0.5]; % Unsicherheit


% Normalkraft
f_n = [8.9,8.85,8.65,8.55,9.00];
u_f_n = [0.1,0.1,0.1,0.1,0.1]; % Unsicherheit

% Hangabtriebskraft (parallel)
f_p = [1.19,1.80,2.55,2.85,0.55];
u_f_p = [0.02,0.02,0.05,0.05,0.02]; % Unsicherheit (verschiedene Federn)

quo_1 = f_p./f_n;
%quo_2 = f_n./f_p;

von = 0:50;

neigungs_tan = tand(von);
plot(neigungs_tan)
hold on

errorbar(neigung,quo_1,u_f_n,u_f_n,u_neigung,u_neigung, 'o')


legend('$\tan(\alpha)$','$F_{\parallel}/F_{\bot}$','Interpreter','latex');
ylabel('$F_{\parallel}/F_{\bot}$','Interpreter','latex')
xlabel('Neigungswinkel $\alpha$ in Grad','Interpreter','latex')

%hold off