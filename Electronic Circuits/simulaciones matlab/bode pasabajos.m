%%parte pasabajos
% Armo la función transferencia con los valores calculados y utilizando el
% bode verifico las pèrdidas
clc
clear
Wp=1;
Ws=1.7;
Rp=1.5;
Rs=10;
[n,Wc]=cheb1ord(Wp,Ws,Rp,Rs,'s'); %Cálculo del orden del filtro y su frecuencia
                                  %%de corte (Wc de 3dB)
[z,p,k]=cheb1ap(n,Rp); %cálculo de los polos y zeros del filtro normalizado
[numN,denN]=zp2tf(z,p,k); %numerador y denominador de la función normalizada, la
                          %%misma que viene en las tablas
[num den]=cheby1(n,Rp,Wc,'s'); %cálculo del numerador y denominador de H(s) ya
                                %%desnormalizado Según MATLAB
HMatlab=tf(num,den)% Función H(s) generada con los datos de Matlab
figure
bode(HMatlab)
grid on





%%partepasa altos
% Armo la función transferencia con los valores calculados y utilizando el
% bode verifico las pèrdidas
Wp2=1;
Ws2=5;
Rp2=1.5;
Rs2=20;
[n2,Wc2]=cheb1ord(Wp2,Ws2,Rp2,Rs2,'s'); %Cálculo del orden del filtro y su frecuencia
                                  %%de corte (Wc de 3dB)
[z2,p2,k2]=cheb1ap(n2,Rp2); %cálculo de los polos y zeros del filtro normalizado
[numN,denN]=zp2tf(z2,p2,k2); %numerador y denominador de la función normalizada, la
                          %%misma que viene en las tablas
[num2 den2]=cheby1(n2,Rp2,Wc2,'s'); %cálculo del numerador y denominador de H(s) ya
                                %%desnormalizado Según MATLAB
HMatlab2=tf(num2,den2)% Función H(s) generada con los datos de Matlab
figure
bode(HMatlab2)
grid on
