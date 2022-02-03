%*****COMUNICACIONES ANALÓGICAS*******
%-----------------------------------------
%guia 3 ejercicio 1
clc
clear
%%ctes
fm = 1   ;   % 1 Hz
fc = 1e2   ;   % 100 Hz     me aseguro que fm << fc

Ac = 1     ;

u_1  = 0.5 ;   % u<1 
u_2  = 2   ;   % u>1
u_3  = 1   ;   % u=1 DSB

t = 0:(pi/1000):pi ; 

%%señal de entrada

x    = cos(2*pi*fm*t);


%señal AM_1

xc_1 = Ac*(1+u_1*x).*cos(2*pi*fc*t);

%señal AM_2

xc_2 = Ac*(1+u_2*x).*cos(2*pi*fc*t);

%señal DSB

xc_3 = Ac*x.*cos(2*pi*fc*t);

%%figures

figure
hold on
%%señal de entrada

nexttile

plot(t,x);
xlabel('t')
ylabel('señal de entrada')
xlim([0 pi])
ylim([-1.2 1.2])

%%señal am 1

nexttile

plot(t,xc_1);
envelope(xc_1)
xlabel('1000*t/pi')
ylim([-2.5 2.5])
xlim([0 1000])
ylabel('señal am u<1')

%%señal am 2 u>1

nexttile

plot(t,xc_2);
envelope(xc_2)
xlim([0 1000])
ylim([-4 4])
xlabel('1000*t/pi')
ylabel('señal am u>1')

%%señal dsb u=1

nexttile

plot(t,xc_3);
envelope(xc_3)
xlim([0 1000])
ylim([-2 2])
xlabel('1000*t/pi')
ylabel('señal dsb u=1')


hold off

%------------------------
%TRANSFORMADAS DE FOURIER
figure %%nueva figura
hold on

%%parámetros de sampleo

Fs = 10000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 5000;             % Length of signal
t = (0:L-1)*T;        % Time vector

%%espectro de la señal de entrada

X = cos(2*pi*fm*t);


Y = fft(X);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile
plot(f,P1) 
title('Espectro de x(t)')
xlabel('f (Hz)')
ylabel('|X(f)|')
xlim([0 150])

%%espectro de la señal am 1

Xc_1 = Ac*(1+u_1*X).*cos(2*pi*fc*t);


Y = fft(Xc_1);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile
plot(f,P1) 
title('Espectro de xc1(t)')
xlabel('f (Hz)')
ylabel('|Xc1(f)|')
xlim([0 150])

%%espectro de la señal am 2

Xc_2 = Ac*(1+u_2*X).*cos(2*pi*fc*t);


Y = fft(Xc_2);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile
plot(f,P1) 
title('Espectro de xc2(t)')
xlabel('f (Hz)')
ylabel('|Xc1(f)|')
xlim([0 150])


%%espectro de la señal dsb 

Xc_3 = Ac*u_3*X.*cos(2*pi*fc*t);


Y = fft(Xc_3);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

nexttile
plot(f,P1) 
title('Espectro de xc3(t)')
xlabel('f (Hz)')
ylabel('|Xc1(f)|')
xlim([0 150])

hold off
%-----------------------------