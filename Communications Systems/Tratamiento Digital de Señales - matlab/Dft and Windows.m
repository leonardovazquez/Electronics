%%SEGUNDO PARCIAL


%%grafica a

for i=1:1:26
   xa(i)=1 
end

Xka = fft(xa)

%% grafica b
xb = [1]

for i=2:1:26
   xb(i)=0 
end

Xkb = fft(xb)

%%grafica c d e ... g
clc
clear
%---- SIGNAL PARAMETER
A       = 1;   % amplitud de la señal
fo      = 0.25; % frecuencia de la señal [Hz]
To      = 1/fo; % periodo de la señal [s]


%%----SAMPLING PARAMETERS

N       = 2; %muestras x ciclo
K       = 12.5; %%ciclos en la ventana
fs      = N*fo; % frecuencia de muestreo [Hz]
Ts      = 1/fs; % periodo de muestreo [s]



%---- GENERATE SIGNAL AND SEQUENCE

       tfinal  = K*To;
       t       = linspace(0,tfinal,1e6);
       dt      = 0:Ts:tfinal-Ts;

        d       = 0:To:tfinal;
         xt      = A*cos(2*pi*fo*t);  % CONTINUOS SIGNAL
        xn      = A*cos(2*pi*fo*dt);  % DISCRETE SEQUENCE

%---- GENERATE WINDOW SEQUENCE
M = length(xn);
     wn  = window(@rectwin,M)';

      G   = sum(wn);

%---- DISCRETE TIME FOURIER
xw     = xn.*wn; 
dft    = fft(xw)*(1/G);
k      = 0:1:length(dft)-1;

%---- FIGURES
fig1 = figure;
set(fig1,'defaulttextinterpreter','latex');
plot(t,xt,'k-','LineWIdth',1.5);hold on;
stem(dt,xn,'r','filled','LineWIdth',2);hold off;
legend('x(t)','x[n]');title('Secuencia Discreta Original');
xlabel('Tiempo');ylabel('Amplitud');
grid on;ylim(1.05*[min(xt) max(xt)]);


%---- FIGURES
fig2 = figure;
set(fig2,'defaulttextinterpreter','latex');
stem(k,abs(dft),'r','filled','LineWIdth',2);
title('N-puntos DFT');
xlabel('$k$');ylabel('$|X[k]|$');
ylim([0 max(abs(dft))]*1.1);
grid on;
