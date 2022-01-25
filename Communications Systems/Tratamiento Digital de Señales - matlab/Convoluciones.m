%%%GUIA 7 EJERCICIO 2
clear
clc 

%%DEFINICION DE ENTRADA Y RESPUESTA AL IMPULSO

xn = [0 2 -1 -1 2 0 3 2]

hn = [1 0 1 2]
%%CONVOLUCION LINEAL

yn = conv(xn,hn) 


%%CONVOLUCION CIRCULAR DIRECTA

p = 8

cn = cconv(xn,hn,p)

Ck = fft(cn)

%%CONVOLUCION CIRCULAR INDIRECTA

Xk = fft(xn,p)

Hk = fft(hn,p)


Sk = Hk.*Xk

sn = ifft(Sk)


%%CONVOLUCION CORREGIDA

ycn= ifft(fft(xn,11).*fft(hn,11))


