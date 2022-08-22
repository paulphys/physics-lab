u_t = ((m*g)/(6*h*pi*r)-(2*g*r^2*rho)/(9*h))^2 * d_t^2;

u_h = ((-m*g)/(3*h*pi*r) + (4*g*r^2*rho)/(9*h^2))^2 * d_h^2;

u_m = ((g*t)/(6*h*pi*r))^2 * d_m^2;

u_rho = ((2*g*r^2*t)/(9*h))^2 * d_rho^2;

u_r = ((-2*m*g)/(6*h*pi*r^2) - (4*g*r*rho)/(9*h))^2 * d_r^2;

u_vis = sqrt(u_t + u_h + u_m + u_rho + u_r)

u_vis_korr = u_vis / ( 1+2.4*(r/R))

vis = ((2*g*r^2*t)/(9*h)) * ((3*m)/(4*pi*r^3)-rho)

vis_korr = ((2*g*r^2*t)/( (9*h) * (1+2.4*r/R) ) ) * ((3*m)/(4*pi*r^3)-rho)

faktor = 1 / (1+2.4*r/R)